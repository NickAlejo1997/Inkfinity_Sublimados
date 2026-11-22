package com.utp.controller;

import com.utp.dto.ClienteSesionDTO;
import com.utp.facade.PedidoFacade;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "misPedidosServlet", urlPatterns = {"/mis-pedidos"})
public class MisPedidosServlet extends HttpServlet {
    private final PedidoFacade pedidoFacade = new PedidoFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Object actual = request.getSession(false) == null ? null : request.getSession(false).getAttribute("clienteSesion");
        if (!(actual instanceof ClienteSesionDTO cliente)) {
            response.sendRedirect(request.getContextPath() + "/acceso");
            return;
        }
        try {
            request.setAttribute("pedidos", pedidoFacade.obtenerHistorial(cliente.getId()));
            request.getRequestDispatcher("/mis-pedidos.jsp").forward(request, response);
        } catch (Exception ex) {
            getServletContext().log("No se pudo cargar el historial de pedidos", ex);
            request.setAttribute("error", "error.historial");
            request.getRequestDispatcher("/mis-pedidos.jsp").forward(request, response);
        }
    }
}
