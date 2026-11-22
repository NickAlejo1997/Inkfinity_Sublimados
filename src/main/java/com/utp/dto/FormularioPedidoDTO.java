package com.utp.dto;

import java.util.List;

public class FormularioPedidoDTO {
    private List<PoloDTO> polos;
    private List<Integer> onzasTaza;
    private List<PrecioTazaDTO> preciosTaza;
    private List<OpcionPrecioDTO> disenosPolo;
    private List<OpcionPrecioDTO> empaquesTaza;
    private List<ProductoAdicionalDTO> productosAdicionales;

    public FormularioPedidoDTO(List<PoloDTO> polos, List<Integer> onzasTaza, List<PrecioTazaDTO> preciosTaza,
                               List<OpcionPrecioDTO> disenosPolo, List<OpcionPrecioDTO> empaquesTaza, List<ProductoAdicionalDTO> productosAdicionales) {
        this.polos = polos;
        this.onzasTaza = onzasTaza;
        this.preciosTaza = preciosTaza;
        this.disenosPolo = disenosPolo;
        this.empaquesTaza = empaquesTaza;
        this.productosAdicionales = productosAdicionales;
    }

    public List<PoloDTO> getPolos() {
        return polos;
    }

    public List<Integer> getOnzasTaza() {
        return onzasTaza;
    }

    public List<PrecioTazaDTO> getPreciosTaza() {
        return preciosTaza;
    }

    public List<OpcionPrecioDTO> getDisenosPolo() {
        return disenosPolo;
    }

    public List<OpcionPrecioDTO> getEmpaquesTaza() {
        return empaquesTaza;
    }

    public List<ProductoAdicionalDTO> getProductosAdicionales() {
        return productosAdicionales;
    }
}
