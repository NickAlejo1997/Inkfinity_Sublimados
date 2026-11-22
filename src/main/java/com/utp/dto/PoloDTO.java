package com.utp.dto;

import com.utp.i18n.TextoRecibo;
import java.math.BigDecimal;

public class PoloDTO {
    private int id;
    private String tejido;
    private String talla;
    private BigDecimal precio;

    public PoloDTO(int id, String tejido, String talla, BigDecimal precio) {
        this.id = id;
        this.tejido = tejido;
        this.talla = talla;
        this.precio = precio;
    }

    public int getId() {
        return id;
    }

    public String getTejido() {
        return tejido;
    }

    public String getTalla() {
        return talla;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public TextoRecibo getEtiqueta() {
        return new TextoRecibo("catalogo.variante", tejido, talla, precio);
    }

    public String getDescripcion() {
        return "Polo " + tejido + " · Talla " + talla;
    }
}
