<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/includes/mensajes.jspf" %>
<!DOCTYPE html>
<html lang="${i18n.idioma}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-i18n="pedido.titulo">${msg['pedido.titulo']}</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script defer src="${pageContext.request.contextPath}/assets/idioma.js"></script>
</head>
<body class="min-h-screen bg-slate-50 text-slate-900 antialiased">
<header class="border-b border-slate-200 bg-white/90 backdrop-blur-xl">
    <nav class="mx-auto flex w-full max-w-6xl flex-col gap-3 px-4 py-3.5 md:flex-row md:flex-wrap md:items-center md:justify-between md:gap-x-6 md:gap-y-4 md:px-6 md:py-4" data-i18n-aria-label="nav.principal" aria-label="${msg['nav.principal']}">
        <a href="${pageContext.request.contextPath}/" class="inline-flex w-fit max-w-full min-w-0 items-center gap-3 md:shrink-0">
            <img src="${pageContext.request.contextPath}/assets/logo-inkfinity.png" alt="Inkfinity Sublimados" class="h-11 w-11 shrink-0 rounded-full border border-slate-200 object-cover md:h-12 md:w-12 lg:h-14 lg:w-14">
            <span class="min-w-0 text-sm font-black leading-snug tracking-tight md:text-base lg:text-lg"><span class="block md:inline">INKFINITY</span> <span class="block md:inline">SUBLIMADOS</span></span>
        </a>
        <%@ include file="/WEB-INF/includes/idioma.jspf" %>
        <div class="flex min-w-0 flex-wrap items-center gap-2 border-t border-slate-100 pt-3 md:flex-1 md:justify-end md:gap-3 md:border-0 md:pt-0">
            <c:choose>
                <c:when test="${not empty sessionScope.clienteSesion}">
                    <a href="${pageContext.request.contextPath}/mis-pedidos" class="inline-flex min-h-11 flex-auto items-center justify-center whitespace-nowrap rounded-full border border-cyan-100 bg-cyan-50 px-3.5 py-2.5 text-sm font-bold leading-tight text-cyan-700 transition-colors hover:bg-cyan-100 md:flex-none" data-i18n="nav.pedidos">${msg['nav.pedidos']}</a>
                    <form action="${pageContext.request.contextPath}/cerrar-sesion" method="post" class="m-0 flex min-w-0 flex-auto md:flex-none">
                        <button type="submit" class="inline-flex min-h-11 flex-1 cursor-pointer items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-600 transition-colors hover:border-rose-300 hover:bg-rose-50 hover:text-rose-700" data-i18n="nav.salir">${msg['nav.salir']}</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/acceso" class="inline-flex min-h-11 flex-auto items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-800 transition-colors hover:bg-slate-100 md:flex-none" data-i18n="accion.iniciar">${msg['accion.iniciar']}</a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/" class="inline-flex min-h-11 flex-auto items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-600 transition-colors hover:bg-slate-100 md:flex-none" data-i18n="nav.volver">${msg['nav.volver']}</a>
        </div>
    </nav>
