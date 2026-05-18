<%@page import="modelo.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Revisamos si ya hay una sesión activa para cambiar los botones del menú
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clínica Dental - Sonrisas Perfectas</title>
    <style>
        /* Estilos Base Estilo OdontoVer */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f8fafc;
            color: #334155;
        }

        /* Barra de Navegación */
        header {
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #0ea5e9; /* Azul dental brillante */
            text-decoration: none;
        }

        .nav-buttons .btn {
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s;
            margin-left: 10px;
        }

        .btn-login {
            color: #0ea5e9;
            border: 1px solid #0ea5e9;
        }

        .btn-login:hover {
            background-color: #f0f9ff;
        }

        .btn-register {
            background-color: #0ea5e9;
            color: white;
        }

        .btn-register:hover {
            background-color: #0284c7;
        }

        .btn-logout {
            background-color: #ef4444;
            color: white;
        }

        /* Sección Principal (Hero) */
        .hero {
            max-width: 1200px;
            margin: 0 auto;
            padding: 80px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 70vh;
        }

        .hero-content {
            max-width: 600px;
        }

        .hero-content h1 {
            font-size: 48px;
            color: #0f172a;
            line-height: 1.2;
            margin-bottom: 20px;
        }

        .hero-content p {
            font-size: 18px;
            color: #64748b;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        /* Sección de Servicios */
        .services-section {
            background-color: #ffffff;
            padding: 60px 20px;
        }

        .services-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .services-title {
            text-align: center;
            font-size: 32px;
            color: #0f172a;
            margin-bottom: 40px;
        }

        .grid-services {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .card {
            background: #f8fafc;
            padding: 30px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            text-align: center;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05);
        }

        .card h3 {
            color: #0f172a;
            margin-bottom: 12px;
            font-size: 20px;
        }

        .card p {
            color: #64748b;
            font-size: 15px;
            line-height: 1.5;
        }

        footer {
            background-color: #0f172a;
            color: #94a3b8;
            text-align: center;
            padding: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>

    <header>
        <div class="nav-container">
            <a href="index.jsp" class="logo">🦷 Clínica Dental PD</a>
            <div class="nav-buttons">
                <% if (user == null) { %>
                    <a href="login.jsp" class="btn btn-login">Iniciar Sesión</a>
                    <a href="registro.jsp" class="btn btn-register">Registrarse</a>
                <% } else { %>
                    <span style="margin-right: 15px; font-weight: 500;">Hola, <%= user.getEmail() %> (<%= user.getFkRol().getNombreRol() %>)</span>
                    <a href="LogoutServlet" class="btn btn-logout">Cerrar Sesión</a>
                <% } %>
            </div>
        </div>
    </header>

    <section class="hero">
        <div class="hero-content">
            <h1>Cuidamos de tu salud dental con la mejor tecnología</h1>
            <p>Experimenta una atención odontológica integral y personalizada. Diseñamos un plan de tratamiento exclusivo para recuperar el brillo y bienestar de tu sonrisa.</p>
            
            <div class="hero-actions">
                <% if (user == null) { %>
                    <a href="registro.jsp" class="btn btn-register" style="padding: 12px 24px; font-size: 16px; margin-left: 0;">Agendar mi Primera Cita</a>
                <% } else { %>
                    <p style="color: #0ea5e9; font-weight: bold; font-size: 18px;">✓ Ya estás listo para gestionar tus citas desde el sistema.</p>
                    <a href="dashboard_paciente.jsp" class="btn btn-register" style="padding: 12px 24px; font-size: 16px; margin-left: 0; background-color: #005088;">
                    <i class="fa-solid fa-columns"></i> Ir a mi Panel de Paciente
                </a>
                <% } %>
            </div>
        </div>
        
        <div style="width: 450px; height: 350px; background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%); border-radius: 20px; display: flex; align-items: center; justify-content: center; color: #0284c7; font-size: 80px;">
            ✨
        </div>
            
    </section>

    <section class="services-section">
        <div class="services-container">
            <h2 class="services-title">Nuestros Servicios Especializados</h2>
            <div class="grid-services">
                <div class="card">
                    <h3>Odontología General</h3>
                    <p>Limpiezas profundas, resinas y diagnósticos preventivos para mantener tu boca completamente sana.</p>
                </div>
                <div class="card">
                    <h3>Ortodoncia</h3>
                    <p>Alineación dental avanzada con brackets estéticos e invisibles para lograr la posición perfecta.</p>
                </div>
                <div class="card">
                    <h3>Endodoncia</h3>
                    <p>Tratamientos especializados para salvar tus piezas dentales eliminando el dolor desde la raíz.</p>
                </div>
            </div>
        </div>
    </section>

    <footer>
        <p>&copy; 2026 Clínica Dental PD. Inspirado en estándares de salud profesional. Veracruz, México.</p>
    </footer>

</body>
</html>