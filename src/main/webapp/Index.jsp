<%-- 
    Document   : Index
    Created on : 3 may 2026, 4:10:29 p.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificamos si hay un usuario en la "mochila" de la sesión
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return; // Detenemos la carga de la página
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Panel de Control - Clínica Dental</title>
</head>
<body>
    <h1>Bienvenido, <%= user.getEmail() %></h1>
    <p>Tu rol actual es: <strong><%= user.getFkRol().getNombreRol() %></strong></p>

    <nav>
        <ul>
            <%-- Lógica de menú según el ROL --%>
            <% if(user.getFkRol().getNombreRol().equals("Admin")) { %>
                <li><a href="gestionDoctores.jsp">Gestionar Doctores</a></li>
                <li><a href="reportes.jsp">Ver Reportes Globales</a></li>
            <% } %>

            <% if(user.getFkRol().getNombreRol().equals("Paciente")) { %>
                <li><a href="misCitas.jsp">Agendar Cita</a></li>
                <li><a href="miHistorial.jsp">Ver mi Historial</a></li>
            <% } %>
            
            <li><a href="LogoutServlet">Cerrar Sesión</a></li>
        </ul>
    </nav>
</body>
</html>