</header>
<main class="mx-auto grid max-w-6xl grid-cols-1 gap-8 px-4 py-10 sm:px-6 lg:grid-cols-[.8fr_1.2fr] lg:gap-12 lg:py-16">
    <section class="lg:pt-2">
        <p class="text-sm font-black uppercase tracking-[.25em] text-fuchsia-600" data-i18n="pedido.cotizador">${msg['pedido.cotizador']}</p>
        <h1 class="mt-2 text-4xl font-black leading-tight tracking-tight sm:text-5xl" data-i18n="pedido.encabezado">${msg['pedido.encabezado']}</h1>
        <p class="mt-4 text-lg leading-8 text-slate-600" data-i18n="pedido.intro">${msg['pedido.intro']}</p>
        <div class="mt-2 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <p class="font-bold" data-i18n="pedido.descuentos">${msg['pedido.descuentos']}</p>
            <p class="mt-2 text-sm leading-6 text-slate-600" data-i18n="pedido.descuentosDetalle">${msg['pedido.descuentosDetalle']}
            </p>
        </div>
        <div class="mt-4 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <p class="font-bold" data-i18n="pedido.preciosTazas">${msg['pedido.preciosTazas']}</p>
            <div class="mt-3 grid grid-cols-1 gap-2 text-sm sm:grid-cols-2">
                <c:forEach items="${formulario.preciosTaza}" var="tarifa">
                    <p class="rounded-xl bg-slate-50 px-3 py-2">${tarifa.onzas} <span data-i18n="pedido.onzasSeparador">${msg['pedido.onzasSeparador']}</span> ${tarifa.unidadesPaquete} <span data-i18n="pedido.unidadesSoles">${msg['pedido.unidadesSoles']}</span> <c:out value="${tarifa.precio}"/>
                    </p>
                </c:forEach>
            </div>
            <p class="mt-3 text-xs leading-5 text-slate-500" data-i18n="pedido.cajasDetalle">
                ${msg['pedido.cajasDetalle']}
            </p>
        </div>
    </section>

    <section class="rounded-3xl border border-slate-200 bg-white p-5 shadow-xl shadow-slate-300/40 sm:p-8 lg:rounded-[2rem]">
        <p class="text-sm font-semibold text-cyan-600" data-i18n="pedido.cotizacion">${msg['pedido.cotizacion']}</p>
        <h2 class="mt-1 text-2xl font-black" data-i18n="pedido.detalles">${msg['pedido.detalles']}</h2>

        <c:if test="${not empty error}">
            <div role="alert" class="mt-5 rounded-2xl border border-rose-300 bg-rose-50 p-4 text-sm text-rose-800">
                <span data-i18n="<c:out value='${error}'/>"><c:out value="${msg[error]}"/></span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/pedido" method="post" class="mt-6 space-y-5">
            <div>
                <label for="cliente" class="mb-2 block text-sm font-bold text-slate-700" data-i18n="campo.nombreCliente">${msg['campo.nombreCliente']}</label>
                <input id="cliente" name="cliente" type="text" value="<c:out value='${formCliente}'/>" minlength="3" maxlength="80" ${not empty sessionScope.clienteSesion ? 'readonly' : ''} required autocomplete="name" data-i18n-placeholder="ejemplo.cliente" placeholder="${msg['ejemplo.cliente']}" class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 text-slate-950 outline-none focus:border-fuchsia-500 focus:ring-4 focus:ring-fuchsia-400/10">
            </div>

            <div>
                <label for="celular" class="mb-2 block text-sm font-bold text-slate-700" data-i18n="campo.telefono">${msg['campo.telefono']}</label>
                <input id="celular" name="celular" type="tel" value="<c:out value='${formCelular}'/>" pattern="9[0-9]{8}" minlength="9" maxlength="9" ${not empty sessionScope.clienteSesion ? 'readonly' : ''} required inputmode="numeric" autocomplete="tel-national" data-i18n-placeholder="ejemplo.telefono" placeholder="${msg['ejemplo.telefono']}" aria-describedby="celularAyuda" class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 text-slate-950 outline-none focus:border-fuchsia-500 focus:ring-4 focus:ring-fuchsia-400/10">
                <p id="celularAyuda" class="mt-2 text-xs text-slate-500"><span data-i18n="campo.telefonoAyuda">${msg['campo.telefonoAyuda']}</span>
                    <c:if test="${not empty sessionScope.clienteSesion}"><span data-i18n="pedido.cuenta">${msg['pedido.cuenta']}</span></c:if>
                </p>
            </div>

            <fieldset>
                <legend class="mb-2 text-sm font-bold text-slate-700" data-i18n="pedido.pregunta">${msg['pedido.pregunta']}</legend>
                <div class="grid grid-cols-2 gap-3">
                    <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 p-4 has-[:checked]:border-fuchsia-500 has-[:checked]:bg-fuchsia-50">
                        <input type="radio" name="tipoProducto" value="POLO" required ${formTipoProducto == 'POLO' ? 'checked' : ''} class="accent-fuchsia-600">
                        <span class="ml-2 font-bold" data-i18n="producto.polo">${msg['producto.polo']}</span>
                    </label>
                    <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 p-4 has-[:checked]:border-cyan-500 has-[:checked]:bg-cyan-50">
                        <input type="radio" name="tipoProducto" value="TAZA" required ${formTipoProducto == 'TAZA' ? 'checked' : ''} class="accent-cyan-600">
                        <span class="ml-2 font-bold" data-i18n="producto.taza">${msg['producto.taza']}</span>
                    </label>
