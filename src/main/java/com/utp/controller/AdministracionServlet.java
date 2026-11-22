package com.utp.controller;

import com.utp.facade.AdministracionFacade;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "administracionServlet", urlPatterns = {"/administracion"})
public class AdministracionServlet extends HttpServlet {
    private final AdministracionFacade facade = new AdministracionFacade();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        cargar(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        try {
            if ("crearSuperAdmin".equals(accion)) {
                if (facade.existeAdministrador())
                    throw new IllegalArgumentException("error.existeAdmin");
                facade.crearAdministrador(req.getParameter("dni"), req.getParameter("nombre"), req.getParameter("contrasena"));
                req.getSession(true).setAttribute("adminAviso", "aviso.adminCreado");
                resp.sendRedirect(req.getContextPath() + "/administracion");
                return;
            }
            if ("iniciarSesion".equals(accion)) {
                if (!facade.existeAdministrador())
                    throw new IllegalArgumentException("error.faltaAdmin");
                String nombre = facade.autenticar(req.getParameter("dni"), req.getParameter("contrasena"));
                if (req.getSession(false) != null) req.getSession(false).invalidate();
                req.getSession(true).setAttribute("administradorSesion", nombre);
                resp.sendRedirect(req.getContextPath() + "/administracion");
                return;
            }
            if ("cerrarSesion".equals(accion)) {
                if (req.getSession(false) != null) req.getSession(false).invalidate();
                resp.sendRedirect(req.getContextPath() + "/administracion");
                return;
            }
            if (req.getSession(false) == null || req.getSession(false).getAttribute("administradorSesion") == null) {
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            Map<String, String> valores = new LinkedHashMap<>();
            req.getParameterMap().forEach((k, v) -> {
                if (v != null && v.length > 0) valores.put(k, v[0]);
            });
            facade.ejecutarAccion(accion, valores);
            req.getSession().setAttribute("adminAviso", "aviso.guardado");
            resp.sendRedirect(req.getContextPath() + "/administracion");
            return;
        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", ex.getMessage());
            cargar(req, resp);
        } catch (Exception ex) {
            getServletContext().log("Error en administración Inkfinity", ex);
            req.setAttribute("error", "error.accionFallida");
            cargar(req, resp);
        }
    }

    private void cargar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            boolean existe = facade.existeAdministrador();
            req.setAttribute("existeAdmin", existe);
            if (req.getSession(false) != null && req.getSession(false).getAttribute("administradorSesion") != null) {
                req.setAttribute("adminNombre", req.getSession(false).getAttribute("administradorSesion"));
                req.setAttribute("pedidos", facade.pedidos());
                req.setAttribute("polos", facade.polos());
                req.setAttribute("tazas", facade.tazas());
                req.setAttribute("disenos", facade.disenos());
                req.setAttribute("empaques", facade.empaques());
                req.setAttribute("descuentos", facade.descuentos());
                req.setAttribute("configuracion", facade.configuracion());
                req.setAttribute("productos", facade.productos());
            }
        } catch (Exception ex) {
            getServletContext().log("No se pudo cargar administración", ex);
            req.setAttribute("error", "error.baseAdmin");
        }
        if (req.getSession(false) != null) {
            Object aviso = req.getSession(false).getAttribute("adminAviso");
            if (aviso != null) {
                req.setAttribute("aviso", aviso);
                req.getSession(false).removeAttribute("adminAviso");
            }
        }
        req.getRequestDispatcher("/administracion.jsp").forward(req, resp);
    }
}
