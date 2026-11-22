<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="texto" required="true" type="com.utp.i18n.TextoRecibo" %>
<%@ attribute name="mensajes" required="true" type="com.utp.i18n.Mensajes" %>
<span data-i18n="${texto.clave}"<c:forEach items="${texto.argumentos}" var="arg" varStatus="pos"> data-arg-${pos.index}="<c:out value='${arg}'/>"</c:forEach>><c:out value="${texto.mostrar(mensajes)}"/></span>
