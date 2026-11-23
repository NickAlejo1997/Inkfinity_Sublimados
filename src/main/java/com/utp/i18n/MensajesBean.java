package com.utp.i18n;

import jakarta.faces.bean.ManagedBean;
import jakarta.faces.bean.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.servlet.http.Cookie;

import java.util.Locale;

/** Proporciona a Facelets el idioma y el bundle seleccionado para esta petición. */
@ManagedBean(name = "mensajesBean")
@RequestScoped
public class MensajesBean {

    public static String idiomaActual() {
        Object cookie = FacesContext.getCurrentInstance()
                .getExternalContext().getRequestCookieMap().get("inkfinityIdioma");
        String idioma = cookie instanceof Cookie c ? c.getValue() : null;
        return idioma != null && Mensajes.IDIOMAS.contains(idioma) ? idioma : "es";
    }

    public String getIdioma() {
        return idiomaActual();
    }

    public Locale getLocale() {
        return Locale.forLanguageTag(getIdioma());
    }

    public Mensajes getMensajes() {
        return new Mensajes(getIdioma());
    }

    public String mostrar(TextoRecibo texto) {
        return texto == null ? "" : texto.mostrar(getMensajes());
    }
}
