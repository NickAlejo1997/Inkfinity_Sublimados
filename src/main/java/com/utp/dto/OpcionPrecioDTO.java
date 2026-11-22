package com.utp.dto;

import java.math.BigDecimal;

public class OpcionPrecioDTO {
    private String codigo;
    private String nombre;
    private BigDecimal adicional;

    public OpcionPrecioDTO(String codigo, String nombre, BigDecimal adicional) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.adicional = adicional;
    }

    public String getCodigo() {
        return codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public BigDecimal getAdicional() {
        return adicional;
    }
}
