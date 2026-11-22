<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/includes/mensajes.jspf" %>
<!DOCTYPE html>
<html lang="${i18n.idioma}">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title data-i18n="registro.titulo">${msg['registro.titulo']}</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script defer src="${pageContext.request.contextPath}/assets/idioma.js"></script>
</head>
<body class="grid min-h-screen place-items-center bg-slate-50 px-4 py-8 text-slate-900">
<main class="w-full max-w-lg rounded-3xl border border-slate-200 bg-white p-6 shadow-xl sm:p-9">
    <a class="inline-flex w-fit max-w-full min-w-0 items-center gap-3" href="${pageContext.request.contextPath}/">
        <img alt="Inkfinity Sublimados" class="h-11 w-11 shrink-0 rounded-full border border-slate-200 object-cover md:h-12 md:w-12"
             src="${pageContext.request.contextPath}/assets/logo-inkfinity.png">
        <span class="min-w-0 text-sm font-black leading-snug tracking-tight md:text-base"><span class="block md:inline">INKFINITY</span> <span class="block md:inline">SUBLIMADOS</span></span>
    </a>
        <%@ include file="/WEB-INF/includes/idioma.jspf" %>
    <p class="mt-8 text-sm font-black uppercase tracking-[.2em] text-cyan-700" data-i18n="registro.nueva">${msg['registro.nueva']}</p>
    <h1 class="mt-2 text-3xl font-black" data-i18n="registro.registrate">${msg['registro.registrate']}</h1>
    <p class="mt-2 text-sm leading-6 text-slate-600" data-i18n="registro.ayuda">
        ${msg['registro.ayuda']}
    </p>
    <c:if test="${not empty error}">
        <div class="mt-5 rounded-xl border border-rose-300 bg-rose-50 p-3 text-sm text-rose-800" role="alert">
            <span data-i18n="<c:out value='${error}'/>"><c:out value="${msg[error]}"/></span>
        </div>
    </c:if>
    <form action="${pageContext.request.contextPath}/registro" class="mt-6 space-y-4" method="post">
        <div>
            <label class="mb-2 block text-sm font-bold" for="dni" data-i18n="campo.dni">${msg['campo.dni']}</label>
            <input autocomplete="username"
                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-cyan-600"
                   id="dni" inputmode="numeric" maxlength="8" minlength="8" name="dni"
                   pattern="[0-9]{8}" data-i18n-placeholder="campo.ochoDigitos" placeholder="${msg['campo.ochoDigitos']}" required type="text"
                   value="<c:out value='${formDni}'/>">
        </div>
        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
                <label class="mb-2 block text-sm font-bold" for="nombres" data-i18n="campo.nombres">${msg['campo.nombres']}</label>
                <input autocomplete="given-name"
                       class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-cyan-600"
                       id="nombres" maxlength="60" minlength="2"
                       name="nombres" required type="text"
                       value="<c:out value='${formNombres}'/>">
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold" for="apellidos" data-i18n="campo.apellidos">${msg['campo.apellidos']}</label>
                <input autocomplete="family-name"
                       class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-cyan-600"
                       id="apellidos" maxlength="60" minlength="2"
                       name="apellidos" required type="text"
                       value="<c:out value='${formApellidos}'/>">
            </div>
        </div>
        <div>
            <label class="mb-2 block text-sm font-bold" for="celular" data-i18n="campo.numeroCelular">${msg['campo.numeroCelular']}</label>
            <input autocomplete="tel"
                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-cyan-600"
                   id="celular" inputmode="numeric" maxlength="9" minlength="9"
                   name="celular" pattern="9[0-9]{8}" placeholder="987654321" required
                   type="tel"
                   value="<c:out value='${formCelular}'/>">
            <p class="mt-1 text-xs text-slate-500" data-i18n="campo.telefonoAyuda">${msg['campo.telefonoAyuda']}</p>
        </div>
        <div>
            <label class="mb-2 block text-sm font-bold" for="contrasena" data-i18n="campo.contrasena">${msg['campo.contrasena']}</label>
            <input autocomplete="new-password"
                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-cyan-600"
                   id="contrasena" minlength="8" name="contrasena" required
                   type="password">
        </div>
        <div>
            <label class="mb-2 block text-sm font-bold" for="confirmarContrasena" data-i18n="campo.confirmarClave">${msg['campo.confirmarClave']}</label>
            <input autocomplete="new-password"
                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 outline-none focus:border-cyan-600"
                   id="confirmarContrasena" minlength="8" name="confirmarContrasena"
                   required
                   type="password">
        </div>
        <button class="w-full rounded-xl bg-gradient-to-r from-fuchsia-600 to-cyan-600 px-5 py-3.5 font-bold text-white hover:brightness-110 cursor-pointer"
                type="submit" data-i18n="registro.crear">
            ${msg['registro.crear']}
        </button>
    </form>
    <p class="mt-5 text-center text-sm text-slate-600"><span data-i18n="registro.conCuenta">${msg['registro.conCuenta']}</span>
        <a class="font-bold text-fuchsia-700 hover:underline" href="${pageContext.request.contextPath}/acceso" data-i18n="acceso.entrar">
            ${msg['acceso.entrar']}
        </a>
    </p>
</main>
</body>
</html>
