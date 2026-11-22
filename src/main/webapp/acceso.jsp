<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/includes/mensajes.jspf" %>
<!DOCTYPE html>
<html lang="${i18n.idioma}">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title data-i18n="acceso.titulo">${msg['acceso.titulo']}</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script defer src="${pageContext.request.contextPath}/assets/idioma.js"></script>
</head>
<body class="grid min-h-screen place-items-center bg-slate-50 px-4 py-8 text-slate-900">
<main class="w-full max-w-md rounded-3xl border border-slate-200 bg-white p-6 shadow-xl sm:p-9">
    <a class="inline-flex w-fit max-w-full min-w-0 items-center gap-3" href="${pageContext.request.contextPath}/">
        <img alt="Inkfinity Sublimados" class="h-11 w-11 shrink-0 rounded-full border border-slate-200 object-cover md:h-12 md:w-12"
             src="${pageContext.request.contextPath}/assets/logo-inkfinity.png">
        <span class="min-w-0 text-sm font-black leading-snug tracking-tight md:text-base"><span class="block md:inline">INKFINITY</span> <span class="block md:inline">SUBLIMADOS</span></span>
    </a>
        <%@ include file="/WEB-INF/includes/idioma.jspf" %>
    <p class="mt-8 text-sm font-black uppercase tracking-[.2em] text-fuchsia-700" data-i18n="acceso.area">${msg['acceso.area']}</p>
    <h1 class="mt-2 text-3xl font-black" data-i18n="acceso.entrar">${msg['acceso.entrar']}</h1>
    <p class="mt-2 text-sm leading-6 text-slate-600" data-i18n="acceso.ayuda">${msg['acceso.ayuda']}</p>
    <c:if test="${not empty error}">
        <div class="mt-5 rounded-xl border border-rose-300 bg-rose-50 p-3 text-sm text-rose-800" role="alert">
            <span data-i18n="<c:out value='${error}'/>"><c:out value="${msg[error]}"/></span>
        </div>
    </c:if>
    <form action="${pageContext.request.contextPath}/acceso" class="mt-6 space-y-5" method="post">
        <div>
            <label class="mb-2 block text-sm font-bold" for="dni" data-i18n="campo.dni">${msg['campo.dni']}</label>
            <input autocomplete="username"
                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-fuchsia-500"
                   id="dni" inputmode="numeric" maxlength="8" minlength="8" name="dni" pattern="[0-9]{8}"
                   data-i18n-placeholder="campo.ochoDigitos" placeholder="${msg['campo.ochoDigitos']}" required type="text" value="<c:out value='${formDni}'/>">
        </div>
        <div>
            <label class="mb-2 block text-sm font-bold" for="contrasena" data-i18n="campo.contrasena">${msg['campo.contrasena']}</label>
            <input autocomplete="current-password"
                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-fuchsia-500"
                   id="contrasena" name="contrasena" required type="password">
        </div>
        <button class="w-full rounded-xl bg-slate-950 px-5 py-3.5 font-bold text-white hover:bg-cyan-700 cursor-pointer"
                type="submit" data-i18n="accion.iniciar">
            ${msg['accion.iniciar']}
        </button>
    </form>
    <div class="mt-5 border-t border-slate-200 pt-5 text-center">
        <p class="text-sm text-slate-600" data-i18n="acceso.sinCuenta">${msg['acceso.sinCuenta']}</p>
        <a class="mt-3 inline-flex w-full justify-center rounded-xl border border-fuchsia-300 bg-fuchsia-50 px-5 py-3 font-bold text-fuchsia-800 hover:bg-fuchsia-100"
           href="${pageContext.request.contextPath}/registro" data-i18n="accion.registrarme">${msg['accion.registrarme']}</a>
    </div>
    <a class="mt-5 block text-center text-sm font-semibold text-slate-500 hover:text-slate-900"
       href="${pageContext.request.contextPath}/" data-i18n="accion.inicio">${msg['accion.inicio']}</a>
</main>
</body>
</html>
