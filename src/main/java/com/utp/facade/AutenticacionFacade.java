package com.utp.facade;

import com.utp.dao.ClienteDAO;
import com.utp.dto.ClienteSesionDTO;
import com.utp.dto.CuentaClienteDTO;
import com.utp.dto.RegistroClienteDTO;
import com.utp.util.SeguridadContrasena;

import java.sql.SQLException;

public class AutenticacionFacade {
    private final ClienteDAO clienteDAO = new ClienteDAO();

    public ClienteSesionDTO iniciarSesion(String dni, String contrasena) throws SQLException {
        validarDni(dni);
        if (contrasena == null || contrasena.isEmpty()) throw new IllegalArgumentException("error.claveVacia");
        CuentaClienteDTO cuenta = clienteDAO.buscarPorDni(dni);
        if (cuenta == null || !SeguridadContrasena.verificar(contrasena, cuenta.getSal(), cuenta.getHashContrasena())) {
            throw new IllegalArgumentException("error.credenciales");
        }
        return new ClienteSesionDTO(cuenta.getId(), cuenta.getDni(), cuenta.getNombres(), cuenta.getApellidos(), cuenta.getCelular());
    }

    public ClienteSesionDTO registrar(RegistroClienteDTO cliente) throws SQLException {
        cliente.setDni(cliente.getDni() == null ? "" : cliente.getDni().trim());
        cliente.setNombres(limpiarNombre(cliente.getNombres()));
        cliente.setApellidos(limpiarNombre(cliente.getApellidos()));
        validarDni(cliente.getDni());
        validarNombre(cliente.getNombres(), "nombres");
        validarNombre(cliente.getApellidos(), "apellidos");
        cliente.setCelular(cliente.getCelular() == null ? "" : cliente.getCelular().trim());
        if (!cliente.getCelular().matches("9\\d{8}"))
            throw new IllegalArgumentException("error.celular");
        if (cliente.getContrasena() == null || cliente.getContrasena().length() < 8)
            throw new IllegalArgumentException("error.claveCorta");
        if (!cliente.getContrasena().equals(cliente.getConfirmarContrasena()))
            throw new IllegalArgumentException("error.confirmacion");
        byte[] sal = SeguridadContrasena.nuevoSal();
        long id;
        try {
            id = clienteDAO.registrar(cliente, sal, SeguridadContrasena.generarHash(cliente.getContrasena(), sal));
        } catch (SQLException ex) {
            if ("23000".equals(ex.getSQLState()))
                throw new IllegalArgumentException("error.dniUsado");
            throw ex;
        }
        return new ClienteSesionDTO(id, cliente.getDni(), cliente.getNombres(), cliente.getApellidos(), cliente.getCelular());
    }

    private void validarDni(String dni) {
        if (dni == null || !dni.trim().matches("\\d{8}"))
            throw new IllegalArgumentException("error.dni");
    }

    private String limpiarNombre(String nombre) {
        return nombre == null ? "" : nombre.trim().replaceAll("\\s+", " ");
    }

    private void validarNombre(String nombre, String campo) {
        if (nombre.length() < 2 || nombre.length() > 60)
            throw new IllegalArgumentException("error." + campo);
    }
}
