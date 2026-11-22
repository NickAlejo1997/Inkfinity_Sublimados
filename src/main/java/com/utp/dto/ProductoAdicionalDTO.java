package com.utp.dto;

import java.math.BigDecimal;

public class ProductoAdicionalDTO {
    private final int id;
    private final String nombre;
    private final String descripcion;
    private final BigDecimal precio;

    public ProductoAdicionalDTO(int id, String nombre, String descripcion, BigDecimal precio) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
    }

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public BigDecimal getPrecio() {
        return precio;
    }
}
