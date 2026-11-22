<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/includes/mensajes.jspf" %>
<!DOCTYPE html>
<html lang="${i18n.idioma}">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title data-i18n="admin.titulo">${msg['admin.titulo']}</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <style>
        button, input[type="submit"], input[type="button"], input[type="reset"],
        input[type="checkbox"], select { cursor: pointer; }
        button:disabled { cursor: not-allowed; }
        main button { min-height: 44px; }
        main input:not([type="hidden"]):not([type="checkbox"]), main select {
            min-width: 0;
            width: 100%;
            min-height: 44px;
            font-size: 1rem;
        }
        button:focus-visible {
            outline: 2px solid #0e7490;
            outline-offset: 3px;
        }
        .admin-toggle {
            display: inline-flex;
            min-height: 44px;
            align-items: center;
            gap: .5rem;
            cursor: pointer;
        }
        .admin-toggle input { width: 1rem; height: 1rem; flex-shrink: 0; }
        @media (max-width: 639px) {
            .orders-table, .orders-table tbody { display: block; min-width: 0; }
            .orders-table thead {
                position: absolute;
                width: 1px;
                height: 1px;
                overflow: hidden;
                clip-path: inset(50%);
            }
            .orders-table tbody { display: grid; gap: 1rem; }
            .orders-table tr {
                display: block;
                border: 1px solid #e2e8f0;
                border-radius: .75rem;
                padding: .75rem;
            }
            .orders-table td[data-label] {
                display: grid;
                grid-template-columns: minmax(0, 2fr) minmax(0, 3fr);
                gap: .75rem;
                max-width: none;
                padding: .5rem 0;
                overflow-wrap: anywhere;
            }
            .orders-table td[data-label]::before {
                content: attr(data-label);
                color: #64748b;
                font-size: .75rem;
                font-weight: 600;
            }
            .orders-table td > div { min-width: 0; }
        }
    </style>
    <script defer src="${pageContext.request.contextPath}/assets/idioma.js"></script>
</head>
<body class="min-h-screen bg-slate-100 text-slate-900 antialiased">
<header class="border-b border-slate-200 bg-white">
    <div class="mx-auto flex w-full max-w-7xl flex-col gap-3 px-4 py-3.5 md:flex-row md:flex-wrap md:items-center md:justify-between md:gap-x-6 md:gap-y-4 md:px-6 md:py-4 lg:px-8">
        <a class="inline-flex w-fit max-w-full min-w-0 items-center gap-3 md:shrink-0" href="${pageContext.request.contextPath}/"><img
                alt="Inkfinity Sublimados" class="h-11 w-11 shrink-0 rounded-full border border-slate-200 object-cover md:h-12 md:w-12 lg:h-14 lg:w-14"
                src="${pageContext.request.contextPath}/assets/logo-inkfinity.png">
            <span class="min-w-0 text-sm font-black leading-snug tracking-tight md:text-base lg:text-lg"><span class="block md:inline">INKFINITY</span>
                <span class="block text-cyan-700 md:inline" data-i18n="admin.marca">${msg['admin.marca']}</span>
            </span>
        </a>
        <%@ include file="/WEB-INF/includes/idioma.jspf" %>
        <c:if test="${not empty sessionScope.administradorSesion}">
            <div class="flex min-w-0 items-center gap-4 border-t border-slate-100 pt-3 md:flex-1 md:justify-end md:border-0 md:pt-0">
                <span class="min-w-0 flex-1 break-words text-sm font-semibold leading-6 text-slate-600 md:max-w-sm md:flex-initial"><span data-i18n="saludo">${msg['saludo']}</span>
                <c:out value="${sessionScope.administradorSesion}"/>
                </span>
                <form action="${pageContext.request.contextPath}/administracion" method="post" class="m-0 shrink-0">
                    <input name="accion" type="hidden" value="cerrarSesion">
                    <button type="submit" class="inline-flex min-h-11 cursor-pointer items-center justify-center whitespace-nowrap rounded-full border border-slate-300 bg-white px-3.5 py-2.5 text-sm font-bold leading-tight text-slate-800 transition-colors hover:border-rose-300 hover:bg-rose-50 hover:text-rose-700" data-i18n="accion.cerrar">
                        ${msg['accion.cerrar']}
                    </button>
                </form>
            </div>
        </c:if>
    </div>
