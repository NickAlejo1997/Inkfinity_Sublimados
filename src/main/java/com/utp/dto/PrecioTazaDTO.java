package com.utp.dto;

import java.math.BigDecimal;

public class PrecioTazaDTO {
    private int onzas;
    private int unidadesPaquete;
    private BigDecimal precio;

    public PrecioTazaDTO(int onzas, int unidadesPaquete, BigDecimal precio) {
        this.onzas = onzas;
        this.unidadesPaquete = unidadesPaquete;
        this.precio = precio;
    }

    public int getOnzas() {
        return onzas;
    }

    public int getUnidadesPaquete() {
        return unidadesPaquete;
    }

    public BigDecimal getPrecio() {
        return precio;
    }
}
