<h1 align="center">Tarea 47: C.R.U.D. completo de los cursos</h1>

<p>Para este nuevo desafío se requiere modificar el proyecto de la tarea anterior (listado de cursos y búsqueda) para implementar el CRUD completo de los cursos, para crear, actualizar, eliminar y listar.</p>
<p>Una vez terminada y probada la tarea deberán enviar el código fuente de todos los archivos involucrados, además de las imágenes screenshot (imprimir pantalla).</p>
La tabla cursos la pueden crear a partir del siguiente esquema DDL:

```sql
CREATE TABLE `cursos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) DEFAULT NULL,
  `descripcion` varchar(120) DEFAULT NULL,
  `instructor` varchar(45) DEFAULT NULL,
  `duracion` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB
```

Con los datos de ejemplo

```sql
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Máster Completo en Java de cero a experto con IntelliJ', 'Aprende Java SE, Jakarta EE, Hibernate y mas', 'Andres Guzman', 98.53);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Spring Framework 5: Creando webapp de cero a experto', 'Construye aplicaciones web con Spring Framework 5 & Spring Boot', 'Andres Guzman', 41.51);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Angular & Spring Boot: Creando web app full stack', 'Desarrollo frontend con Angular y backend Spring Boot 2', 'Andres Guzman', 23.54);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Microservicios con Spring Boot y Spring Cloud Netflix Eureka', 'Construye Microservicios Spring Boot 2, Eureka, Spring Cloud', 'Andres Guzman', 19.55);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Guía Completa JUnit y Mockito incluye Spring Boot Test', 'Aprende desde cero JUnit 5 y Mockito en Spring Boot 2', 'Andres Guzman', 15.12);
```

<p>NO subir el proyecto completo, sólo los archivos involucrados, que son los siguientes:</p>

- Clase de acceso a datos CursoRepositorioImpl y su interface Repositorio.
- Clase de servicio CursoServiceImpl y su interface CursoService.
- Clases servlets CursoFormServlet y CursoEliminarServlet.
- Vistas listar.jsp y form.jsp.
  
<h1>Resolución del Profesor</h1>

- Clase CursoRepositorioImpl y su interface Repositorio:
```java
package org.aguzman.apiservlet.webapp.bbddcrud.tarea10.repositories;

import java.sql.SQLException;
import java.util.List;

public interface Repository<T> {

    List<T> listar() throws SQLException;

    List<T> porNombre(String nombre) throws SQLException;

    T porId(Long id) throws SQLException;

    void guardar(T t) throws SQLException;

    void eliminar(Long id) throws SQLException;
}
```

```java
package org.aguzman.apiservlet.webapp.bbddcrud.tarea10.repositories;

import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.models.Curso;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CursoRepositorioImpl implements Repository<Curso> {

    private Connection conn;

    public CursoRepositorioImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<Curso> listar() throws SQLException {
        List<Curso> cursos = new ArrayList<>();

        try ( Statement stmt = conn.createStatement();  ResultSet rs = stmt.executeQuery("SELECT * FROM cursos as c")) {
            while (rs.next()) {
                Curso p = getCurso(rs);
                cursos.add(p);
            }
        }
        return cursos;
    }

    @Override
    public List<Curso> porNombre(String nombre) throws SQLException {
        List<Curso> cursos = new ArrayList<>();

        try ( PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cursos as c WHERE c.nombre like ?")) {
            stmt.setString(1, "%" + nombre + "%");

            try ( ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cursos.add(getCurso(rs));
                }
            }
        }
        return cursos;
    }

    @Override
    public Curso porId(Long id) throws SQLException {
        Curso curso = null;
        try ( PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cursos as c WHERE c.id = ?")) {
            stmt.setLong(1, id);

            try ( ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    curso = getCurso(rs);
                }
            }
        }
        return curso;
    }

    @Override
    public void guardar(Curso curso) throws SQLException {
        String sql;
        if (curso.getId() != null && curso.getId() > 0) {
            sql = "update cursos set nombre=?, descripcion=?, instructor=?, duracion=? where id=?";
        } else {
            sql = "insert into cursos (nombre, descripcion, instructor, duracion) values (?,?,?,?)";
        }
        try ( PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, curso.getNombre());
            stmt.setString(2, curso.getDescripcion());
            stmt.setString(3, curso.getInstructor());
            stmt.setDouble(4, curso.getDuracion());

            if (curso.getId() != null && curso.getId() > 0) {
                stmt.setLong(5, curso.getId());
            }
            stmt.executeUpdate();
        }
    }

    @Override
    public void eliminar(Long id) throws SQLException {
        String sql = "delete from cursos where id=?";
        try ( PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }

    private Curso getCurso(ResultSet rs) throws SQLException {
        Curso c = new Curso();
        c.setId(rs.getLong("id"));
        c.setNombre(rs.getString("nombre"));
        c.setDescripcion(rs.getString("descripcion"));
        c.setInstructor(rs.getString("instructor"));
        c.setDuracion(rs.getDouble("duracion"));
        return c;
    }
}
```

- Clase servicio CursoServiceImpl y su interface CursoService:
```java
package org.aguzman.apiservlet.webapp.bbddcrud.tarea10.services;

