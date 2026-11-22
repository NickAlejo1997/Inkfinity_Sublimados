package com.utp.i18n;

import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class Mensajes {
    public static final List<String> IDIOMAS = List.of("es", "en", "ja", "fr");
    private static final String BASE = "com.utp.i18n.mensajes";
    private static final Pattern ARGUMENTO = Pattern.compile("\\{(\\d+)\\}");
    private final ResourceBundle textos;
    private final String idioma;

    public Mensajes(String idioma) {
        this.idioma = idioma != null && IDIOMAS.contains(idioma) ? idioma : "es";
        Locale locale = this.idioma.equals("es") ? Locale.ROOT : Locale.forLanguageTag(this.idioma);
        textos = ResourceBundle.getBundle(BASE, locale,
                ResourceBundle.Control.getNoFallbackControl(ResourceBundle.Control.FORMAT_PROPERTIES));
    }

    public ResourceBundle getTextos() { return textos; }
    public String getIdioma() { return idioma; }

    public String formatear(String clave, Object... argumentos) {
        return ARGUMENTO.matcher(textos.getString(clave)).replaceAll(coincidencia ->
                Matcher.quoteReplacement(String.valueOf(argumentos[Integer.parseInt(coincidencia.group(1))])));
    }
}
