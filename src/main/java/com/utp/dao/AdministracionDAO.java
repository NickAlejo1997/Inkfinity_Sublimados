package com.utp.dao;

import com.utp.config.ConexionBD;
import com.utp.dto.CuentaClienteDTO;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AdministracionDAO {
    public boolean existeSuperAdministrador() throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement("SELECT 1 FROM administrador WHERE id = 1"); ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }
    }

    public void crearSuperAdministrador(String dni, String nombre, byte[] sal, byte[] hash) throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion()) {
            c.setAutoCommit(false);
            try (PreparedStatement lock = c.prepareStatement("SELECT id FROM administrador FOR UPDATE")) {
                lock.executeQuery().close();
            }
            try (PreparedStatement ps = c.prepareStatement("INSERT INTO administrador (id, dni, nombre, sal_contrasena, hash_contrasena) VALUES (1, ?, ?, ?, ?)")) {
                ps.setString(1, dni);
                ps.setString(2, nombre);
                ps.setBytes(3, sal);
                ps.setBytes(4, hash);
                ps.executeUpdate();
                c.commit();
            } catch (SQLException ex) {
                c.rollback();
                throw ex;
            }
        }
    }

    public CuentaClienteDTO buscarAdministrador(String dni) throws SQLException {
        String sql = "SELECT id, dni, nombre, sal_contrasena, hash_contrasena FROM administrador WHERE id = 1 AND dni = ?";
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return new CuentaClienteDTO(rs.getLong("id"), rs.getString("dni"), rs.getString("nombre"), "Superadministrador", null, rs.getBytes("sal_contrasena"), rs.getBytes("hash_contrasena"));
            }
        }
        return null;
    }

    public List<Map<String, Object>> listarPedidos() throws SQLException {
        String sql = "SELECT p.id,p.cliente,p.tipo_producto,p.cantidad,p.detalle_precio,p.subtotal,p.descuento,p.base_imponible,p.porcentaje_igv,p.igv,p.total,p.creado_en,IF(c.id IS NULL,'No registrado','Registrado') AS estado_cliente, c.dni,COALESCE(p.celular,c.celular) AS celular FROM pedido p LEFT JOIN cliente c ON c.id=p.cliente_id ORDER BY p.creado_en DESC,p.id DESC";
        return consultar(sql);
    }

    public List<Map<String, Object>> listarPolos() throws SQLException {
        return consultar("SELECT id,tejido,talla,precio,activo FROM polo_variante ORDER BY tejido, FIELD(talla,'S','M','L','XL')");
    }

    public List<Map<String, Object>> listarTazas() throws SQLException {
        return consultar("SELECT t.onzas,MAX(CASE WHEN p.unidades_paquete=1 THEN p.precio END) AS unidad,MAX(CASE WHEN p.unidades_paquete=6 THEN p.precio END) AS media_docena,MAX(CASE WHEN p.unidades_paquete=12 THEN p.precio END) AS docena,t.activo FROM taza t LEFT JOIN taza_precio p ON p.onzas=t.onzas GROUP BY t.onzas,t.activo ORDER BY t.onzas");
    }

    public List<Map<String, Object>> listarOpciones(String tabla) throws SQLException {
        if (!"polo_diseno".equals(tabla) && !"taza_empaque".equals(tabla))
            throw new IllegalArgumentException("error.catalogo");
        return consultar("SELECT codigo,nombre,adicional_unitario,activo FROM " + tabla + " ORDER BY nombre");
    }

    public List<Map<String, Object>> listarDescuentos() throws SQLException {
        return consultar("SELECT cantidad_minima,porcentaje FROM descuento_polo ORDER BY cantidad_minima");
    }

    public List<Map<String, Object>> listarConfiguracion() throws SQLException {
        return consultar("SELECT clave,valor,descripcion FROM configuracion ORDER BY clave");
    }

    public List<Map<String, Object>> listarProductosAdicionales() throws SQLException {
        return consultar("SELECT id,nombre,descripcion,precio,activo FROM producto_adicional ORDER BY nombre");
    }

    public void actualizarPrecioPolo(int id, BigDecimal precio, boolean activo) throws SQLException {
        ejecutar("UPDATE polo_variante SET precio=?,activo=? WHERE id=?", precio, activo, id);
    }

    public void agregarPolo(String tejido, String talla, BigDecimal precio) throws SQLException {
        ejecutar("INSERT INTO polo_variante (tejido,talla,precio) VALUES (?,?,?)", tejido, talla, precio);
    }

    public void actualizarTarifasTaza(int onzas, BigDecimal unidad, BigDecimal media, BigDecimal docena, boolean activo) throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion()) {
            c.setAutoCommit(false);
            try (PreparedStatement taza = c.prepareStatement("UPDATE taza SET activo=? WHERE onzas=?"); PreparedStatement tarifa = c.prepareStatement("UPDATE taza_precio SET precio=? WHERE onzas=? AND unidades_paquete=?")) {
                taza.setBoolean(1, activo);
                taza.setInt(2, onzas);
                if (taza.executeUpdate() != 1) throw new SQLException("No existe esa taza.");
                actualizarTarifa(tarifa, onzas, 1, unidad);
                actualizarTarifa(tarifa, onzas, 6, media);
                actualizarTarifa(tarifa, onzas, 12, docena);
                c.commit();
            } catch (SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }

    private void actualizarTarifa(PreparedStatement ps, int onzas, int paquete, BigDecimal precio) throws SQLException {
        ps.setBigDecimal(1, precio);
        ps.setInt(2, onzas);
        ps.setInt(3, paquete);
        if (ps.executeUpdate() != 1) throw new SQLException("Falta una tarifa de taza en la base de datos.");
    }

    public void agregarTaza(int onzas, BigDecimal unidad, BigDecimal media, BigDecimal docena) throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion()) {
            c.setAutoCommit(false);
            try (PreparedStatement t = c.prepareStatement("INSERT INTO taza(onzas) VALUES(?)"); PreparedStatement p = c.prepareStatement("INSERT INTO taza_precio(onzas,unidades_paquete,precio) VALUES(?,?,?)")) {
                t.setInt(1, onzas);
                t.executeUpdate();
                for (Object[] x : new Object[][]{{1, unidad}, {6, media}, {12, docena}}) {
                    p.setInt(1, onzas);
                    p.setInt(2, (int) x[0]);
                    p.setBigDecimal(3, (BigDecimal) x[1]);
                    p.addBatch();
                }
                p.executeBatch();
                c.commit();
            } catch (SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }

    public void actualizarOpcion(String tabla, String codigo, BigDecimal adicional, boolean activo) throws SQLException {
        if (!"polo_diseno".equals(tabla) && !"taza_empaque".equals(tabla))
            throw new IllegalArgumentException("error.catalogo");
        ejecutar("UPDATE " + tabla + " SET adicional_unitario=?,activo=? WHERE codigo=?", adicional, activo, codigo);
    }

    public void actualizarDescuento(int cantidad, BigDecimal porcentaje) throws SQLException {
        ejecutar("INSERT INTO descuento_polo(cantidad_minima,porcentaje) VALUES(?,?) ON DUPLICATE KEY UPDATE porcentaje=VALUES(porcentaje)", cantidad, porcentaje);
    }

    public void eliminarDescuento(int cantidad) throws SQLException {
        if (cantidad == 1) throw new IllegalArgumentException("error.tramoBase");
        ejecutar("DELETE FROM descuento_polo WHERE cantidad_minima=?", cantidad);
    }

    public void actualizarIGV(BigDecimal tasa) throws SQLException {
        ejecutar("UPDATE configuracion SET valor=? WHERE clave='igv_porcentaje'", tasa);
    }

    public void actualizarEmpaque(String codigo, String nombre, BigDecimal adicional, boolean activo) throws SQLException {
        ejecutar("UPDATE taza_empaque SET nombre=?,adicional_unitario=?,activo=? WHERE codigo=?", nombre, adicional, activo, codigo);
    }

    public void agregarProducto(String nombre, String descripcion, BigDecimal precio) throws SQLException {
        ejecutar("INSERT INTO producto_adicional(nombre,descripcion,precio) VALUES(?,?,?)", nombre, descripcion, precio);
    }

    public void actualizarProducto(int id, String nombre, String descripcion, BigDecimal precio, boolean activo) throws SQLException {
        ejecutar("UPDATE producto_adicional SET nombre=?,descripcion=?,precio=?,activo=? WHERE id=?", nombre, descripcion, precio, activo, id);
    }

    private List<Map<String, Object>> consultar(String sql) throws SQLException {
        List<Map<String, Object>> filas = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            int n = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                Map<String, Object> fila = new LinkedHashMap<>();
                for (int i = 1; i <= n; i++) fila.put(rs.getMetaData().getColumnLabel(i), rs.getObject(i));
                filas.add(fila);
            }
        }
        return filas;
    }

    private void ejecutar(String sql, Object... valores) throws SQLException {
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < valores.length; i++) {
                Object v = valores[i];
                if (v instanceof BigDecimal b) ps.setBigDecimal(i + 1, b);
                else if (v instanceof Boolean b) ps.setBoolean(i + 1, b);
                else if (v instanceof Integer n) ps.setInt(i + 1, n);
                else ps.setString(i + 1, String.valueOf(v));
            }
            ps.executeUpdate();
        }
    }
}
