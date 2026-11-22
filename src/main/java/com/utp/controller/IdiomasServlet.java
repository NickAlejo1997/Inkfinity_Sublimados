package com.utp.controller;

import com.utp.i18n.Mensajes;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Properties;
import java.util.ResourceBundle;

@WebServlet("/idiomas")
public class IdiomasServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idioma = request.getParameter("idioma");
        if (idioma == null || !Mensajes.IDIOMAS.contains(idioma)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        ResourceBundle textos = new Mensajes(idioma).getTextos();
        Properties propiedades = new Properties();
        for (String clave : textos.keySet()) {
            propiedades.setProperty(clave, textos.getString(clave));
        }
        response.setContentType("application/xml;charset=UTF-8");
        propiedades.storeToXML(response.getOutputStream(), null, "UTF-8");
    }
}
