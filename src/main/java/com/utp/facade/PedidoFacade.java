package com.utp.facade;

import com.utp.dao.CatalogoDAO;
import com.utp.i18n.TextoRecibo;
import com.utp.dao.PedidoDAO;
import com.utp.dto.CotizacionDTO;
import com.utp.dto.FormularioPedidoDTO;
import com.utp.dto.OpcionPrecioDTO;
import com.utp.dto.PedidoDTO;
import com.utp.dto.PoloDTO;
import com.utp.dto.PrecioTazaDTO;
import com.utp.dto.PedidoHistorialDTO;
import com.utp.dto.ProductoAdicionalDTO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

/** Fachada de la cotización: coordina catálogo, reglas de negocio y persistencia. */
public class PedidoFacade {
    private static final BigDecimal CIEN = new BigDecimal("100");
    private final CatalogoDAO catalogoDAO = new CatalogoDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();

    public FormularioPedidoDTO prepararFormulario() throws SQLException {
        return new FormularioPedidoDTO(catalogoDAO.listarPolos(), catalogoDAO.listarOnzasTaza(), catalogoDAO.listarTodasLasTarifasTaza(),
                catalogoDAO.listarDisenosPolo(), catalogoDAO.listarEmpaquesTaza(),catalogoDAO.listarProductosAdicionales());
    }

    public List<PedidoHistorialDTO> obtenerHistorial(long clienteId) throws Exception {
        return pedidoDAO.listarPorCliente(clienteId);
    }

