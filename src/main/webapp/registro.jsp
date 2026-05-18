<%-- 
    Document   : registro
    Created on : 17 may 2026, 12:08:58 p.m.
    Author     : jonyx
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Cuenta - Clínica Dental PD</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <%-- Reutilizamos los estilos del login para consistencia --%>
    <style>
        :root { --primary: #005088; --accent: #11CAA0; --bg: #f1f5f9; }
        body { margin: 0; font-family: 'Poppins', sans-serif; background-color: var(--bg); display: flex; justify-content: center; align-items: center; height: 100vh; }
        .card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; }
        h2 { color: var(--primary); margin-bottom: 10px; }
        .input-group { margin-bottom: 20px; text-align: left; position: relative; }
        .input-group i { position: absolute; left: 15px; top: 40px; color: #94a3b8; }
        .input-group label { display: block; margin-bottom: 8px; color: var(--primary); font-weight: 600; font-size: 14px; }
        .input-group input { width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #e2e8f0; border-radius: 10px; outline: none; box-sizing: border-box;}
        .input-group input:focus { border-color: var(--accent); }
        .btn-submit { background-color: var(--accent); color: white; border: none; width: 100%; padding: 14px; border-radius: 10px; font-weight: 600; cursor: pointer; transition: 0.3s; }
        .btn-submit:hover { background-color: #0da885; transform: translateY(-2px); }
        .alert-error { background: #fee2e2; color: #ef4444; border: 1px solid #fecaca; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; }
    </style>
</head>
<body>

<div class="card">
    <div style="font-size: 40px; color: var(--primary); margin-bottom: 15px;">🦷</div>
    <h2>Únete a nosotros</h2>
    <p style="color: #64748b; font-size: 14px; margin-bottom: 30px;">Crea tu cuenta de paciente en segundos.</p>

    <% if(request.getParameter("error") != null) { %>
        <div class="alert-error">
            <i class="fa-solid fa-triangle-exclamation"></i> El correo ya está registrado o hubo un problema.
        </div>
    <% } %>

    <form action="RegistroServlet" method="POST">
        <div class="input-group">
            <label>Correo Electrónico</label>
            <i class="fa-solid fa-envelope"></i>
            <input type="email" name="txtEmail" placeholder="tu@correo.com" required>
        </div>
        <div class="input-group">
            <label>Contraseña</label>
            <i class="fa-solid fa-lock"></i>
            <input type="password" name="txtPassword" placeholder="Crea una contraseña segura" required>
        </div>
        
        <button type="submit" class="btn-submit">Crear mi Cuenta</button>
    </form>

    <div style="margin-top: 25px; font-size: 14px; color: #64748b;">
        ¿Ya tienes cuenta? <a href="login.jsp" style="color: var(--primary); text-decoration: none; font-weight: 600;">Inicia Sesión</a>
    </div>
</div>

</body>
</html>
