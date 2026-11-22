<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/includes/mensajes.jspf" %>
<!DOCTYPE html>
<html lang="${i18n.idioma}">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title data-i18n="historial.titulo">${msg['historial.titulo']}</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script defer src="${pageContext.request.contextPath}/assets/idioma.js"></script>
</head>
<body class="min-h-screen bg-slate-50 text-slate-900">
<header class="border-b border-slate-200 bg-white">
    <nav class="mx-auto flex w-full max-w-5xl flex-col gap-3 px-4 py-3.5 md:flex-row md:flex-wrap md:items-center md:justify-between md:gap-x-6 md:gap-y-4 md:px-6 md:py-4" data-i18n-aria-label="nav.principal" aria-label="${msg['nav.principal']}">
        <a class="inline-flex w-fit max-w-full min-w-0 items-center gap-3 md:shrink-0" href="${pageContext.request.contextPath}/">
            <img data-i18n-alt="marca.logo" alt="${msg['marca.logo']}"
                 class="h-11 w-11 shrink-0 rounded-full border border-slate-200 object-cover md:h-12 md:w-12 lg:h-14 lg:w-14"
                 src="${pageContext.request.contextPath}/assets/logo-inkfinity.png">
            <span class="min-w-0 text-sm font-black leading-snug tracking-tight md:text-base lg:text-lg"><span class="block md:inline">INKFINITY</span> <span class="block md:inline">SUBLIMADOS</span></span>
        </a>
        <%@ include file="/WEB-INF/includes/idioma.jspf" %>
        <div class="flex min-w-0 flex-wrap items-center gap-2 border-t border-slate-100 pt-3 md:flex-1 md:justify-end md:gap-3 md:border-0 md:pt-0">
            <a class="inline-flex min-h-11 flex-auto items-center justify-center whitespace-nowrap rounded-full bg-slate-950 px-3.5 py-2.5 text-sm font-bold leading-tight text-white transition-colors hover:bg-cyan-600 md:flex-none" href="${pageContext.request.contextPath}/pedido" data-i18n="nav.cotizar">${msg['nav.cotizar']}</a>
            <form action="${pageContext.request.contextPath}/cerrar-sesion" method="post" class="m-0 flex min-w-0 flex-auto md:flex-none">
                <button type="submit" class="inline-flex min-h-11 flex-1 cursor-pointer items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-600 transition-colors hover:border-rose-300 hover:bg-rose-50 hover:text-rose-700" data-i18n="nav.salir">${msg['nav.salir']}</button>
            </form>
        </div>
    </nav>
</header>
<main class="mx-auto max-w-5xl px-4 py-8 sm:px-6 sm:py-12">
    <p class="text-sm font-black uppercase tracking-[.2em] text-cyan-700" data-i18n="historial.area">${msg['historial.area']}</p>
    <h1 class="mt-2 text-3xl font-black sm:text-4xl" data-i18n="historial.encabezado">${msg['historial.encabezado']}</h1>
    <p class="mt-2 text-slate-600"><span data-i18n="saludo">${msg['saludo']}</span>
        <c:out value="${sessionScope.clienteSesion.nombreCompleto}"/>
        <span data-i18n="historial.saludoFinal">${msg['historial.saludoFinal']}</span>
    </p>
    <c:if test="${not empty error}">
        <div class="mt-5 rounded-xl border border-rose-300 bg-rose-50 p-4 text-sm text-rose-800" role="alert">
            <span data-i18n="<c:out value='${error}'/>"><c:out value="${msg[error]}"/></span>
        </div>
    </c:if>
    <div class="mt-7 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
        <c:choose>
            <c:when test="${empty pedidos}">
                <div class="p-7 text-center">
                    <p class="font-bold" data-i18n="historial.vacio">${msg['historial.vacio']}</p>
                    <a class="mt-4 inline-flex rounded-xl bg-slate-950 px-5 py-3 font-bold text-white"
                       href="${pageContext.request.contextPath}/pedido" data-i18n="accion.crearCotizacion">
                        ${msg['accion.crearCotizacion']}
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full min-w-[600px] text-left text-sm">
                        <thead class="bg-slate-100 text-xs uppercase tracking-wider text-slate-600">
                        <tr>
                            <th class="px-5 py-4" data-i18n="campo.folio">${msg['campo.folio']}</th>
                            <th class="px-5 py-4" data-i18n="campo.fecha">${msg['campo.fecha']}</th>
                            <th class="px-5 py-4" data-i18n="campo.producto">${msg['campo.producto']}</th>
                            <th class="px-5 py-4" data-i18n="campo.cantidad">${msg['campo.cantidad']}</th>
                            <th class="px-5 py-4 text-right" data-i18n="campo.totalIgv">${msg['campo.totalIgv']}</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                        <c:forEach items="${pedidos}" var="pedido">
                            <tr>
                                <td class="px-5 py-4 font-bold">#
                                    <c:out value="${pedido.id}"/>
                                </td>
                                <td class="px-5 py-4 text-slate-600">
                                    <c:out value="${pedido.fechaTexto}"/>
                                </td>
                                <td class="px-5 py-4">
                                    <c:out value="${pedido.producto}"/>
                                </td>
                                <td class="px-5 py-4">
                                    <c:out value="${pedido.cantidad}"/>
                                </td>
                                <td class="px-5 py-4 text-right font-bold">S/
                                    <c:out value="${pedido.total}"/>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>
</body>
</html>
