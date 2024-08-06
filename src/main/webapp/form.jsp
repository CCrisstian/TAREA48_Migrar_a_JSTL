<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Formulario de Cursos</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<h1>Formulario de Cursos</h1>
<form action="${pageContext.request.contextPath}/cursos/form" method="post">
    <div>
        <label for="nombre">Nombre</label>
        <div>
            <input type="text" name="nombre" id="nombre" value="${curso.nombre != null? curso.nombre: ""}">
        </div>
        <c:if test="${errores != null && errores.containsKey('nombre')}">
            <div style="color:red;">${errores.nombre}</div>
        </c:if>
    </div>
    <div>
         <label for="descripcion">Descripción</label>
         <div>
            <textarea name="descripcion" rows="5" cols="50" id="descripcion">${curso.descripcion != null ? curso.descripcion : ""}</textarea>
        </div>
        <c:if test="${errores != null && errores.containsKey('descripcion')}">
            <div style="color:red;">${errores.descripcion}</div>
        </c:if>
    </div>
    <div>
         <label for="instructor">Instructor</label>
            <div>
                <input type="text" name="instructor" id="instructor" value="${curso.instructor != null? curso.instructor: ""}">
            </div>
        <c:if test="${errores != null && errores.containsKey('instructor')}">
            <div style="color:red;">${errores.instructor}</div>
        </c:if>
    </div>
    <div>
       <label for="duracion">Duración</label>
          <div>
            <input type="number" name="duracion" id="duracion" value="${curso.duracion != 0? curso.duracion: ""}">
          </div>
          <c:if test="${errores != null && errores.containsKey('duracion')}">
            <div style="color:red;">${errores.duracion}</div>
          </c:if>
    </div>
    <div><input type="submit" value="${curso.id > 0 ?"Editar":"Crear"}"></div>
    <input type="hidden" name="id" value="${curso.id}" >
</body>
</html>