</header>
<main class="mx-auto w-full min-w-0 max-w-7xl px-4 py-6 sm:px-6 sm:py-10 lg:px-8">
    <c:if test="${not empty error}">
        <div class="mb-6 rounded-2xl border border-rose-300 bg-rose-50 p-4 text-sm font-medium text-rose-800"
             role="alert">
            <span data-i18n="<c:out value='${error}'/>"><c:out value="${msg[error]}"/></span>
        </div>
    </c:if>
    <c:if test="${not empty aviso}">
        <div class="mb-6 rounded-2xl border border-emerald-300 bg-emerald-50 p-4 text-sm font-medium text-emerald-800"
             role="status">
            <span data-i18n="<c:out value='${aviso}'/>"><c:out value="${msg[aviso]}"/></span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty sessionScope.administradorSesion}">
            <section class="mx-auto min-w-0 max-w-xl rounded-3xl border border-slate-200 bg-white p-5 shadow-xl sm:p-8">
                <p class="text-xs font-black uppercase tracking-[.24em] text-cyan-700" data-i18n="admin.privado">${msg['admin.privado']}</p>
                <h1 class="mt-2 break-words text-2xl font-black sm:text-3xl" data-i18n="admin.encabezado">${msg['admin.encabezado']}</h1>
                <c:choose>
                    <c:when test="${!existeAdmin}">
                        <p class="mt-3 text-sm leading-6 text-slate-600" data-i18n="admin.creacionAyuda">${msg['admin.creacionAyuda']}</p>
                        <form action="${pageContext.request.contextPath}/administracion" class="mt-6 space-y-4"
                              method="post">
                            <input name="accion" type="hidden" value="crearSuperAdmin">
                            <div>
                                <label class="mb-1 block text-sm font-bold" for="nombre" data-i18n="admin.nombre">${msg['admin.nombre']}</label>
                                <input class="w-full rounded-xl border border-slate-300 px-4 py-3" id="nombre"
                                       maxlength="80" minlength="2" name="nombre" required>
                            </div>
                            <div>
                                <label class="mb-1 block text-sm font-bold" for="dni" data-i18n="campo.dni">${msg['campo.dni']}</label>
                                <input class="w-full rounded-xl border border-slate-300 px-4 py-3"
                                       id="dni" inputmode="numeric" maxlength="8" name="dni" pattern="[0-9]{8}"
                                       required>
                            </div>
                            <div>
                                <label class="mb-1 block text-sm font-bold" for="contrasena" data-i18n="campo.contrasena">${msg['campo.contrasena']}</label>
                                <input autocomplete="new-password"
                                       class="w-full rounded-xl border border-slate-300 px-4 py-3" id="contrasena"
                                       minlength="8" name="contrasena" required type="password">
                                <p class="mt-1 text-xs text-slate-500" data-i18n="campo.minimoClave">${msg['campo.minimoClave']}</p>
                            </div>
                            <button class="w-full cursor-pointer rounded-xl bg-cyan-700 px-5 py-3 font-black text-white hover:bg-cyan-800" data-i18n="admin.crear">
                                ${msg['admin.crear']}
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p class="mt-3 text-sm leading-6 text-slate-600" data-i18n="admin.accesoAyuda">${msg['admin.accesoAyuda']}</p>
                        <form action="${pageContext.request.contextPath}/administracion" class="mt-6 space-y-4"
                              method="post">
                            <input name="accion" type="hidden" value="iniciarSesion">
                            <div>
                                <label class="mb-1 block text-sm font-bold" for="dni" data-i18n="campo.dni">${msg['campo.dni']}</label>
                                <input autocomplete="username"
                                       class="w-full rounded-xl border border-slate-300 px-4 py-3"
                                       id="dni" inputmode="numeric" maxlength="8" name="dni" pattern="[0-9]{8}"
                                       required>
                            </div>
                            <div>
                                <label class="mb-1 block text-sm font-bold" for="contrasena" data-i18n="campo.contrasena">${msg['campo.contrasena']}</label>
                                <input autocomplete="current-password"
                                       class="w-full rounded-xl border border-slate-300 px-4 py-3" id="contrasena"
                                       name="contrasena" required type="password">
                            </div>
                            <button class="w-full rounded-xl bg-cyan-700 px-5 py-3 font-black text-white hover:bg-cyan-800 cursor-pointer" data-i18n="accion.iniciar">
                                ${msg['accion.iniciar']}
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </section>
        </c:when>
        <c:otherwise>
            <div class="mb-8">
                <p class="text-xs font-black uppercase tracking-[.24em] text-cyan-700" data-i18n="admin.panel">${msg['admin.panel']}</p>
                <h1 class="mt-2 break-words text-2xl font-black sm:text-3xl" data-i18n="admin.resumen">${msg['admin.resumen']}</h1>
                <p class="mt-2 text-slate-600" data-i18n="admin.preciosAyuda">${msg['admin.preciosAyuda']}</p>
            </div>
            <section class="min-w-0 rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-6">
                <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between sm:gap-4">
                    <div class="min-w-0">
                        <h2 class="text-xl font-black" data-i18n="admin.pedidos">${msg['admin.pedidos']}</h2>
                        <p class="mt-1 text-sm text-slate-500" data-i18n="admin.clientesAyuda">${msg['admin.clientesAyuda']}</p>
                    </div>
                    <span class="w-fit shrink-0 rounded-full bg-cyan-50 px-3 py-1 text-sm font-bold text-cyan-800">
                        <c:out value="${pedidos.size()}"/> <span data-i18n="admin.conteo">${msg['admin.conteo']}</span>
                    </span>
                </div>
                <div class="mt-5 min-w-0 overflow-x-auto" role="region" data-i18n-aria-label="admin.pedidos" aria-label="${msg['admin.pedidos']}" tabindex="0">
                    <table class="orders-table w-full sm:min-w-[1100px] text-left text-sm">
                        <thead class="border-b border-slate-200 text-xs uppercase tracking-wide text-slate-500">
                        <tr>
                            <th class="px-3 py-3" data-i18n="campo.recibo">${msg['campo.recibo']}</th>
                            <th class="px-3 py-3" data-i18n="campo.fecha">${msg['campo.fecha']}</th>
                            <th class="px-3 py-3" data-i18n="campo.cliente">${msg['campo.cliente']}</th>
                            <th class="px-3 py-3" data-i18n="campo.tipoCliente">${msg['campo.tipoCliente']}</th>
                            <th class="px-3 py-3" data-i18n="campo.contacto">${msg['campo.contacto']}</th>
                            <th class="px-3 py-3" data-i18n="campo.producto">${msg['campo.producto']}</th>
                            <th class="px-3 py-3" data-i18n="campo.cantidad">${msg['campo.cantidad']}</th>
