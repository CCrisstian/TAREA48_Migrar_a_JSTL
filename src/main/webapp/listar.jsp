<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>TAREA 48: Migrar tarea anterior (proyecto de cursos) a JSTL</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<h1>TAREA 48: JSTL</h1>
<p><a href="${pageContext.request.contextPath}/cursos/form">Crear [+]</a></p>
<div class="form-container">
    <form action="${pageContext.request.contextPath}/buscar" method="post">
        <input type="text" id="nombre" name="nombre" required>
        <input type="submit" value="Buscar">
    </form>
</div>
<table>
    <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>Instructor</th>
        <th>Duración</th>
        <th>Editar</th>
        <th>Eliminar</th>
    </tr>
    <c:forEach items="${cursos}" var="c">
    <tr>
        <td>${c.id}</td>
        <td>${c.nombre}</td>
        <td>${c.instructor}</td>
        <td>${c.duracion}</td>
        <td><a href="${pageContext.request.contextPath}/cursos/form?id=${c.id}">Editar</a></td>
        <td><a onclick="return confirm('¿Está seguro que desea Eliminar?');"
        href="${pageContext.request.contextPath}/cursos/eliminar?id=${c.id}">Eliminar</a></td>
    </tr>
    </c:forEach>
</table>
</body>
</html>
