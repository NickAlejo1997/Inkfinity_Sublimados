package com.utp.controller;

import com.utp.dto.ClienteSesionDTO;
import com.utp.dto.RegistroClienteDTO;
import com.utp.facade.AutenticacionFacade;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "registroServlet", urlPatterns = {"/registro"})
public class RegistroServlet extends HttpServlet {
    private final AutenticacionFacade autenticacion = new AutenticacionFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/registro.xhtml").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        RegistroClienteDTO registro = new RegistroClienteDTO();
        registro.setDni(request.getParameter("dni"));
        registro.setNombres(request.getParameter("nombres"));
        registro.setApellidos(request.getParameter("apellidos"));
        registro.setCelular(request.getParameter("celular"));
        registro.setContrasena(request.getParameter("contrasena"));
        registro.setConfirmarContrasena(request.getParameter("confirmarContrasena"));
        try {
            ClienteSesionDTO cliente = autenticacion.registrar(registro);
            if (request.getSession(false) != null) request.getSession(false).invalidate();
            request.getSession(true).setAttribute("clienteSesion", cliente);
            response.sendRedirect(request.getContextPath() + "/pedido");
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("formDni", registro.getDni());
            request.setAttribute("formNombres", registro.getNombres());
            request.setAttribute("formApellidos", registro.getApellidos());
            request.setAttribute("formCelular", registro.getCelular());
            request.getRequestDispatcher("/registro.xhtml").forward(request, response);
        } catch (Exception ex) {
            getServletContext().log("No se pudo registrar la cuenta", ex);
            request.setAttribute("error", "error.registro");
            request.getRequestDispatcher("/registro.xhtml").forward(request, response);
        }
    }
}
