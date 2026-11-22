package com.utp.dto;

import com.utp.i18n.TextoRecibo;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CotizacionDTO {
    private long id;
    private String cliente;
    private String celular;
    private String producto;
    private String detalle;
    private String detallePrecio;
    private int cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal adicional;
    private BigDecimal subtotal;
    private BigDecimal porcentajeDescuento;
    private BigDecimal descuento;
    private BigDecimal baseImponible;
    private BigDecimal tasaImpuesto;
    private BigDecimal impuesto;
    private BigDecimal total;
    private String empaque;

    private TextoRecibo productoVista;
    private TextoRecibo detalleVista;
    private final List<TextoRecibo> precioVista = new ArrayList<>();

    public TextoRecibo getProductoVista() { return productoVista; }
    public void setProductoVista(TextoRecibo productoVista) { this.productoVista = productoVista; }
    public TextoRecibo getDetalleVista() { return detalleVista; }
    public void setDetalleVista(TextoRecibo detalleVista) { this.detalleVista = detalleVista; }
    public List<TextoRecibo> getPrecioVista() { return List.copyOf(precioVista); }
    public void agregarPrecioVista(TextoRecibo parte) { precioVista.add(parte); }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getCliente() {
        return cliente;
    }

    public void setCliente(String cliente) {
        this.cliente = cliente;
    }

    public String getCelular() {
        return celular;
    }

    public void setCelular(String celular) {
        this.celular = celular;
    }

    public String getProducto() {
        return producto;
    }

    public void setProducto(String producto) {
        this.producto = producto;
    }

    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }

    public String getDetallePrecio() {
        return detallePrecio;
    }

    public void setDetallePrecio(String detallePrecio) {
        this.detallePrecio = detallePrecio;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(BigDecimal precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public BigDecimal getAdicional() {
        return adicional;
    }

    public void setAdicional(BigDecimal adicional) {
        this.adicional = adicional;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getPorcentajeDescuento() {
        return porcentajeDescuento;
    }

    public void setPorcentajeDescuento(BigDecimal porcentajeDescuento) {
        this.porcentajeDescuento = porcentajeDescuento;
    }

    public BigDecimal getDescuento() {
        return descuento;
    }

    public void setDescuento(BigDecimal descuento) {
        this.descuento = descuento;
    }

    public BigDecimal getBaseImponible() {
        return baseImponible;
    }

    public void setBaseImponible(BigDecimal baseImponible) {
        this.baseImponible = baseImponible;
    }

    public BigDecimal getTasaImpuesto() {
        return tasaImpuesto;
    }

    public void setTasaImpuesto(BigDecimal tasaImpuesto) {
        this.tasaImpuesto = tasaImpuesto;
    }

    public BigDecimal getImpuesto() {
        return impuesto;
    }

    public void setImpuesto(BigDecimal impuesto) {
        this.impuesto = impuesto;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public String getEmpaque() {
        return empaque;
    }

    public void setEmpaque(String empaque) {
        this.empaque = empaque;
    }
}
