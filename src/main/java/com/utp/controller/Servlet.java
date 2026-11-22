package com.utp.controller;

import com.utp.dto.ClienteSesionDTO;
import com.utp.dto.CotizacionDTO;
import com.utp.dto.FormularioPedidoDTO;
import com.utp.dto.PedidoDTO;
import com.utp.facade.PedidoFacade;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "pedidoServlet", urlPatterns = {"/pedido"})
public class Servlet extends HttpServlet {
    private final PedidoFacade pedidoFacade = new PedidoFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        mostrarFormulario(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        PedidoDTO pedido = new PedidoDTO();
        pedido.setCliente(request.getParameter("cliente"));
        pedido.setCelular(request.getParameter("celular"));
        pedido.setTipoProducto(request.getParameter("tipoProducto"));
        pedido.setVariantePolo(request.getParameter("variantePolo"));
        pedido.setDisenoPolo(request.getParameter("disenoPolo"));
        pedido.setOnzasTaza(request.getParameter("onzasTaza"));
        pedido.setEmpaqueTaza(request.getParameter("empaqueTaza"));
        pedido.setCantidad(request.getParameter("cantidad"));
        pedido.setProductoAdicionalId(request.getParameter("productoAdicionalId"));
        ClienteSesionDTO clienteSesion = obtenerClienteSesion(request);
        if (clienteSesion != null) {
            pedido.setCliente(clienteSesion.getNombreCompleto());
            pedido.setCelular(clienteSesion.getCelular());
        }
        conservarFormulario(request, pedido);

        CotizacionDTO cotizacion;
        try {
            Long clienteId = clienteSesion == null ? null : clienteSesion.getId();
            cotizacion = pedidoFacade.calcularYGuardar(pedido, clienteId);
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            mostrarFormulario(request, response);
            return;
        } catch (Exception ex) {
            getServletContext().log("No se pudo procesar la cotización", ex);
            request.setAttribute("error", "error.pedido");
            mostrarFormulario(request, response);
            return;
        }

        // El pedido ya está guardado. Un fallo al renderizar el recibo no es un error de persistencia.
        request.setAttribute("cotizacion", cotizacion);
        request.getRequestDispatcher("/resultado.jsp").forward(request, response);
    }

    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClienteSesionDTO cliente = obtenerClienteSesion(request);
        if (cliente != null) {
            request.setAttribute("formCliente", cliente.getNombreCompleto());
            request.setAttribute("formCelular", cliente.getCelular());
        }
        try {
            FormularioPedidoDTO formulario = pedidoFacade.prepararFormulario();
            request.setAttribute("formulario", formulario);
        } catch (Exception ex) {
            getServletContext().log("No se pudo cargar el catálogo", ex);
            request.setAttribute("error", "error.catalogoConexion");
        }
        request.getRequestDispatcher("/pedido.jsp").forward(request, response);
    }

    private void conservarFormulario(HttpServletRequest request, PedidoDTO pedido) {
        request.setAttribute("formCliente", pedido.getCliente());
        request.setAttribute("formCelular", pedido.getCelular());
        request.setAttribute("formTipoProducto", pedido.getTipoProducto());
        request.setAttribute("formVariantePolo", pedido.getVariantePolo());
        request.setAttribute("formDisenoPolo", pedido.getDisenoPolo());
        request.setAttribute("formOnzasTaza", pedido.getOnzasTaza());
        request.setAttribute("formEmpaqueTaza", pedido.getEmpaqueTaza());
        request.setAttribute("formCantidad", pedido.getCantidad());
        request.setAttribute("formProductoAdicionalId", pedido.getProductoAdicionalId());
    }

    private ClienteSesionDTO obtenerClienteSesion(HttpServletRequest request) {
        if (request.getSession(false) == null) return null;
        Object cliente = request.getSession(false).getAttribute("clienteSesion");
        return cliente instanceof ClienteSesionDTO ? (ClienteSesionDTO) cliente : null;
    }
}
