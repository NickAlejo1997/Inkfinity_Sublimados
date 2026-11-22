package com.utp.facade;

import com.utp.dao.AdministracionDAO;
import com.utp.dto.CuentaClienteDTO;
import com.utp.util.SeguridadContrasena;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class AdministracionFacade {
    private final AdministracionDAO dao = new AdministracionDAO();

    public boolean existeAdministrador() throws SQLException {
        return dao.existeSuperAdministrador();
    }

    public void crearAdministrador(String dni, String nombre, String contrasena) throws SQLException {
        validarDni(dni);
        nombre = nombre == null ? "" : nombre.trim();
        if (nombre.length() < 2 || nombre.length() > 80)
            throw new IllegalArgumentException("error.nombreAdmin");
        validarContrasena(contrasena);
        if (dao.existeSuperAdministrador())
            throw new IllegalArgumentException("error.adminUnico");
        byte[] sal = SeguridadContrasena.nuevoSal();
        dao.crearSuperAdministrador(dni, nombre, sal, SeguridadContrasena.generarHash(contrasena, sal));
    }

    public String autenticar(String dni, String contrasena) throws SQLException {
        validarDni(dni);
        if (contrasena == null || contrasena.isEmpty()) throw new IllegalArgumentException("error.claveVacia");
        CuentaClienteDTO cuenta = dao.buscarAdministrador(dni);
        if (cuenta == null || !SeguridadContrasena.verificar(contrasena, cuenta.getSal(), cuenta.getHashContrasena()))
            throw new IllegalArgumentException("error.credenciales");
        return cuenta.getNombres();
    }

    public void ejecutarAccion(String accion, Map<String, String> p) throws SQLException {
        switch (accion) {
            case "actualizarPolo" ->
                    dao.actualizarPrecioPolo(entero(p, "id"), dinero(p, "precio"), checkbox(p, "activo"));
            case "agregarPolo" -> {
                String tejido = requerido(p, "tejido");
                String talla = requerido(p, "talla");
                if (!tejido.matches("[A-Za-z0-9/.-]{2,10}") || !List.of("S", "M", "L", "XL").contains(talla))
                    throw new IllegalArgumentException("error.tejido");
                dao.agregarPolo(tejido, talla, dinero(p, "precio"));
            }
            case "actualizarTaza" ->
                    dao.actualizarTarifasTaza(entero(p, "onzas"), dinero(p, "unidad"), dinero(p, "media"), dinero(p, "docena"), checkbox(p, "activo"));
            case "agregarTaza" -> {
                int onzas = entero(p, "onzas");
                if (onzas < 1 || onzas > 100)
                    throw new IllegalArgumentException("error.capacidad");
                dao.agregarTaza(onzas, dinero(p, "unidad"), dinero(p, "media"), dinero(p, "docena"));
            }
            case "actualizarDiseno" ->
                    dao.actualizarOpcion("polo_diseno", requerido(p, "codigo"), dinero(p, "adicional"), checkbox(p, "activo"));
            case "actualizarEmpaque" ->
                    dao.actualizarEmpaque(requerido(p, "codigo"), requerido(p, "nombre"), dinero(p, "adicional"), checkbox(p, "activo"));
            case "actualizarDescuento" -> {
                int minimo = entero(p, "cantidad");
                if (minimo < 1 || minimo > 10000)
                    throw new IllegalArgumentException("error.minimo");
                porcentaje(p, "porcentaje");
                dao.actualizarDescuento(minimo, dinero(p, "porcentaje"));
            }
            case "eliminarDescuento" -> dao.eliminarDescuento(entero(p, "cantidad"));
            case "actualizarIGV" -> {
                porcentaje(p, "valor");
                dao.actualizarIGV(dinero(p, "valor"));
            }
            case "agregarProducto" ->
                    dao.agregarProducto(texto(p, "nombre", 2, 80), texto(p, "descripcion", 0, 180), dinero(p, "precio"));
            case "actualizarProducto" ->
                    dao.actualizarProducto(entero(p, "id"), texto(p, "nombre", 2, 80), texto(p, "descripcion", 0, 180), dinero(p, "precio"), checkbox(p, "activo"));
            default -> throw new IllegalArgumentException("error.accion");
        }
    }

    public List<Map<String, Object>> pedidos() throws SQLException {
        return dao.listarPedidos();
    }

    public List<Map<String, Object>> polos() throws SQLException {
        return dao.listarPolos();
    }

    public List<Map<String, Object>> tazas() throws SQLException {
        return dao.listarTazas();
    }

    public List<Map<String, Object>> disenos() throws SQLException {
        return dao.listarOpciones("polo_diseno");
    }

    public List<Map<String, Object>> empaques() throws SQLException {
        return dao.listarOpciones("taza_empaque");
    }

    public List<Map<String, Object>> descuentos() throws SQLException {
        return dao.listarDescuentos();
    }

    public List<Map<String, Object>> configuracion() throws SQLException {
        return dao.listarConfiguracion();
    }

    public List<Map<String, Object>> productos() throws SQLException {
        return dao.listarProductosAdicionales();
    }

    private void validarDni(String dni) {
        if (dni == null || !dni.trim().matches("\\d{8}"))
            throw new IllegalArgumentException("error.dni");
    }

    private void validarContrasena(String p) {
        if (p == null || p.length() < 8)
            throw new IllegalArgumentException("error.claveCorta");
    }

    private String requerido(Map<String, String> m, String k) {
        String v = m.get(k);
        if (v == null || v.isBlank()) throw new IllegalArgumentException("error.obligatorio." + k);
        return v.trim();
    }

    private String texto(Map<String, String> m, String k, int min, int max) {
        String v = m.getOrDefault(k, "").trim();
        if (v.length() < min || v.length() > max) throw new IllegalArgumentException("error.texto." + k);
        return v;
    }

    private int entero(Map<String, String> m, String k) {
        try {
            int v = Integer.parseInt(requerido(m, k));
            if (v > 0) return v;
        } catch (NumberFormatException ignored) {
        }
        throw new IllegalArgumentException("error.entero." + k);
    }

    private BigDecimal dinero(Map<String, String> m, String k) {
        try {
            BigDecimal v = new BigDecimal(requerido(m, k));
            if (v.signum() >= 0 && v.scale() <= 2) return v;
        } catch (NumberFormatException ignored) {
        }
        throw new IllegalArgumentException("error.importe." + k);
    }

    private void porcentaje(Map<String, String> m, String k) {
        BigDecimal v = dinero(m, k);
        if (v.compareTo(BigDecimal.valueOf(100)) > 0)
            throw new IllegalArgumentException("error.porcentaje");
    }

    private boolean checkbox(Map<String, String> m, String k) {
        return "on".equals(m.get(k)) || "true".equals(m.get(k));
    }
}
