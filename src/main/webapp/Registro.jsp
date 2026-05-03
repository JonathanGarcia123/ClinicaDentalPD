<%-- 
    Document   : registro
    Created on : 3 may 2026, 4:09:20 p.m.
    Author     : jonyx
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Registro de Pacientes</title>
</head>
<body>
    <h2>Crear cuenta de Paciente</h2>
    
    <%-- Manejo de errores simple --%>
    <% if(request.getParameter("error") != null) { %>
        <p style="color: red;">Error: El correo ya existe o el rol no está configurado.</p>
    <% } %>

    <form action="RegistroServlet" method="POST">
        <div>
            <label>Correo Electrónico:</label>
            <input type="email" name="txtEmail" required>
        </div>
        <div>
            <label>Contraseña:</label>
            <input type="password" name="txtPassword" required>
        </div>
        <button type="submit">Registrarse</button>
    </form>
    
    <p>¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
</body>
</html>
