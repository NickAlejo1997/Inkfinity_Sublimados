package com.utp.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PedidoHistorialDTO {
    private long id;
    private String producto;
    private int cantidad;
    private BigDecimal total;
    private LocalDateTime fecha;

    public PedidoHistorialDTO(long id, String producto, int cantidad, BigDecimal total, LocalDateTime fecha) {
        this.id = id;
        this.producto = producto;
        this.cantidad = cantidad;
        this.total = total;
        this.fecha = fecha;
    }

    public long getId() {
        return id;
    }

    public String getProducto() {
        return producto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public String getFechaTexto() {
        return fecha.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
