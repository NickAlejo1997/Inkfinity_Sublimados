package com.utp.dao;

import com.utp.config.ConexionBD;
import com.utp.dto.OpcionPrecioDTO;
import com.utp.dto.PoloDTO;
import com.utp.dto.PrecioTazaDTO;
import com.utp.dto.ProductoAdicionalDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CatalogoDAO {
    public List<ProductoAdicionalDTO> listarProductosAdicionales() throws SQLException {
        List<ProductoAdicionalDTO> productos = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement("SELECT id,nombre,descripcion,precio FROM producto_adicional WHERE activo=TRUE ORDER BY nombre"); ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                productos.add(new ProductoAdicionalDTO(rs.getInt("id"), rs.getString("nombre"), rs.getString("descripcion"), rs.getBigDecimal("precio")));
        }
        return productos;
    }

    public ProductoAdicionalDTO obtenerProductoAdicional(int id) throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement("SELECT id,nombre,descripcion,precio FROM producto_adicional WHERE id=? AND activo=TRUE")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return new ProductoAdicionalDTO(rs.getInt("id"), rs.getString("nombre"), rs.getString("descripcion"), rs.getBigDecimal("precio"));
            }
        }
        return null;
    }

    public List<PoloDTO> listarPolos() throws SQLException {
        String sql = "SELECT id, tejido, talla, precio FROM polo_variante WHERE activo = TRUE ORDER BY tejido, FIELD(talla,'S','M','L','XL')";
        List<PoloDTO> polos = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                polos.add(new PoloDTO(rs.getInt("id"), rs.getString("tejido"), rs.getString("talla"), rs.getBigDecimal("precio")));
        }
        return polos;
    }

    public PoloDTO obtenerPolo(int id) throws SQLException {
        String sql = "SELECT id, tejido, talla, precio FROM polo_variante WHERE id = ? AND activo = TRUE";
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return new PoloDTO(rs.getInt("id"), rs.getString("tejido"), rs.getString("talla"), rs.getBigDecimal("precio"));
            }
        }
        return null;
    }

    public List<Integer> listarOnzasTaza() throws SQLException {
        List<Integer> onzas = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement("SELECT onzas FROM taza WHERE activo = TRUE ORDER BY onzas"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) onzas.add(rs.getInt("onzas"));
        }
        return onzas;
    }

    public List<PrecioTazaDTO> listarPreciosTaza(int onzas) throws SQLException {
        String sql = "SELECT t.onzas, p.unidades_paquete, p.precio FROM taza t JOIN taza_precio p ON p.onzas = t.onzas WHERE t.onzas = ? AND t.activo = TRUE ORDER BY p.unidades_paquete DESC";
        List<PrecioTazaDTO> precios = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, onzas);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    precios.add(new PrecioTazaDTO(rs.getInt("onzas"), rs.getInt("unidades_paquete"), rs.getBigDecimal("precio")));
            }
        }
        return precios;
    }

    public List<PrecioTazaDTO> listarTodasLasTarifasTaza() throws SQLException {
        String sql = "SELECT onzas, unidades_paquete, precio FROM taza_precio ORDER BY onzas, unidades_paquete DESC";
        List<PrecioTazaDTO> precios = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                precios.add(new PrecioTazaDTO(rs.getInt("onzas"), rs.getInt("unidades_paquete"), rs.getBigDecimal("precio")));
        }
        return precios;
    }

    public List<OpcionPrecioDTO> listarDisenosPolo() throws SQLException {
        return listarOpciones("SELECT codigo, nombre, adicional_unitario AS adicional FROM polo_diseno WHERE activo = TRUE ORDER BY adicional_unitario");
    }

    public List<OpcionPrecioDTO> listarEmpaquesTaza() throws SQLException {
        return listarOpciones("SELECT codigo, nombre, adicional_unitario AS adicional FROM taza_empaque WHERE activo = TRUE ORDER BY adicional_unitario");
    }

    private List<OpcionPrecioDTO> listarOpciones(String sql) throws SQLException {
        List<OpcionPrecioDTO> opciones = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                opciones.add(new OpcionPrecioDTO(rs.getString("codigo"), rs.getString("nombre"), rs.getBigDecimal("adicional")));
        }
        return opciones;
    }

    public OpcionPrecioDTO obtenerDisenoPolo(String codigo) throws SQLException {
        return obtenerOpcion("SELECT codigo, nombre, adicional_unitario AS adicional FROM polo_diseno WHERE codigo = ? AND activo = TRUE", codigo);
    }

    public OpcionPrecioDTO obtenerEmpaqueTaza(String codigo) throws SQLException {
        return obtenerOpcion("SELECT codigo, nombre, adicional_unitario AS adicional FROM taza_empaque WHERE codigo = ? AND activo = TRUE", codigo);
    }

    private OpcionPrecioDTO obtenerOpcion(String sql, String codigo) throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, codigo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return new OpcionPrecioDTO(rs.getString("codigo"), rs.getString("nombre"), rs.getBigDecimal("adicional"));
            }
        }
        return null;
    }

    public java.math.BigDecimal obtenerTasaImpuesto() throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement("SELECT valor FROM configuracion WHERE clave = 'igv_porcentaje'"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        }
        throw new SQLException("No se encontró la configuración del IGV.");
    }

    public java.math.BigDecimal obtenerDescuentoPolo(int cantidad) throws SQLException {
        String sql = "SELECT porcentaje FROM descuento_polo WHERE cantidad_minima <= ? ORDER BY cantidad_minima DESC LIMIT 1";
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getBigDecimal(1) : java.math.BigDecimal.ZERO;
            }
        }
    }
}
