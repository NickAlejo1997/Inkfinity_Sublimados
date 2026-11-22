package com.utp.dao;

import com.utp.config.ConexionBD;
import com.utp.dto.CuentaClienteDTO;
import com.utp.dto.RegistroClienteDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ClienteDAO {
    public CuentaClienteDTO buscarPorDni(String dni) throws SQLException {
        String sql = "SELECT id, dni, nombres, apellidos, celular, sal_contrasena, hash_contrasena FROM cliente WHERE dni = ? AND activo = TRUE";
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return new CuentaClienteDTO(rs.getLong("id"), rs.getString("dni"), rs.getString("nombres"), rs.getString("apellidos"), rs.getString("celular"), rs.getBytes("sal_contrasena"), rs.getBytes("hash_contrasena"));
            }
        }
        return null;
    }

    public long registrar(RegistroClienteDTO cliente, byte[] sal, byte[] hash) throws SQLException {
        String sql = "INSERT INTO cliente (dni, nombres, apellidos, celular, sal_contrasena, hash_contrasena) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, cliente.getDni());
            ps.setString(2, cliente.getNombres());
            ps.setString(3, cliente.getApellidos());
            ps.setString(4, cliente.getCelular());
            ps.setBytes(5, sal);
            ps.setBytes(6, hash);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        }
        throw new SQLException("No se pudo crear la cuenta del cliente.");
    }
}