import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.models.Curso;

import java.util.List;
import java.util.Optional;

public interface CursoService {

    List<Curso> listar();

    List<Curso> porNombre(String nombre);

    Optional<Curso> porId(Long id);

    void guardar(Curso curso);

    void eliminar(Long id);
}
```

```java
package org.aguzman.apiservlet.webapp.bbddcrud.tarea10.services;

import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.models.Curso;
import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.repositories.CursoRepositorioImpl;
import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.repositories.Repository;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class CursoServiceImpl implements CursoService{
    private Repository<Curso> repository;

    public CursoServiceImpl(Connection connection) {
        this.repository = new CursoRepositorioImpl(connection);
    }

    @Override
    public List<Curso> listar() {
        try {
            return repository.listar();
        } catch (SQLException e) {
            throw new ServiceJdbcException(e.getMessage(), e.getCause());
        }
    }

    @Override
    public List<Curso> porNombre(String nombre) {
        try {
            return repository.porNombre(nombre);
        } catch (SQLException e) {
            throw new ServiceJdbcException(e.getMessage(), e.getCause());
        }
    }

    @Override
    public Optional<Curso> porId(Long id) {
        try {
            return Optional.ofNullable(repository.porId(id));
        } catch (SQLException e) {
            throw new ServiceJdbcException(e.getMessage(), e.getCause());
        }
    }

    @Override
    public void guardar(Curso curso) {
        try {
            repository.guardar(curso);
        } catch (SQLException e) {
            throw new ServiceJdbcException(e.getMessage(), e.getCause());
        }
    }

    @Override
    public void eliminar(Long id) {
        try {
            repository.eliminar(id);
        } catch (SQLException e) {
            throw new ServiceJdbcException(e.getMessage(), e.getCause());
        }
    }

}
```

- Clases servlets CursoEliminarServlet y CursoFormServlet:
```java
package org.aguzman.apiservlet.webapp.bbddcrud.tarea10.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.Optional;
import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.models.Curso;
import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.services.*;

@WebServlet("/cursos/eliminar")
public class CursoEliminarServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Connection conn = (Connection) req.getAttribute("conn");
        CursoService service = new CursoServiceImpl(conn);
        long id;
        try {
            id = Long.parseLong(req.getParameter("id"));
        } catch (NumberFormatException e) {
            id = 0L;
        }
        if (id > 0) {
            Optional<Curso> o = service.porId(id);
            if (o.isPresent()) {
                service.eliminar(id);
                resp.sendRedirect(req.getContextPath()+ "/cursos");
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "No existe el cursos en la base de datos!");
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Error el id es null, se debe enviar como parametro en la url!");
        }
    }
}
```

```java
package org.aguzman.apiservlet.webapp.bbddcrud.tarea10.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.models.Curso;
import org.aguzman.apiservlet.webapp.bbddcrud.tarea10.services.*;

