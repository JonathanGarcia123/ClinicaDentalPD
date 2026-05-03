<%-- 
    Document   : Login
    Created on : 3 may 2026, 4:09:53 p.m.
    Author     : jonyx
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Clínica Dental</title>
</head>
<body>
    <h2>Iniciar Sesión</h2>

    <%-- Mensajes de feedback --%>
    <% if("registrado".equals(request.getParameter("msj"))) { %>
        <p style="color: green;">¡Registro exitoso! Ahora puedes entrar.</p>
    <% } %>
    
    <% if(request.getParameter("error") != null) { %>
        <p style="color: red;">Credenciales incorrectas. Intenta de nuevo.</p>
    <% } %>

    <form action="LoginServlet" method="POST">
        <div>
            <label>Email:</label>
            <input type="email" name="txtEmail" required>
        </div>
        <div>
            <label>Contraseña:</label>
            <input type="password" name="txtPassword" required>
        </div>
        <button type="submit">Entrar</button>
    </form>
</body>
</html>
