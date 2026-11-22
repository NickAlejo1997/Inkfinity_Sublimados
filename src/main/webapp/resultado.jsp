<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/includes/mensajes.jspf" %>
<!DOCTYPE html>
<html lang="${i18n.idioma}">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title data-i18n="recibo.titulo">${msg['recibo.titulo']}</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script defer src="${pageContext.request.contextPath}/assets/idioma.js"></script>
</head>
<body class="min-h-screen bg-slate-50 text-slate-900 antialiased">
<header class="border-b border-slate-200 bg-white/90">
    <nav class="mx-auto flex w-full max-w-5xl flex-col gap-3 px-4 py-3.5 md:flex-row md:flex-wrap md:items-center md:justify-between md:gap-x-6 md:gap-y-4 md:px-6 md:py-4" data-i18n-aria-label="nav.principal" aria-label="${msg['nav.principal']}">
        <a class="inline-flex w-fit max-w-full min-w-0 items-center gap-3 md:shrink-0" href="${pageContext.request.contextPath}/">
            <img alt="Inkfinity Sublimados" class="h-11 w-11 shrink-0 rounded-full border border-slate-200 object-cover md:h-12 md:w-12 lg:h-14 lg:w-14"
                 src="${pageContext.request.contextPath}/assets/logo-inkfinity.png">
            <span class="min-w-0 text-sm font-black leading-snug tracking-tight md:text-base lg:text-lg"><span class="block md:inline">INKFINITY</span> <span class="block md:inline">SUBLIMADOS</span></span>
        </a>
        <%@ include file="/WEB-INF/includes/idioma.jspf" %>
        <div class="flex min-w-0 flex-wrap items-center gap-2 border-t border-slate-100 pt-3 md:flex-1 md:justify-end md:gap-3 md:border-0 md:pt-0">
            <c:choose>
                <c:when test="${not empty sessionScope.clienteSesion}">
                    <a class="inline-flex min-h-11 flex-auto items-center justify-center whitespace-nowrap rounded-full border border-cyan-100 bg-cyan-50 px-3.5 py-2.5 text-sm font-bold leading-tight text-cyan-700 transition-colors hover:bg-cyan-100 md:flex-none" href="${pageContext.request.contextPath}/mis-pedidos" data-i18n="nav.pedidos">${msg['nav.pedidos']}</a>
                    <form action="${pageContext.request.contextPath}/cerrar-sesion" method="post" class="m-0 flex min-w-0 flex-auto md:flex-none">
                        <button type="submit" class="inline-flex min-h-11 flex-1 cursor-pointer items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-600 transition-colors hover:border-rose-300 hover:bg-rose-50 hover:text-rose-700" data-i18n="nav.salir">${msg['nav.salir']}</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <a class="inline-flex min-h-11 flex-auto items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-800 transition-colors hover:bg-slate-100 md:flex-none" href="${pageContext.request.contextPath}/acceso" data-i18n="accion.iniciar">${msg['accion.iniciar']}</a>
                </c:otherwise>
            </c:choose>
            <a class="inline-flex min-h-11 flex-auto items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-600 transition-colors hover:bg-slate-100 md:flex-none"
               href="${pageContext.request.contextPath}/pedido" data-i18n="nav.nuevo">${msg['nav.nuevo']}</a>
        </div>
    </nav>
