<%-- 
    Document   : login
    Created on : 17 may 2026, 12:08:27 p.m.
    Author     : jonyx
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - Clínica Dental PD</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --primary: #005088;
            --accent: #11CAA0;
            --bg: #f1f5f9;
        }

        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        .login-card h2 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .login-card p {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 30px;
        }

        .input-group {
            margin-bottom: 20px;
            text-align: left;
            position: relative;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            top: 40px;
            color: #94a3b8;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--primary);
            font-weight: 600;
            font-size: 14px;
        }

        .input-group input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            outline: none;
            transition: 0.3s;
            box-sizing: border-box;
        }

        .input-group input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(17, 202, 160, 0.1);
        }

        .btn-submit {
            background-color: var(--primary);
            color: white;
            border: none;
            width: 100%;
            padding: 14px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background-color: #003d66;
            transform: translateY(-2px);
        }

        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
        }

        .alert-error { background: #fee2e2; color: #ef4444; border: 1px solid #fecaca; }
        .alert-success { background: #dcfce7; color: #22c55e; border: 1px solid #bbf7d0; }

        .footer-link {
            margin-top: 25px;
            font-size: 14px;
            color: #64748b;
        }

        .footer-link a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div style="font-size: 40px; color: var(--accent); margin-bottom: 15px;">🦷</div>
    <h2>Bienvenido</h2>
    <p>Ingresa tus credenciales para acceder a la clínica.</p>

    <%-- Mensajes de Error/Éxito --%>
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i> Correo o contraseña incorrectos.
        </div>
    <% } %>

    <% if("registrado".equals(request.getParameter("msj"))) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> ¡Registro exitoso! Ya puedes entrar.
        </div>
    <% } %>

    <form action="LoginServlet" method="POST">
        <div class="input-group">
            <label>Correo Electrónico</label>
            <i class="fa-solid fa-envelope"></i>
            <input type="email" name="txtEmail" placeholder="ejemplo@correo.com" required>
        </div>
        <div class="input-group">
            <label>Contraseña</label>
            <i class="fa-solid fa-lock"></i>
            <input type="password" name="txtPassword" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn-submit">Entrar al Sistema</button>
    </form>

    <div class="footer-link">
        ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
    </div>
</div>

</body>
</html>