<!--                            <th class="px-3 py-3">Subtotal</th>-->
<!--                            <th class="px-3 py-3">Descuento</th>-->
<!--                            <th class="px-3 py-3">IGV incluido</th>-->
                            <th class="px-3 py-3" data-i18n="campo.total">${msg['campo.total']}</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                        <c:forEach items="${pedidos}" var="p">
                            <tr class="align-top">
                                <td data-i18n-data-label="campo.recibo" data-label="${msg['campo.recibo']}" class="px-3 py-3 font-bold"><div>#
                                    <c:out value="${p.id}"/>
                                </div></td>
                                <td data-i18n-data-label="campo.fecha" data-label="${msg['campo.fecha']}" class="px-3 py-3"><div>
                                    <c:out value="${p.creado_en}"/>
                                </div></td>
                                <td data-i18n-data-label="campo.cliente" data-label="${msg['campo.cliente']}" class="px-3 py-3"><div>
                                    <c:out value="${p.cliente}"/>
                                    <c:if test="${not empty p.dni}">
                                        <span class="block text-xs text-slate-500"><span data-i18n="campo.dni">${msg['campo.dni']}</span>
                                            <c:out value="${p.dni}"/>
                                        </span>
                                    </c:if>
                                </div></td>
                                <td data-i18n-data-label="campo.tipoCliente" data-label="${msg['campo.tipoCliente']}" class="px-3 py-3"><div>
                                    <span class="rounded-full px-2.5 py-1 text-xs font-bold ${p.estado_cliente == 'Registrado' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'}">
                                        <c:out value="${p.estado_cliente}"/>
                                    </span>
                                </div></td>
                                <td data-i18n-data-label="campo.contacto" data-label="${msg['campo.contacto']}" class="px-3 py-3"><div>
                                    <c:out value="${p.celular}"/>
                                </div></td>
                                <td data-i18n-data-label="campo.producto" data-label="${msg['campo.producto']}" class="max-w-xs px-3 py-3"><div>
                                    <c:out value="${p.tipo_producto}"/>
                                    <span class="block text-xs text-slate-500">
                                        <c:out value="${p.detalle_precio}"/>
                                    </span>
                                </div></td>
                                <td data-i18n-data-label="campo.cantidad" data-label="${msg['campo.cantidad']}" class="px-3 py-3"><div>
                                    <c:out value="${p.cantidad}"/>
                                </div></td>
