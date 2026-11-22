package com.utp.dto;

public class PedidoDTO {
    private String cliente;
    private String celular;
    private String tipoProducto;
    private String variantePolo;
    private String disenoPolo;
    private String onzasTaza;
    private String empaqueTaza;
    private String cantidad;
    private String productoAdicionalId;

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

    public String getTipoProducto() {
        return tipoProducto;
    }

    public void setTipoProducto(String tipoProducto) {
        this.tipoProducto = tipoProducto;
    }

    public String getVariantePolo() {
        return variantePolo;
    }

    public void setVariantePolo(String variantePolo) {
        this.variantePolo = variantePolo;
    }

    public String getDisenoPolo() {
        return disenoPolo;
    }

    public void setDisenoPolo(String disenoPolo) {
        this.disenoPolo = disenoPolo;
    }

    public String getOnzasTaza() {
        return onzasTaza;
    }

    public void setOnzasTaza(String onzasTaza) {
        this.onzasTaza = onzasTaza;
    }

    public String getEmpaqueTaza() {
        return empaqueTaza;
    }

    public void setEmpaqueTaza(String empaqueTaza) {
        this.empaqueTaza = empaqueTaza;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getProductoAdicionalId() {
        return productoAdicionalId;
    }

    public void setProductoAdicionalId(String productoAdicionalId) {
        this.productoAdicionalId = productoAdicionalId;
    }
}
