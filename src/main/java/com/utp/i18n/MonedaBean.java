package com.utp.i18n;

import jakarta.faces.bean.ManagedBean;
import jakarta.faces.bean.RequestScoped;

import java.util.Map;

/** Moneda de presentación asociada al idioma; la moneda almacenada sigue siendo PEN. */
@ManagedBean(name = "monedaBean")
@RequestScoped
public class MonedaBean {
    private static final Map<String, String> MONEDAS = Map.of(
            "es", "PEN",
            "en", "USD",
            "fr", "EUR",
            "ja", "JPY"
    );

    private static final Map<String, String> LOCALES = Map.of(
            "es", "es-PE",
            "en", "en-US",
            "fr", "fr-FR",
            "ja", "ja-JP"
    );

    public String getCodigo() {
        return MONEDAS.get(MensajesBean.idiomaActual());
    }

    public String getLocale() {
        return LOCALES.get(MensajesBean.idiomaActual());
    }
}
