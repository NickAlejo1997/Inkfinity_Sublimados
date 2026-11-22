package com.utp.i18n;

import java.util.List;

/** Plantilla de presentación y valores originales del catálogo o del cálculo. */
public final class TextoRecibo {
    private final String clave;
    private final List<Object> argumentos;

    public TextoRecibo(String clave, Object... argumentos) {
        this.clave = clave;
        this.argumentos = List.of(argumentos);
    }

    public String getClave() { return clave; }
    public List<Object> getArgumentos() { return argumentos; }

    public String mostrar(Mensajes mensajes) {
        return mensajes.formatear(clave, argumentos.toArray());
    }
}