<!--                    <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 p-4 has-[:checked]:border-amber-500 has-[:checked]:bg-amber-50">-->
<!--                        <input type="radio" name="tipoProducto" value="OTRO" required ${formTipoProducto == 'OTRO' ? 'checked' : ''} class="accent-amber-600">-->
<!--                        <span class="ml-2 font-bold">Otro producto</span>-->
<!--                    </label>-->
                </div>
            </fieldset>

            <div>
                <label for="cantidad" class="mb-2 block text-sm font-bold text-slate-700" data-i18n="campo.cantidad">${msg['campo.cantidad']}</label>
                <input id="cantidad" name="cantidad" type="number" value="${formCantidad}" min="1" max="1000" step="1" required data-i18n-placeholder="ejemplo.cantidad" placeholder="${msg['ejemplo.cantidad']}" class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 text-slate-950 outline-none focus:border-fuchsia-500 focus:ring-4 focus:ring-fuchsia-400/10">
            </div>

            <div id="poloFields" class="space-y-5 rounded-2xl bg-fuchsia-50/70 p-4 sm:p-5">
                <div>
                    <label for="variantePolo" class="mb-2 block text-sm font-bold text-slate-700" data-i18n="pedido.grosor">${msg['pedido.grosor']}</label>
                    <select id="variantePolo" name="variantePolo" class="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-950">
                        <option value="" data-i18n="pedido.elegirTejido">${msg['pedido.elegirTejido']}</option>
                        <c:forEach items="${formulario.polos}" var="polo">
                            <option value="${polo.id}" ${formVariantePolo == polo.id ? 'selected' : ''}
                                    data-i18n="catalogo.variante" data-arg-0="<c:out value='${polo.tejido}'/>"
                                    data-arg-1="<c:out value='${polo.talla}'/>" data-arg-2="${polo.precio}"><c:out value="${polo.etiqueta.mostrar(i18n)}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <fieldset>
                    <legend class="mb-2 text-sm font-bold text-slate-700" data-i18n="pedido.diseno">${msg['pedido.diseno']}</legend>
                    <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
                        <c:forEach items="${formulario.disenosPolo}" var="diseno">
                            <label class="cursor-pointer rounded-xl border border-slate-200 bg-white p-4 has-[:checked]:border-fuchsia-500">
                                <input type="radio" name="disenoPolo" value="${diseno.codigo}" ${formDisenoPolo == diseno.codigo || (empty formDisenoPolo && diseno.codigo == 'clasico') ? 'checked' : ''}>
                                <span class="ml-2 font-bold"><c:out value="${diseno.nombre}"/></span>
                                <span class="mt-1 block text-xs text-slate-500"><span data-i18n="pedido.adicional">${msg['pedido.adicional']}</span> <c:out value="${diseno.adicional}"/> <span data-i18n="pedido.porPolo">${msg['pedido.porPolo']}</span></span>
                            </label>
                        </c:forEach>
                    </div>
                </fieldset>
            </div>

            <div id="tazaFields" class="space-y-5 rounded-2xl bg-cyan-50/70 p-4 sm:p-5">
                <div>
                    <label for="onzasTaza" class="mb-2 block text-sm font-bold text-slate-700" data-i18n="pedido.capacidad">${msg['pedido.capacidad']}</label>
                    <select id="onzasTaza" name="onzasTaza" class="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-950">
                        <option value="" data-i18n="pedido.elegirOnzas">${msg['pedido.elegirOnzas']}</option>
                        <c:forEach items="${formulario.onzasTaza}" var="onzas">
                            <option value="${onzas}" ${formOnzasTaza == onzas ? 'selected' : ''}>${onzas} oz</option>
                        </c:forEach>
                    </select>
                </div>
                <fieldset>
                    <legend class="mb-2 text-sm font-bold text-slate-700" data-i18n="pedido.caja">${msg['pedido.caja']}</legend>
                    <div class="grid grid-cols-1 gap-3 sm:grid-cols-3">
                        <c:forEach items="${formulario.empaquesTaza}" var="empaque">
                            <label class="cursor-pointer rounded-xl border border-slate-200 bg-white p-3 has-[:checked]:border-cyan-500">
                                <input type="radio" name="empaqueTaza" value="${empaque.codigo}" ${formEmpaqueTaza == empaque.codigo || (empty formEmpaqueTaza && empaque.codigo == 'sin_caja') ? 'checked' : ''}>
                                <span class="ml-1 text-sm font-bold"><c:out value="${empaque.nombre}"/></span>
                                <span class="mt-1 block text-xs text-slate-500">+ S/ <c:out value="${empaque.adicional}"/> <span data-i18n="pedido.porTaza">${msg['pedido.porTaza']}</span></span>
                            </label>
                        </c:forEach>
                    </div>
                </fieldset>
            </div>

            <div id="otroFields" class="space-y-5 rounded-2xl bg-amber-50/70 p-4 sm:p-5">
                <div><label for="productoAdicionalId" class="mb-2 block text-sm font-bold text-slate-700" data-i18n="pedido.disponible">${msg['pedido.disponible']}</label>
                    <select id="productoAdicionalId" name="productoAdicionalId" class="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-950">
                        <option value="" data-i18n="pedido.elegirProducto">${msg['pedido.elegirProducto']}</option>
                        <c:forEach items="${formulario.productosAdicionales}" var="producto"><option value="${producto.id}" ${formProductoAdicionalId == producto.id ? 'selected' : ''}><c:out value="${producto.nombre}"/> — S/ <c:out value="${producto.precio}"/></option></c:forEach>
                    </select>
                    <c:if test="${empty formulario.productosAdicionales}"><p class="mt-2 text-sm text-slate-500" data-i18n="pedido.sinProductos">${msg['pedido.sinProductos']}</p></c:if>
                </div>
            </div>

            <button type="submit" class="w-full rounded-xl bg-gradient-to-r from-fuchsia-600 to-pink-500 px-6 py-4 font-black text-white shadow-lg transition hover:-translate-y-0.5 focus:ring-4 focus:ring-fuchsia-300 cursor-pointer" data-i18n="pedido.calcular">${msg['pedido.calcular']}</button>
        </form>
    </section>
</main>
<script>
    const polos = document.getElementById('poloFields');
    const tazas = document.getElementById('tazaFields');
    const otros = document.getElementById('otroFields');
    function cambiarProducto() {
        const tipo = document.querySelector('input[name="tipoProducto"]:checked')?.value;
        polos.hidden = tipo !== 'POLO';
        tazas.hidden = tipo !== 'TAZA';
        otros.hidden = tipo !== 'OTRO';
        polos.querySelectorAll('select,input').forEach(campo => campo.disabled = tipo !== 'POLO');
        tazas.querySelectorAll('select,input').forEach(campo => campo.disabled = tipo !== 'TAZA');
        otros.querySelectorAll('select,input').forEach(campo => campo.disabled = tipo !== 'OTRO');
    }
    document.querySelectorAll('input[name="tipoProducto"]').forEach(campo => campo.addEventListener('change', cambiarProducto));
    cambiarProducto();
</script>
</body>
</html>