</header>
<main class="mx-auto max-w-2xl px-4 py-8 sm:px-6 sm:py-14">
    <div class="mb-7 text-center">
        <span class="inline-flex h-12 w-12 items-center justify-center rounded-full bg-emerald-100 text-2xl text-emerald-700">✓</span>
        <p class="mt-4 text-sm font-black uppercase tracking-[.25em] text-cyan-700" data-i18n="recibo.guardado">${msg['recibo.guardado']}</p>
        <h1 class="mt-2 text-3xl font-black tracking-tight sm:text-4xl" data-i18n="recibo.encabezado">${msg['recibo.encabezado']}</h1>
        <p class="mt-3 text-slate-600"><span data-i18n="campo.folio">${msg['campo.folio']}</span>
            <span class="font-bold">#<c:out value="${cotizacion.id}"/>
            </span> <span data-i18n="recibo.cliente">${msg['recibo.cliente']}</span>
            <span class="font-bold text-slate-950"><c:out value="${cotizacion.cliente}"/></span>
        </p>
        <p class="mt-2 text-sm text-slate-600"><span data-i18n="recibo.celular">${msg['recibo.celular']}</span>
            <span class="font-bold"><c:out value="${cotizacion.celular}"/></span>
        </p>
    </div>

    <section class="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-xl shadow-slate-300/40">
        <div class="border-b border-slate-200 bg-gradient-to-r from-fuchsia-100 to-cyan-50 p-5 sm:p-7">
            <div class="flex flex-col justify-between gap-4 sm:flex-row sm:items-center">
                <div>
                    <p class="text-sm text-slate-500" data-i18n="campo.producto">${msg['campo.producto']}</p>
                    <h2 class="mt-1 text-2xl font-black">
                        <c:choose>
                            <c:when test="${not empty cotizacion.productoVista}"><i:texto texto="${cotizacion.productoVista}" mensajes="${i18n}"/></c:when>
                            <c:otherwise><c:out value="${cotizacion.producto}"/></c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="mt-1 text-sm text-slate-600">
                        <c:choose>
                            <c:when test="${not empty cotizacion.detalleVista}"><i:texto texto="${cotizacion.detalleVista}" mensajes="${i18n}"/></c:when>
                            <c:otherwise><c:out value="${cotizacion.detalle}"/></c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="w-fit rounded-2xl bg-white px-5 py-3 text-center shadow-sm">
                    <p class="text-3xl font-black">
                        <c:out value="${cotizacion.cantidad}"/>
                    </p>
                    <p class="text-xs uppercase tracking-wider text-slate-500" data-i18n="campo.unidades">${msg['campo.unidades']}</p>
                </div>
            </div>
        </div>

        <div class="space-y-4 p-5 sm:p-7">
            <div class="flex items-start justify-between gap-4 text-sm">
                <span class="text-slate-600" data-i18n="recibo.detallePrecio">${msg['recibo.detallePrecio']}</span>
                <span class="max-w-sm text-right font-semibold">
                    <c:choose>
                        <c:when test="${not empty cotizacion.precioVista}">
                            <c:forEach items="${cotizacion.precioVista}" var="parte" varStatus="paso"><c:if test="${not paso.first}"> + </c:if><i:texto texto="${parte}" mensajes="${i18n}"/></c:forEach>
                        </c:when>
                        <c:otherwise><c:out value="${cotizacion.detallePrecio}"/></c:otherwise>
                    </c:choose></span>
            </div>
            <c:if test="${cotizacion.adicional gt 0}">
                <div class="flex justify-between gap-4 text-sm">
                    <span class="text-slate-600">
                        <c:choose>
                            <c:when test="${cotizacion.empaque != 'No aplica'}"><span data-i18n="recibo.cajas">${msg['recibo.cajas']}</span></c:when>
                            <c:otherwise><span data-i18n="recibo.diseno">${msg['recibo.diseno']}</span></c:otherwise></c:choose></span>
                    <span class="font-bold">S/
                        <c:out value="${cotizacion.adicional}"/>
                    </span>
                </div>
            </c:if>
            <div class="flex justify-between border-t border-slate-200 pt-4 text-sm">
                <span class="text-slate-600" data-i18n="recibo.subtotal">${msg['recibo.subtotal']}</span>
                <span class="font-bold">S/ <c:out value="${cotizacion.subtotal}"/></span>
            </div>
            <c:if test="${cotizacion.porcentajeDescuento gt 0}">
                <div class="flex justify-between gap-4 text-sm text-emerald-700">
                    <span><span data-i18n="recibo.descuento">${msg['recibo.descuento']}</span><c:out value="${cotizacion.porcentajeDescuento}"/>%)</span>
                    <span class="font-bold">− S/ <c:out value="${cotizacion.descuento}"/></span>
                </div>
            </c:if>
            <div class="flex justify-between gap-4 text-sm">
                <span class="text-slate-600" data-i18n="recibo.sinIgv">${msg['recibo.sinIgv']}</span>
                <span class="font-bold">S/ <c:out value="${cotizacion.baseImponible}"/></span>
            </div>
            <div class="flex justify-between gap-4 text-sm">
                <span class="text-slate-600"><span data-i18n="recibo.tasa">${msg['recibo.tasa']}</span><c:out value="${cotizacion.tasaImpuesto}"/>%)</span>
                <span class="font-bold">S/ <c:out value="${cotizacion.impuesto}"/></span>
            </div>
        </div>

        <div class="mx-5 mb-5 rounded-2xl bg-gradient-to-r from-fuchsia-600 to-pink-500 p-5 text-white sm:mx-7 sm:mb-7 sm:p-6">
            <div class="flex items-end justify-between gap-4">
                <div>
                    <p class="text-sm font-semibold text-white/80" data-i18n="recibo.total">${msg['recibo.total']}</p>
                    <p class="mt-1 text-xs text-white/70" data-i18n="recibo.igv">${msg['recibo.igv']}</p>
                </div>
                <p class="text-3xl font-black tracking-tight sm:text-4xl">S/
                    <c:out value="${cotizacion.total}"/>
                </p>
            </div>
        </div>
    </section>
    <div class="mt-5 grid grid-cols-1 gap-3 sm:grid-cols-2">
        <a class="rounded-xl bg-slate-900 px-6 py-4 text-center font-bold text-white hover:bg-slate-700"
           href="${pageContext.request.contextPath}/pedido" data-i18n="recibo.nuevo">
            ${msg['recibo.nuevo']}
        </a>
        <a class="rounded-xl border border-slate-300 bg-white px-6 py-4 text-center font-bold hover:bg-slate-100"
           href="${pageContext.request.contextPath}/" data-i18n="accion.inicio">
            ${msg['accion.inicio']}
        </a>
    </div>
    <p class="mt-6 text-center text-xs leading-5 text-slate-500" data-i18n="recibo.nota">
        ${msg['recibo.nota']}
    </p>
</main>
</body>
</html>
