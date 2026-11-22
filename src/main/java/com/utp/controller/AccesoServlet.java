package com.utp.controller;

import com.utp.dto.ClienteSesionDTO;
import com.utp.facade.AutenticacionFacade;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "accesoServlet", urlPatterns = {"/acceso"})
public class AccesoServlet extends HttpServlet {
    private final AutenticacionFacade autenticacion = new AutenticacionFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/acceso.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            ClienteSesionDTO cliente = autenticacion.iniciarSesion(request.getParameter("dni"), request.getParameter("contrasena"));
            if (request.getSession(false) != null) request.getSession(false).invalidate();
            request.getSession(true).setAttribute("clienteSesion", cliente);
            response.sendRedirect(request.getContextPath() + "/pedido");
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("formDni", request.getParameter("dni"));
            request.getRequestDispatcher("/acceso.jsp").forward(request, response);
        } catch (Exception ex) {
            getServletContext().log("No se pudo iniciar sesión", ex);
            request.setAttribute("error", "error.baseAcceso");
            request.getRequestDispatcher("/acceso.jsp").forward(request, response);
        }
    }
}