    public CotizacionDTO calcularYGuardar(PedidoDTO pedido, Long clienteId) throws Exception {
        String cliente = pedido.getCliente() == null ? "" : pedido.getCliente().trim();
        if (cliente.length() < 3 || cliente.length() > 80) throw new IllegalArgumentException("error.nombreCliente");
        String celular = pedido.getCelular() == null ? "" : pedido.getCelular().trim();
        if (!celular.matches("9[0-9]{8}"))
            throw new IllegalArgumentException("error.celular");

        int cantidad = enteroPositivo(pedido.getCantidad());
        CotizacionDTO cotizacion = new CotizacionDTO();
        cotizacion.setCliente(cliente);
        cotizacion.setCelular(celular);
        cotizacion.setCantidad(cantidad);
        cotizacion.setTasaImpuesto(catalogoDAO.obtenerTasaImpuesto());

        Integer poloId = null;
        Integer onzas = null;
        String codigoDiseno = null;
        String codigoEmpaque = null;
        Integer productoAdicionalId = null;

        if ("POLO".equals(pedido.getTipoProducto())) {
            poloId = enteroPositivo(pedido.getVariantePolo());
            PoloDTO polo = catalogoDAO.obtenerPolo(poloId);
            if (polo == null) throw new IllegalArgumentException("error.variante");
            OpcionPrecioDTO diseno = catalogoDAO.obtenerDisenoPolo(pedido.getDisenoPolo());
            if (diseno == null) throw new IllegalArgumentException("error.diseno");
            codigoDiseno = diseno.getCodigo();
            BigDecimal precioDiseno = diseno.getAdicional().multiply(BigDecimal.valueOf(cantidad));
            BigDecimal subtotal = polo.getPrecio().add(diseno.getAdicional()).multiply(BigDecimal.valueOf(cantidad));
            BigDecimal porcentaje = catalogoDAO.obtenerDescuentoPolo(cantidad);
            BigDecimal descuento = porcentaje(subtotal, porcentaje);

            cotizacion.setProductoVista(new TextoRecibo("producto.polo"));
            cotizacion.setDetalleVista(new TextoRecibo("recibo.poloDetalle", polo.getTejido(), polo.getTalla(), diseno.getNombre()));
            cotizacion.agregarPrecioVista(new TextoRecibo("recibo.precioPolo", cantidad, moneda(polo.getPrecio()), moneda(precioDiseno)));
            cotizacion.setProducto("Polo");
            cotizacion.setDetalle(polo.getDescripcion() + " · " + diseno.getNombre());
            cotizacion.setDetallePrecio(cantidad + " × S/ " + moneda(polo.getPrecio()) + " + diseño S/ " + moneda(precioDiseno));
            cotizacion.setPrecioUnitario(polo.getPrecio());
            cotizacion.setAdicional(precioDiseno);
            cotizacion.setSubtotal(moneda(subtotal));
            cotizacion.setPorcentajeDescuento(porcentaje);
            cotizacion.setDescuento(moneda(descuento));
            cotizacion.setEmpaque("No aplica");
        } else if ("TAZA".equals(pedido.getTipoProducto())) {
            onzas = enteroPositivo(pedido.getOnzasTaza());
            List<PrecioTazaDTO> tarifas = catalogoDAO.listarPreciosTaza(onzas);
            if (tarifas.isEmpty()) throw new IllegalArgumentException("error.taza");
            Map<Integer, BigDecimal> preciosPaquete = new HashMap<>();
            for (PrecioTazaDTO tarifa : tarifas) preciosPaquete.put(tarifa.getUnidadesPaquete(), tarifa.getPrecio());
            if (!preciosPaquete.containsKey(12) || !preciosPaquete.containsKey(6) || !preciosPaquete.containsKey(1)) {
                throw new SQLException("Faltan tarifas de taza para docena, media docena o unidad en la base de datos.");
            }
            OpcionPrecioDTO empaque = catalogoDAO.obtenerEmpaqueTaza(pedido.getEmpaqueTaza());
            if (empaque == null) throw new IllegalArgumentException("error.caja");
            codigoEmpaque = empaque.getCodigo();

            int docenas = cantidad / 12;
            int resto = cantidad % 12;
            int mediasDocenas = resto / 6;
            int unidades = resto % 6;
            BigDecimal costoTazas = preciosPaquete.get(12).multiply(BigDecimal.valueOf(docenas))
                    .add(preciosPaquete.get(6).multiply(BigDecimal.valueOf(mediasDocenas)))
                    .add(preciosPaquete.get(1).multiply(BigDecimal.valueOf(unidades)));
            BigDecimal adicionalEmpaque = empaque.getAdicional().multiply(BigDecimal.valueOf(cantidad));
            BigDecimal subtotal = costoTazas.add(adicionalEmpaque);
            cotizacion.setProductoVista(new TextoRecibo("recibo.tazaProducto", onzas));
            cotizacion.setDetalleVista(new TextoRecibo("recibo.tazaDetalle", onzas, empaque.getNombre()));
            StringJoiner detalleTarifa = new StringJoiner(" + ");
            agregarPaquete(cotizacion, detalleTarifa, 12, "docena(s)", docenas, preciosPaquete);
            agregarPaquete(cotizacion, detalleTarifa, 6, "media(s) docena(s)", mediasDocenas, preciosPaquete);
            agregarPaquete(cotizacion, detalleTarifa, 1, "unidad(es)", unidades, preciosPaquete);
            if (adicionalEmpaque.signum() != 0) {
                cotizacion.agregarPrecioVista(new TextoRecibo("recibo.precioCajas", moneda(adicionalEmpaque)));
            }

            cotizacion.setProducto("Taza de " + onzas + " oz");
            cotizacion.setDetalle("Taza " + onzas + " oz · Caja: " + empaque.getNombre());
            cotizacion.setDetallePrecio(detalleTarifa + (adicionalEmpaque.signum() == 0 ? "" : " + cajas S/ " + moneda(adicionalEmpaque)));
            cotizacion.setPrecioUnitario(costoTazas.divide(BigDecimal.valueOf(cantidad), 2, RoundingMode.HALF_UP));
            cotizacion.setAdicional(adicionalEmpaque);
            cotizacion.setSubtotal(moneda(subtotal));
            cotizacion.setPorcentajeDescuento(BigDecimal.ZERO);
            cotizacion.setDescuento(BigDecimal.ZERO.setScale(2));
            cotizacion.setEmpaque(empaque.getNombre());
        } else if ("OTRO".equals(pedido.getTipoProducto())) {
            productoAdicionalId=enteroPositivo(pedido.getProductoAdicionalId());
            ProductoAdicionalDTO producto=catalogoDAO.obtenerProductoAdicional(productoAdicionalId);
            if(producto==null)throw new IllegalArgumentException("error.producto");
            BigDecimal subtotal=producto.getPrecio().multiply(BigDecimal.valueOf(cantidad));
            cotizacion.setProducto(producto.getNombre());cotizacion.setDetalle(producto.getNombre()+(producto.getDescripcion().isBlank()?"":" · "+producto.getDescripcion()));
            cotizacion.setDetallePrecio(cantidad+" × S/ "+monedaTexto(producto.getPrecio()));cotizacion.setPrecioUnitario(producto.getPrecio());cotizacion.setAdicional(BigDecimal.ZERO.setScale(2));
            cotizacion.setSubtotal(moneda(subtotal));cotizacion.setPorcentajeDescuento(BigDecimal.ZERO);cotizacion.setDescuento(BigDecimal.ZERO.setScale(2));cotizacion.setEmpaque("No aplica");
        } else {
            throw new IllegalArgumentException("error.tipo");
        }

        BigDecimal totalConImpuestoIncluido = cotizacion.getSubtotal().subtract(cotizacion.getDescuento());
        BigDecimal baseImponible = totalConImpuestoIncluido.multiply(CIEN)
                .divide(CIEN.add(cotizacion.getTasaImpuesto()), 2, RoundingMode.HALF_UP);
        BigDecimal impuesto = totalConImpuestoIncluido.subtract(baseImponible);
        cotizacion.setBaseImponible(moneda(baseImponible));
        cotizacion.setImpuesto(moneda(impuesto));
        cotizacion.setTotal(moneda(totalConImpuestoIncluido));
        cotizacion.setId(pedidoDAO.guardar(pedido, cotizacion, clienteId, poloId, onzas, codigoDiseno, codigoEmpaque,productoAdicionalId));
        return cotizacion;
    }

    private int enteroPositivo(String valor) {
        try {
            int numero = Integer.parseInt(valor);
            if (numero > 0) return numero;
        } catch (NumberFormatException ignored) {
            // El mensaje se presenta en el idioma activo.
        }
        throw new IllegalArgumentException("error.numero");
    }

    private BigDecimal porcentaje(BigDecimal monto, BigDecimal porcentaje) {
        return monto.multiply(porcentaje).divide(CIEN, 2, RoundingMode.HALF_UP);
    }

    private BigDecimal moneda(BigDecimal valor) {
        return valor.setScale(2, RoundingMode.HALF_UP);
    }

    private String monedaTexto(BigDecimal valor) {
        return moneda(valor).toPlainString();
    }

    private void agregarPaquete(CotizacionDTO cotizacion, StringJoiner detalleGuardado, int tamano,
                                String unidadGuardada, int cantidad, Map<Integer, BigDecimal> precios) {
        if (cantidad > 0) {
            String precio = monedaTexto(precios.get(tamano));
            detalleGuardado.add(cantidad + " " + unidadGuardada + " × S/ " + precio);
            cotizacion.agregarPrecioVista(new TextoRecibo("recibo.tarifa" + tamano, cantidad, precio));
        }
    }
}
