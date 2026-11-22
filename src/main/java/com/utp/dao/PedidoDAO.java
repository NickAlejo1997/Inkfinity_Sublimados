package com.utp.dao;

import com.utp.config.ConexionBD;
import com.utp.dto.CotizacionDTO;
import com.utp.dto.PedidoDTO;
import com.utp.dto.PedidoHistorialDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {
    public List<PedidoHistorialDTO> listarPorCliente(long clienteId) throws Exception {
        String sql = "SELECT p.id, p.cantidad, p.total, p.creado_en, CASE WHEN p.tipo_producto = 'POLO' THEN CONCAT('Polo ', pv.tejido, ' · talla ', pv.talla, ' · ', pd.nombre) WHEN p.tipo_producto='TAZA' THEN CONCAT('Taza ', p.taza_onzas, ' oz · ', te.nombre) ELSE pa.nombre END AS producto FROM pedido p LEFT JOIN polo_variante pv ON pv.id = p.polo_variante_id LEFT JOIN polo_diseno pd ON pd.codigo = p.diseno_polo_codigo LEFT JOIN taza_empaque te ON te.codigo = p.taza_empaque_codigo LEFT JOIN producto_adicional pa ON pa.id=p.producto_adicional_id WHERE p.cliente_id = ? ORDER BY p.creado_en DESC, p.id DESC";
        List<PedidoHistorialDTO> pedidos = new ArrayList<>();
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    pedidos.add(new PedidoHistorialDTO(rs.getLong("id"), rs.getString("producto"), rs.getInt("cantidad"), rs.getBigDecimal("total"), rs.getTimestamp("creado_en").toLocalDateTime()));
            }
        }
        return pedidos;
    }

    public long guardar(PedidoDTO pedido, CotizacionDTO cotizacion, Long clienteId, Integer variantePolo, Integer onzasTaza, String diseno, String empaque, Integer productoAdicionalId) throws Exception {
        String sql = "INSERT INTO pedido (cliente_id, cliente, tipo_producto, polo_variante_id, taza_onzas, diseno_polo_codigo, taza_empaque_codigo, producto_adicional_id, cantidad, detalle_precio, subtotal, porcentaje_descuento, descuento, base_imponible, porcentaje_igv, igv, total, celular) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = ConexionBD.obtenerConexion(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (clienteId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, clienteId);
            ps.setString(2, cotizacion.getCliente());
            ps.setString(3, pedido.getTipoProducto());
            if (variantePolo == null) ps.setNull(4, Types.INTEGER);
            else ps.setInt(4, variantePolo);
            if (onzasTaza == null) ps.setNull(5, Types.INTEGER);
            else ps.setInt(5, onzasTaza);
            if (diseno == null) ps.setNull(6, Types.VARCHAR);
            else ps.setString(6, diseno);
            if (empaque == null) ps.setNull(7, Types.VARCHAR);
            else ps.setString(7, empaque);
            if (productoAdicionalId == null) ps.setNull(8, Types.INTEGER);
            else ps.setInt(8, productoAdicionalId);
            ps.setInt(9, cotizacion.getCantidad());
            ps.setString(10, cotizacion.getDetallePrecio());
            ps.setBigDecimal(11, cotizacion.getSubtotal());
            ps.setBigDecimal(12, cotizacion.getPorcentajeDescuento());
            ps.setBigDecimal(13, cotizacion.getDescuento());
            ps.setBigDecimal(14, cotizacion.getBaseImponible());
            ps.setBigDecimal(15, cotizacion.getTasaImpuesto());
            ps.setBigDecimal(16, cotizacion.getImpuesto());
            ps.setBigDecimal(17, cotizacion.getTotal());
            ps.setString(18, cotizacion.getCelular());
            ps.executeUpdate();
            try (var keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        }
        throw new Exception("No se pudo guardar el recibo.");
    }
}