<!--                                <td data-label="Subtotal" class="px-3 py-3"><div>S/-->
<!--                                    <c:out value="${p.subtotal}"/>-->
<!--                                </div></td>-->
<!--                                <td data-label="Descuento" class="px-3 py-3"><div>S/-->
<!--                                    <c:out value="${p.descuento}"/>-->
<!--                                </div></td>-->
<!--                                <td data-label="IGV incluido" class="px-3 py-3"><div>S/-->
<!--                                    <c:out value="${p.igv}"/>-->
                                </div></td>
                                <td data-i18n-data-label="campo.total" data-label="${msg['campo.total']}" class="px-3 py-3 font-black"><div>S/
                                    <c:out value="${p.total}"/>
                                </div></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pedidos}">
                            <tr>
                                <td class="px-3 py-10 text-center text-slate-500" colspan="11" data-i18n="admin.sinPedidos">${msg['admin.sinPedidos']}
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="mt-6 grid min-w-0 grid-cols-1 gap-4 sm:mt-8 sm:gap-6 xl:grid-cols-2">
                <div class="min-w-0 rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-6"><h2 class="text-xl font-black" data-i18n="admin.preciosPolos">
                    ${msg['admin.preciosPolos']}</h2>
                    <div class="mt-4 space-y-3">
                        <c:forEach items="${polos}" var="p">
                            <form class="grid min-w-0 grid-cols-2 items-end gap-3 rounded-xl bg-slate-50 p-3 sm:grid-cols-[minmax(0,1fr)_minmax(0,9rem)_auto_auto]"
                                  method="post">
                                <input name="accion" type="hidden" value="actualizarPolo">
                                <input name="id" type="hidden" value="${p.id}">
                                <span class="col-span-2 min-w-0 break-words font-bold sm:col-span-1 sm:self-center"><c:out value="${p.tejido}"/> <span data-i18n="campo.tallaDetalle">${msg['campo.tallaDetalle']}</span>
                                    <c:out value="${p.talla}"/>
                                </span>
                                <label class="col-span-2 min-w-0 text-xs text-slate-500 sm:col-span-1"><span data-i18n="campo.precio">${msg['campo.precio']}</span><input
                                        class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900"
                                        min="0" name="precio" required step="0.01" type="number"
                                        value="${p.precio}">
                                </label>
                                <label class="admin-toggle text-sm"><span data-i18n="campo.activo">${msg['campo.activo']}</span>
                                    <input name="activo" type="checkbox" <c:if test="${p.activo}">checked="checked"</c:if>>
                                </label>
                                <button class="cursor-pointer rounded-lg bg-slate-900 px-3 py-2 text-sm font-bold text-white hover:bg-slate-700" data-i18n="accion.guardar">${msg['accion.guardar']}
                                </button>
                            </form>
                        </c:forEach>
                    </div>
                    <form class="mt-4 grid min-w-0 grid-cols-1 items-end gap-3 border-t border-slate-200 pt-4 sm:grid-cols-2" method="post">
                        <input name="accion" type="hidden" value="agregarPolo">
                        <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.tejido">${msg['campo.tejido']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" maxlength="10"
                                   name="tejido" placeholder="24/1" required>
                        </label>
                        <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.talla">${msg['campo.talla']}</span>
                        <select class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900" name="talla">
                            <option>S</option>
                            <option>M</option>
                            <option>L</option>
                            <option>XL</option>
                        </select>
                        </label>
                        <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.precio">${msg['campo.precio']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" min="0"
                                   name="precio" placeholder="0.00" required step="0.01" type="number">
                        </label>
                        <button class="cursor-pointer rounded-lg bg-cyan-700 px-3 py-2 text-sm font-bold text-white hover:bg-cyan-800" data-i18n="admin.agregarPolo">${msg['admin.agregarPolo']}
                        </button>
                    </form>
                </div>
                <div class="min-w-0 rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-6"><h2 class="text-xl font-black" data-i18n="admin.tarifasTazas">
                    ${msg['admin.tarifasTazas']}</h2>
                    <div class="mt-4 space-y-3">
                        <c:forEach items="${tazas}" var="t">
                            <form class="rounded-xl bg-slate-50 p-3" method="post">
                                <input name="accion" type="hidden" value="actualizarTaza"><input
                                    name="onzas" type="hidden" value="${t.onzas}">
                                <div class="mb-2 flex items-center justify-between">
                                    <span class="font-black">
                                        <c:out value="${t.onzas}"/> oz</span>
                                    <label class="admin-toggle text-sm"><span data-i18n="campo.activo">${msg['campo.activo']}</span>
                                        <input name="activo" type="checkbox" <c:if test="${t.activo}">checked="checked"</c:if>>
                                    </label>
                                </div>
                                <div class="grid min-w-0 grid-cols-1 items-end gap-3 min-[480px]:grid-cols-3">
                                    <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.unidad">${msg['campo.unidad']}</span>
                                        <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900"
                                               min="0" name="unidad" required step="0.01" type="number"
                                               value="${t.unidad}">
                                    </label>
                                    <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.mediaDocena">${msg['campo.mediaDocena']}</span>
                                        <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900"
                                               min="0" name="media" required step="0.01" type="number"
                                               value="${t.media_docena}">
                                    </label>
                                    <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.docena">${msg['campo.docena']}</span>
                                        <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900"
                                               min="0" name="docena" required step="0.01" type="number"
                                               value="${t.docena}">
                                    </label>
                                    <button class="col-span-full cursor-pointer rounded-lg bg-slate-900 px-3 py-2 text-sm font-bold text-white hover:bg-slate-700" data-i18n="accion.guardar">
                                        ${msg['accion.guardar']}
                                    </button>
                                </div>
                            </form>
                        </c:forEach>
                    </div>
                    <form class="mt-4 grid min-w-0 grid-cols-1 gap-3 border-t border-slate-200 pt-4 sm:grid-cols-2" method="post">
                        <input
                                name="accion" type="hidden" value="agregarTaza">
                        <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.capacidad">${msg['campo.capacidad']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" max="100" min="1"
                                   name="onzas" placeholder="11" required type="number">
                        </label>
                        <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.unidad">${msg['campo.unidad']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" min="0" name="unidad"
                                   placeholder="0.00" required step="0.01" type="number">
                        </label>
                        <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.mediaDocena">${msg['campo.mediaDocena']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" min="0"
                                   name="media" placeholder="0.00" required step="0.01" type="number">
                        </label>
                        <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.docena">${msg['campo.docena']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" min="0" name="docena"
                                   placeholder="0.00" required step="0.01" type="number">
                        </label>
                        <button class="col-span-full cursor-pointer rounded-lg bg-cyan-700 px-3 py-2 text-sm font-bold text-white hover:bg-cyan-800" data-i18n="admin.agregarTaza">${msg['admin.agregarTaza']}
                        </button>
                    </form>
                </div>
            </section>

            <section class="mt-6 grid min-w-0 grid-cols-1 gap-4 sm:gap-6 xl:grid-cols-2">
                <div class="min-w-0 rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-6"><h2 class="text-xl font-black" data-i18n="admin.disenosEmpaques">
                    ${msg['admin.disenosEmpaques']}</h2>
                    <c:forEach items="${disenos}" var="d">
                        <form class="mt-3 grid min-w-0 grid-cols-2 items-end gap-3 rounded-xl bg-slate-50 p-3 sm:grid-cols-[minmax(0,1fr)_minmax(0,9rem)_auto_auto]"
                              method="post">
                            <input name="accion" type="hidden" value="actualizarDiseno">
                            <input name="codigo" type="hidden" value="${d.codigo}">
                            <span class="col-span-2 min-w-0 break-words font-bold sm:col-span-1 sm:self-center">
                                <c:out value="${d.nombre}"/>
                            </span>
                            <label class="col-span-2 min-w-0 text-xs text-slate-500 sm:col-span-1"><span data-i18n="campo.adicional">${msg['campo.adicional']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900" min="0" name="adicional"
                                   step="0.01" type="number" value="${d.adicional_unitario}">
                            </label>
                            <label class="admin-toggle text-sm"><span data-i18n="campo.activo">${msg['campo.activo']}</span>
                                <input name="activo" type="checkbox" <c:if test="${d.activo}">checked="checked"</c:if>>
                            </label>
                            <button class="cursor-pointer rounded-lg bg-slate-900 px-3 py-2 text-sm font-bold text-white hover:bg-slate-700" data-i18n="accion.guardar">${msg['accion.guardar']}
                            </button>
                        </form>
                    </c:forEach>
                    <c:forEach items="${empaques}" var="e">
                        <form class="mt-3 grid min-w-0 grid-cols-2 items-end gap-3 rounded-xl bg-cyan-50 p-3"
                              method="post">
                            <input name="accion" type="hidden" value="actualizarEmpaque">
                            <input name="codigo" type="hidden" value="${e.codigo}">
                            <span class="col-span-2 min-w-0 break-words text-sm font-bold"><c:out value="${e.codigo}"/></span>
                            <label class="col-span-2 min-w-0 text-xs text-slate-500 sm:col-span-1"><span data-i18n="campo.nombre">${msg['campo.nombre']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900" name="nombre"
                                   required value="${e.nombre}">
                            </label>
                            <label class="col-span-2 min-w-0 text-xs text-slate-500 sm:col-span-1"><span data-i18n="campo.adicional">${msg['campo.adicional']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900" min="0" name="adicional"
                                   step="0.01" type="number" value="${e.adicional_unitario}">
                            </label>
                            <label class="admin-toggle text-sm"><span data-i18n="campo.activo">${msg['campo.activo']}</span>
                                <input name="activo" type="checkbox" <c:if test="${e.activo}">checked="checked"</c:if>>
                            </label>
                            <button class="cursor-pointer rounded-lg bg-slate-900 px-3 py-2 text-sm font-bold text-white hover:bg-slate-700" data-i18n="accion.guardar">${msg['accion.guardar']}
                            </button>
                        </form>
                    </c:forEach>
                </div>
                <div class="min-w-0 rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-6">
                    <h2 class="text-xl font-black" data-i18n="admin.descuentos">${msg['admin.descuentos']}</h2>
                    <p class="mt-1 text-sm text-slate-500" data-i18n="admin.impuestoAyuda">${msg['admin.impuestoAyuda']}</p>
                    <div class="mt-4 space-y-2">
                        <c:forEach items="${descuentos}" var="d">
                            <div class="grid min-w-0 grid-cols-1 items-end gap-3 rounded-xl bg-slate-50 p-3 sm:grid-cols-[minmax(0,1fr)_auto]">
                                <form class="grid min-w-0 grid-cols-2 items-end gap-3 sm:grid-cols-[minmax(0,1fr)_minmax(0,7rem)_auto]" method="post">
                                    <input name="accion" type="hidden" value="actualizarDescuento">
                                    <input name="cantidad" type="hidden" value="${d.cantidad_minima}">
                                    <span class="col-span-2 text-sm sm:col-span-1 sm:self-center"><span data-i18n="campo.desde">${msg['campo.desde']}</span> <strong><c:out value="${d.cantidad_minima}"/></strong> <span data-i18n="campo.unidadesAbrev">${msg['campo.unidadesAbrev']}</span></span>
                                    <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.descuento">${msg['campo.descuento']}</span>
                                        <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900"
                                               max="100" min="0" name="porcentaje" required step="0.01" type="number"
                                                value="${d.porcentaje}">
                                    </label>
                                    <button class="cursor-pointer rounded-lg bg-slate-900 px-3 py-2 text-sm font-bold text-white hover:bg-slate-700" data-i18n="accion.guardar">
                                        ${msg['accion.guardar']}
                                    </button>
                                </form>
                                <c:if test="${d.cantidad_minima != 1}">
                                    <form class="min-w-0" method="post">
                                        <input name="accion" type="hidden" value="eliminarDescuento">
                                        <input name="cantidad" type="hidden" value="${d.cantidad_minima}">
                                        <button class="w-full cursor-pointer rounded-lg border border-rose-200 px-3 py-2 text-sm font-bold text-rose-700 hover:bg-rose-50" data-i18n="accion.eliminar">${msg['accion.eliminar']}</button>
                                    </form>
                                </c:if>
                            </div>
                        </c:forEach>
                        <form class="grid min-w-0 grid-cols-1 items-end gap-3 rounded-xl border border-dashed border-slate-300 p-3 sm:grid-cols-2"
                              method="post">
                            <input name="accion" type="hidden" value="actualizarDescuento">
                            <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.desdeUnidades">${msg['campo.desdeUnidades']}</span>
                                <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" min="1" name="cantidad"
                                       placeholder="24" required
                                       type="number"></label>
                            <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.descuento">${msg['campo.descuento']}</span>
                                <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900"
                                       max="100" min="0" name="porcentaje" placeholder="15" required step="0.01"
                                        type="number">
                            </label>
                            <button class="col-span-full cursor-pointer rounded-lg bg-cyan-700 px-3 py-2 text-sm font-bold text-white hover:bg-cyan-800" data-i18n="admin.agregarTramo">${msg['admin.agregarTramo']}
                            </button>
                        </form>
                    </div>
                    <c:forEach items="${configuracion}" var="cfg">
                        <c:if test="${cfg.clave == 'igv_porcentaje'}">
                            <form class="mt-5 grid min-w-0 grid-cols-1 items-end gap-3 border-t border-slate-200 pt-5 sm:grid-cols-[minmax(0,1fr)_auto]" method="post">
                                <input name="accion" type="hidden" value="actualizarIGV">
                                <label class="min-w-0 text-sm font-bold" for="valor"><span data-i18n="campo.igvActual">${msg['campo.igvActual']}</span>
                                <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2"
                                       id="valor" max="100" min="0" name="valor" required step="0.01" type="number"
                                       value="${cfg.valor}">
                                </label>
                                <button class="cursor-pointer rounded-lg bg-cyan-700 px-4 py-2 text-sm font-bold text-white hover:bg-cyan-800" data-i18n="accion.actualizar">
                                    ${msg['accion.actualizar']}
                                </button>
                            </form>
                        </c:if>
                    </c:forEach>
                </div>
            </section>

            <section class="mt-6 min-w-0 rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-6">
                <h2 class="text-xl font-black" data-i18n="admin.productos">${msg['admin.productos']}</h2>
                <p class="mt-1 text-sm text-slate-500" data-i18n="admin.productosAyuda">${msg['admin.productosAyuda']}</p>
                <div class="mt-4 grid min-w-0 grid-cols-1 gap-3 xl:grid-cols-2">
                    <c:forEach items="${productos}" var="p">
                        <form class="grid min-w-0 grid-cols-2 items-end gap-3 rounded-xl bg-slate-50 p-3"
                              method="post">
                            <input name="accion" type="hidden" value="actualizarProducto">
                            <input name="id" type="hidden" value="${p.id}">
                            <label class="col-span-2 min-w-0 text-xs text-slate-500 sm:col-span-1"><span data-i18n="campo.nombre">${msg['campo.nombre']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900" maxlength="80"
                                   name="nombre" required value="${p.nombre}">
                            </label>
                            <label class="col-span-2 min-w-0 text-xs text-slate-500 sm:col-span-1"><span data-i18n="campo.descripcion">${msg['campo.descripcion']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900"
                                   maxlength="180" name="descripcion" data-i18n-placeholder="campo.descripcion" placeholder="${msg['campo.descripcion']}"
                                   value="${p.descripcion}">
                            </label>
                            <label class="col-span-2 min-w-0 text-xs text-slate-500"><span data-i18n="campo.precio">${msg['campo.precio']}</span>
                            <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900" min="0"
                                   name="precio" required step="0.01" type="number" value="${p.precio}">
                            </label>
                            <label class="admin-toggle text-sm"><span data-i18n="campo.activo">${msg['campo.activo']}</span>
                                <input name="activo" type="checkbox" <c:if test="${p.activo}">checked="checked"</c:if>>
                            </label>
                            <button class="cursor-pointer rounded-lg bg-slate-900 px-3 py-2 text-sm font-bold text-white hover:bg-slate-700" data-i18n="accion.guardar">${msg['accion.guardar']}
                            </button>
                        </form>
                    </c:forEach>
                </div>
                <form class="mt-4 grid min-w-0 grid-cols-1 items-end gap-3 border-t border-slate-200 pt-4 sm:grid-cols-2 lg:grid-cols-[minmax(0,1fr)_minmax(0,1fr)_minmax(0,10rem)_auto]"
                      method="post">
                    <input name="accion" type="hidden" value="agregarProducto">
                    <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.nombreProducto">${msg['campo.nombreProducto']}</span>
                    <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" maxlength="80"
                           minlength="2" name="nombre" data-i18n-placeholder="ejemplo.producto" placeholder="${msg['ejemplo.producto']}" required>
                    </label>
                    <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.descripcionOpcional">${msg['campo.descripcionOpcional']}</span>
                    <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" maxlength="180"
                           name="descripcion" data-i18n-placeholder="ejemplo.descripcion" placeholder="${msg['ejemplo.descripcion']}">
                    </label>
                    <label class="min-w-0 text-xs text-slate-500"><span data-i18n="campo.precio">${msg['campo.precio']}</span>
                    <input class="mt-1 w-full min-w-0 rounded-lg border border-slate-300 px-3 py-2 text-slate-900" min="0"
                           name="precio" data-i18n-placeholder="campo.precioSoles" placeholder="${msg['campo.precioSoles']}" required step="0.01" type="number">
                    </label>
                    <button class="cursor-pointer rounded-lg bg-cyan-700 px-4 py-2 text-sm font-bold text-white hover:bg-cyan-800" data-i18n="admin.agregarProducto">${msg['admin.agregarProducto']}
                    </button>
                </form>
            </section>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
