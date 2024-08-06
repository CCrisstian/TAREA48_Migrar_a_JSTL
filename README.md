<h1 align="center">TAREA 48: Migrar tarea anterior (proyecto de cursos) a JSTL</h1>
<p>El objetivo de la tarea consiste en modificar (o tomar como base) la tarea anterior pero usando JSTL en las vistas.</p>
<p>Una vez terminada y probada la tarea deberán enviar el código fuente de todos los archivos involucrados, además de las imágenes screenshot (imprimir pantalla).</p>
<p>Subir sólo los archivos involucrados, que son los siguientes:</p>

- Vistas listar.jsp y form.jsp.
- Archivo pom.xml

<h1>Resolución del Profesor</h1>

- listar.jsp
```jsp
<%@page contentType="text/html" pageEncoding="UTF-8" import="java.time.format.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${titulo}</title>
    </head>
    <body>
        <h1>${titulo}</h1>
        <p><a href="${pageContext.request.contextPath}/cursos/form">crear [+]</a></p>
        <form action="${pageContext.request.contextPath}/cursos/buscar" method="post">
            <input type="text" name="nombre"><input type="submit" value="Buscar">
        </form>
        <table>
            <tr>
                <th>id</th>
                <th>nombre</th>
                <th>instructor</th>
                <th>duracion</th>
                <th>editar</th>
                <th>eliminar</th>
            </tr>
            <c:forEach items="${cursos}" var="c">
            <tr>
                <td>${c.id}</td>
                <td>${c.nombre}</td>
                <td>${c.instructor}</td>
                <td>${c.duracion}</td>
                <td><a href="${pageContext.request.contextPath}/cursos/form?id=${c.id}">editar</a></td>
                <td><a onclick="return confirm('esta seguro que desea eliminar?');"
                       href="${pageContext.request.contextPath}/cursos/eliminar?id=${c.id}">eliminar</a></td>
            </tr>
            </c:forEach>
        </table>
    </body>
</html>
```

- form.jsp:
```jsp
<%@page contentType="text/html" pageEncoding="UTF-8" import="java.time.format.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${titulo}</title>
    </head>
    <body>
        <h1>${titulo}</h1>
        <p><a href="${pageContext.request.contextPath}/cursos">volver</a></p>
        <form action="${pageContext.request.contextPath}/cursos/form" method="post">
            <div>
                <label for="nombre">Nombre</label>
                <div>
                    <input type="text" name="nombre" id="nombre" value="${curso.nombre}">
                </div>
                <c:if test="${errores != null && errores.containsKey('nombre')}">
                    <div style="color:red;">${errores.nombre}</div>
                </c:if>
            </div>
            <div>
                <label for="instructor">Instructor</label>
                <div>
                    <input type="text" name="instructor" id="instructor" value="${curso.instructor}">
                </div>
                <c:if test="${errores != null && errores.containsKey('instructor')}">
                    <div style="color:red;">${errores.instructor}</div>
                </c:if>
            </div>
            <div>
                <label for="duracion">Duracion</label>
                <div>
                    <input type="text" name="duracion" id="duracion" value="${curso.duracion != null && curso.duracion > 0? curso.duracion: ""}">
                </div>
                <c:if test="${errores != null && errores.containsKey('duracion')}">
                    <div style="color:red;">${errores.duracion}</div>
                </c:if>
            </div>
            <div>
                <label for="descripcion">Descripción</label>
                <div>
                    <textarea name="descripcion" id="descripcion">${curso.descripcion}</textarea>
                </div>
                <c:if test="${errores != null && errores.containsKey('descripcion')}">
                    <div style="color:red;">${errores.descripcion}</div>
                </c:if>
            </div>
            <div><input type="submit" value="${curso.id!=null && curso.id>0? "Editar": "Crear"}"></div>
            <input type="hidden" name="id" value="${curso.id}">
        </form>
    </body>
</html>
```

- pom.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>org.aguzman.apiservlet.webapp.jstl.tarea11</groupId>
    <artifactId>webapp-jstl-tarea11</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>
    <properties>
        <maven.compiler.source>16</maven.compiler.source>
        <maven.compiler.target>16</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>
    <dependencies>
        <dependency>
            <groupId>jakarta.platform</groupId>
            <artifactId>jakarta.jakartaee-api</artifactId>
            <version>9.0.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>jakarta.servlet.jsp.jstl</artifactId>
            <version>2.0.0</version>
        </dependency>
    </dependencies>
    <build>
        <finalName>${project.artifactId}</finalName>
        <plugins>
            <plugin>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
            </plugin>
            <plugin>
                <groupId>org.apache.tomcat.maven</groupId>
                <artifactId>tomcat7-maven-plugin</artifactId>
                <version>2.2</version>
                <configuration>
                    <url>http://localhost:8080/manager/text</url>
                    <username>admin</username>
                    <password>12345</password>
                </configuration>
            </plugin>
            <plugin>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.2.3</version>
                <configuration>
                    <failOnMissingWebXml>false</failOnMissingWebXml>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```