@WebServlet("/cursos/form")
public class CursoFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Connection conn = (Connection) req.getAttribute("conn");
        CursoService service = new CursoServiceImpl(conn);
        long id;
        try {
            id = Long.parseLong(req.getParameter("id"));
        } catch (NumberFormatException e) {
            id = 0L;
        }
        Curso curso = new Curso();
        if (id > 0) {
            Optional<Curso> o = service.porId(id);
            if (o.isPresent()) {
                curso = o.get();
            }
        }
        req.setAttribute("curso", curso);
        req.setAttribute("titulo", id > 0 ? "Tarea 10: Editar curso" : "Tarea 10: Crear curso");
        getServletContext().getRequestDispatcher("/form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Connection conn = (Connection) req.getAttribute("conn");
        CursoService service = new CursoServiceImpl(conn);
        String nombre = req.getParameter("nombre");
        String descripcion = req.getParameter("descripcion");
        String instructor = req.getParameter("instructor");

        double duracion;
        try {
            duracion = Double.parseDouble(req.getParameter("duracion"));
        } catch (NumberFormatException e) {
            duracion = 0;
        }

        Map<String, String> errores = new HashMap<>();
        if (nombre == null || nombre.isBlank()) {
            errores.put("nombre", "el nombre es requerido!");
        }
        if (descripcion == null || descripcion.isBlank()) {
            errores.put("descripcion", "la descripcion es requerida!");
        }

        if (instructor == null || instructor.isBlank()) {
            errores.put("instructor", "el instructor es requerido");
        }
        if (duracion == 0) {
            errores.put("duracion", "la duracion es requerida!");
        }

        long id;
        try {
            id = Long.parseLong(req.getParameter("id"));
        } catch (NumberFormatException e) {
            id = 0L;
        }
        Curso curso = new Curso();
        curso.setId(id);
        curso.setNombre(nombre);
        curso.setDescripcion(descripcion);
        curso.setInstructor(instructor);
        curso.setDuracion(duracion);

        if (errores.isEmpty()) {
            service.guardar(curso);
            resp.sendRedirect(req.getContextPath() + "/cursos");
        } else {
            req.setAttribute("errores", errores);
            req.setAttribute("curso", curso);
            req.setAttribute("titulo", id > 0 ? "Tarea 10: Editar curso" : "Tarea 10: Crear curso");
            getServletContext().getRequestDispatcher("/form.jsp").forward(req, resp);
        }
    }
}
```

Vistas listar.jsp y form.jsp:

```jsp
<%@page contentType="UTF-8" import="java.util.*, org.aguzman.apiservlet.webapp.bbddcrud.tarea10.models.*"%>
<%
List<Curso> cursos = (List<Curso>) request.getAttribute("cursos");
String titulo = (String) request.getAttribute("titulo");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title><%=titulo%></title>
    </head>
    <body>
        <h1><%=titulo%></h1>
        <p><a href="<%=request.getContextPath()%>/cursos/form">crear [+]</a></p>
        <form action="<%=request.getContextPath()%>/cursos/buscar" method="post">
            <input type="text" name="nombre">
            <input type="submit" value="Buscar">
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
            <% for(Curso c: cursos){%>
            <tr>
                <td><%=c.getId()%></td>
                <td><%=c.getNombre()%></td>
                <td><%=c.getInstructor()%></td>
                <td><%=c.getDuracion()%></td>
                <td><a href="<%=request.getContextPath()%>/cursos/form?id=<%=c.getId()%>">editar</a></td>
                <td><a onclick="return confirm('esta seguro que desea eliminar?');"
                       href="<%=request.getContextPath()%>/cursos/eliminar?id=<%=c.getId()%>">eliminar</a></td>
            </tr>
            <%}%>
        </table>
    </body>
</html>
```

```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"
        import="java.util.*,org.aguzman.apiservlet.webapp.bbddcrud.tarea10.models.*"%>
<%
Map<String, String> errores = (Map<String, String>) request.getAttribute("errores");
Curso curso = (Curso) request.getAttribute("curso");
String titulo = (String) request.getAttribute("titulo");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title><%=titulo%></title>
    </head>
    <body>
        <h1><%=titulo%></h1>
        <p><a href="<%=request.getContextPath()%>/cursos">volver</a></p>
        <form action="<%=request.getContextPath()%>/cursos/form" method="post">
            <div>
                <label for="nombre">Nombre</label>
                <div>
                    <input type="text" name="nombre" id="nombre" value="<%=curso.getNombre() != null? curso.getNombre(): ""%>">
                </div>
                <% if(errores != null && errores.containsKey("nombre")){%>
                <div style="color:red;"><%=errores.get("nombre")%></div>
                <% } %>
            </div>

            <div>
                <label for="instructor">Instructor</label>
                <div>
                    <input type="text" name="instructor" id="instructor" value="<%=curso.getInstructor()!= null? curso.getInstructor(): ""%>">
                </div>
                <% if(errores != null && errores.containsKey("instructor")){%>
                <div style="color:red;"><%=errores.get("instructor")%></div>
                <% } %>
            </div>

            <div>
                <label for="duracion">Duracion</label>
                <div>
                    <input type="text" name="duracion" id="duracion" value="<%=curso.getDuracion()!=null? curso.getDuracion():""%>">
                </div>
                <% if(errores != null && errores.containsKey("duracion")){%>
                <div style="color:red;"><%=errores.get("duracion")%></div>
                <% } %>
            </div>

            <div>
                <label for="descripcion">Descripción</label>
                <div>
                    <textarea name="descripcion" id="descripcion"><%=curso.getDescripcion()!=null? curso.getDescripcion():""%></textarea>
                </div>
                <% if(errores != null && errores.containsKey("descripcion")){%>
                <div style="color:red;"><%=errores.get("descripcion")%></div>
                <% } %>
            </div>


            <div><input type="submit" value="<%=(curso.getId()!=null && curso.getId()>0)? "Editar": "Crear"%>"></div>
            <input type="hidden" name="id" value="<%=curso.getId()%>">
        </form>
    </body>
</html>
```
