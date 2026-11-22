package com.utp.i18n;

import junit.framework.TestCase;

import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class MensajesTest extends TestCase {
    public void testCadaIdiomaTieneTodasLasTraducciones() throws Exception {
        Properties base = leerArchivo("mensajes.properties");
        for (String idioma : Mensajes.IDIOMAS) {
            String nombre = idioma.equals("es") ? "mensajes.properties" : "mensajes_" + idioma + ".properties";
            Properties traduccion = leerArchivo(nombre);
            assertEquals(idioma, base.stringPropertyNames(), traduccion.stringPropertyNames());
            for (String clave : base.stringPropertyNames()) {
                String texto = traduccion.getProperty(clave);
                assertFalse(idioma + ": " + clave, texto.isBlank());
                for (String argumento : new String[]{"{0}", "{1}", "{2}"}) {
                    assertEquals(idioma + ": " + clave, base.getProperty(clave).contains(argumento),
                            texto.contains(argumento));
                }
            }
        }
    }

    public void testValoresDelCatalogoSeInsertanLiteralmente() {
        String empaque = "Caja «{0}» & $1";
        for (String idioma : Mensajes.IDIOMAS) {
            TextoRecibo detalle = new TextoRecibo("recibo.tazaDetalle", 11, empaque);
            String texto = detalle.mostrar(new Mensajes(idioma));
            assertTrue(texto.contains("11"));
            assertTrue(texto.contains(empaque));
        }
    }

    private Properties leerArchivo(String nombre) throws Exception {
        Properties propiedades = new Properties();
        try (var lector = new InputStreamReader(Mensajes.class.getResourceAsStream(nombre), StandardCharsets.UTF_8)) {
            propiedades.load(lector);
        }
        return propiedades;
    }
}
