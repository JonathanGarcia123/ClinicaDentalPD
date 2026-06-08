<%-- 
    Document   : dashboard_paciente
    Created on : 17 may 2026, 5:29:06 p.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page import="modelo.Pacientes"%>
<%@page import="modelo.NombreCompleto"%>
<%-- NUEVOS IMPORTS PARA INTEGRAR LA AGENDA DE CITAS --%>
<%@page import="java.util.List"%>
<%@page import="modelo.Agenda"%>
<%@page import="datos.AgendaDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CONTROL DE ACCESO: Si no hay sesión o no es Paciente, lo botamos al login
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Paciente")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }

    // 2. EVITAR NULL POINTERS: Inicializamos variables locales vacías para los inputs
    String curp ="";
    String nombre = "";
    String apPat = "";
    String apMat = "";
    String telefono = "";
    String alergiasTexto= "";
    String nombreMostrar = user.getEmail(); // Por defecto saludamos con el correo

    // 3. MAPEO EN CASCADA: Extraemos los objetos modulares que nos compartiste
    Pacientes paciente = (Pacientes) session.getAttribute("pacienteLogueado");

    if (paciente != null) {
    
        if(paciente.getCurp()!= null){
            curp = paciente.getCurp();
        }
        
        if (paciente.getTelefono() != null) {
            telefono = paciente.getTelefono();
        }
        
        if (paciente.getAlergias() != null && !paciente.getAlergias().isEmpty()) {
            alergiasTexto = String.join(", ", paciente.getAlergias());
        }
        
        NombreCompleto nomComp = paciente.getNomCompP();
        if (nomComp != null) {
            nombre = (nomComp.getNombre() != null) ? nomComp.getNombre() : "";
            apPat = (nomComp.getApPat() != null) ? nomComp.getApPat() : "";
            apMat = (nomComp.getApMat() != null) ? nomComp.getApMat() : "";
            
            if (!nombre.isEmpty()) {
                nombreMostrar = nombre + " " + apPat;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Paciente - Clínica Dental PD</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Poppins', sans-serif; 
        }
        
        body { 
            background-color: #f1f5f9; 
            color: #1e293b; 
        }

        /* Navbar Estilo Profesional */
        .navbar {
            background-color: #005088;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        
        .navbar .logo { 
            font-size: 20px; 
            font-weight: 700; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }
        
        .navbar .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .btn-logout { 
            color: white; 
            background-color: #ef4444; 
            text-decoration: none; 
            padding: 8px 16px; 
            border-radius: 8px; 
            font-size: 14px; 
            font-weight: 600; 
            transition: 0.3s; 
        }
        
        .btn-logout:hover { 
            background-color: #dc2626; 
        }

        /* Contenedor y Bienvenida */
        .container { 
            max-width: 1200px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        
        .welcome-card { 
            background: linear-gradient(135deg, #005088 0%, #11CAA0 100%); 
            color: white; 
            padding: 30px; 
            border-radius: 16px; 
            margin-bottom: 30px; 
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05);
        }
        
        .welcome-card h1 { 
            font-size: 28px; 
            margin-bottom: 10px; 
        }

        /* Sistema de Pestañas (Tabs) */
        .tabs-nav { 
            display: flex; 
            gap: 10px; 
            margin-bottom: 25px; 
            border-bottom: 2px solid #e2e8f0; 
            padding-bottom: 10px; 
        }
        
        .tab-btn { 
            background: none; 
            border: none; 
            padding: 10px 20px; 
            font-size: 16px; 
            font-weight: 600; 
            color: #64748b; 
            cursor: pointer; 
            transition: 0.3s; 
            border-radius: 8px; 
        }
        
        .tab-btn:hover { 
            background-color: #e2e8f0; 
            color: #005088; 
        }
        
        .tab-btn.active { 
            background-color: #005088; 
            color: white; 
        }
        
        .tab-content { 
            display: none; 
        }
        
        .tab-content.active { 
            display: block; 
            animation: fadeIn 0.4s ease-in-out; 
        }
        
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(5px); } 
            to { opacity: 1; transform: translateY(0); } 
        }

        /* Tarjetas Estándar */
        .panel-card { 
            background: white; 
            padding: 25px; 
            border-radius: 16px; 
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); 
            border: 1px solid #e2e8f0; 
            margin-bottom: 30px; 
        }
        
        .panel-card h3 { 
            color: #005088; 
            margin-bottom: 20px; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }

        /* Layout de Citas (Grid dinámico) */
        .grid-citas { 
            display: grid; 
            grid-template-columns: 1fr 2fr; 
            gap: 30px; 
        }
        
        @media (max-width: 768px) { 
            .grid-citas { grid-template-columns: 1fr; } 
        }
        
        .btn-action { 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            gap: 10px; 
            background-color: #11CAA0; 
            color: white; 
            text-decoration: none; 
            padding: 15px; 
            border-radius: 10px; 
            font-weight: 600; 
            transition: 0.3s; 
            text-align: center;
        }
        
        .btn-action:hover { 
            background-color: #0da885; 
            transform: translateY(-2px); 
        }
        
        /* Tablas */
        table { 
            width: 100%; 
            border-collapse: collapse; 
            text-align: left; 
        }
        
        th { 
            background-color: #f8fafc; 
            color: #64748b; 
            padding: 12px; 
            font-size: 14px; 
            border-bottom: 2px solid #e2e8f0; 
        }
        
        td { 
            padding: 15px 12px; 
            border-bottom: 1px solid #e2e8f0; 
            font-size: 14px; 
        }

        /* Formulario de Perfil */
        .form-grid { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 20px; 
        }
        
        @media (max-width: 768px) { 
            .form-grid { grid-template-columns: 1fr; } 
        }
        
        .form-group { 
            display: flex; 
            flex-direction: column; 
            gap: 8px; 
        }
        
        .form-group label { 
            font-weight: 600; 
            color: #334155; 
            font-size: 14px; 
        }
        
        .form-group input { 
            width: 100%;
            padding: 12px; 
            border: 1px solid #e2e8f0; 
            border-radius: 10px; 
            outline: none; 
            transition: 0.3s; 
            box-sizing: border-box; 
        }
        
        .form-group input:focus { 
            border-color: #11CAA0; 
            box-shadow: 0 0 0 3px rgba(17, 202, 160, 0.1);
        }
        
        .form-group input[readonly] { 
            background-color: #f8fafc; 
            color: #94a3b8; 
            cursor: not-allowed; 
        }
        
        .btn-save { 
            background-color: #005088; 
            color: white; 
            border: none; 
            padding: 14px 28px; 
            border-radius: 10px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: 0.3s; 
            margin-top: 10px; 
        }
        
        .btn-save:hover { 
            background-color: #003d66; 
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo"><i class="fa-solid fa-tooth"></i> Clínica Dental PD</div>
        <div class="user-info">
            <span><i class="fa-solid fa-user-circle"></i> <%= user.getEmail() %></span>
            <a href="LogoutServlet" class="btn-logout">Cerrar Sesión</a>
        </div>
    </div>

    <div class="container">
        
        <div class="welcome-card">
            <h1>¡Hola, <%= nombreMostrar %>!</h1>
            <p>Bienvenido a tu portal de salud dental. Selecciona una opción para comenzar.</p>
        </div>

        <div class="tabs-nav">
            <button class="tab-btn active" onclick="switchTab(event, 'tab-citas')"><i class="fa-solid fa-calendar-days"></i> Mis Citas</button>
            <button class="tab-btn" onclick="switchTab(event, 'tab-historial')"><i class="fa-solid fa-file-medical"></i> Historial Clínico</button>
            <button class="tab-btn" onclick="switchTab(event, 'tab-perfil')"><i class="fa-solid fa-user-gear"></i> Mi Perfil</button>
        </div>

        <div id="tab-citas" class="tab-content active">
            <div class="grid-citas">
                <div class="panel-card">
                    <h3><i class="fa-solid fa-calendar-plus"></i> Reservaciones</h3>
                    <p style="color: #64748b; font-size: 14px; margin-bottom: 20px;">¿Te toca revisión? Asegura tu lugar con nuestros médicos dentistas.</p>
                    <a href="agendar_cita.jsp" class="btn-action"><i class="fa-solid fa-clock"></i> Agendar Nueva Cita</a>
                </div>
                
                <div class="panel-card">
                    <h3><i class="fa-solid fa-calendar-check"></i> Próximas Visitas</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Especialidad / Médico</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                AgendaDAO aDAO = new AgendaDAO();
                                List<Agenda> listaCitas = aDAO.obtenerPorPaciente(user.getEmail());

                                if (listaCitas == null || listaCitas.isEmpty()) {
                            %>
                                <tr>
                                    <td>-- / -- / ----</td>
                                    <td>-- : --</td>
                                    <td>No hay citas activas</td>
                                    <td><span style="color:#64748b;">Pendiente</span></td>
                                </tr>
                            <%
                                } else {
                                    SimpleDateFormat sdfVisual = new SimpleDateFormat("dd/MM/yyyy");
                                    for (Agenda cita : listaCitas) {
                                        String fechaCitaStr = (cita.getFecha() != null) ? sdfVisual.format(cita.getFecha()) : "N/A";

                                        String doctorAsignado = "Por asignar";
                                        if (cita.getFkDoctor() != null && cita.getFkDoctor().getNomCompD() != null) {
                                            doctorAsignado = "Dr(a). " + cita.getFkDoctor().getNomCompD().getNombre() + " " + 
                                                             cita.getFkDoctor().getNomCompD().getApPat();
                                        }

                                        boolean esActiva = "Activo".equalsIgnoreCase(cita.getStatus());
                            %>
                                <tr>
                                    <td><strong><%= fechaCitaStr %></strong></td>
                                    <td><%= cita.getHora() %></td>
                                    <td>
                                        <%= cita.getMotivo() %><br>
                                        <small style="color: #64748b;"><%= doctorAsignado %></small>
                                    </td>
                                    <td>
                                        <% if (esActiva) { %>
                                            <form action="CancelarCitaServlet" method="POST" style="margin: 0;">
                                                <input type="hidden" name="txtIdCita" value="<%= cita.getIdAgenda().toHexString() %>">

                                                <select name="cmbStatusCita" onchange="if(confirm('¿Seguro que deseas cancelar esta cita médica?')) this.form.submit(); else this.value='Activo';" 
                                                        style="padding: 6px 10px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 13px; font-weight: 600; color: #0369a1; background-color: #f0fdf4; cursor: pointer; width: auto;">
                                                    <option value="Activo" selected>🟢 Activa / Agendada</option>
                                                    <option value="Cancelado">🔴 Cancelar Cita</option>
                                                </select>
                                            </form>
                                        <% } else { %>
                                            <span style="font-weight: 700; color: #ef4444;"><i class="fa-solid fa-circle-xmark"></i> Cancelada</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div id="tab-historial" class="tab-content">
            <div class="panel-card">
                <h3><i class="fa-solid fa-notes-medical"></i> Expediente Clínico General</h3>
                <p style="color: #64748b; font-size: 14px; margin-bottom: 20px;"><i class="fa-solid fa-lock"></i> Este documento es de solo lectura. Solo el médico asignado puede realizar modificaciones de diagnóstico.</p>
                <table>
                    <thead>
                        <tr><th>Fecha Consulta</th><th>Doctor</th><th>Diagnóstico / Observaciones</th><th>Tratamiento Recetado</th></tr>
                    </thead>
                    <tbody>
                        <tr><td>15/05/2026</td><td>Dr. Alejandro Olvera</td><td>Diagnóstico inicial, presencia de caries leves en molares inferiores.</td><td>Limpieza profunda y resinas.</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="tab-perfil" class="tab-content">
            <div class="panel-card">
                <h3><i class="fa-solid fa-id-card"></i> Actualizar Mis Datos Personales</h3>
                
                <form action="ActualizarPerfilServlet" method="POST">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>CURP</label>
                            <input type="text" name="txtCurp" value="<%= curp %>" placeholder="Ingresa tu CURP" required> 
                        </div>
                        <div class="form-group">
                            <label>Nombre(s)</label>
                            <input type="text" name="txtNombre" value="<%= nombre %>" placeholder="Ingresa tu nombre" required>
                        </div>
                        <div class="form-grid" style="gap:20px; padding:0;">
                            <div class="form-group">
                                <label>Apellido Paterno</label>
                                <input type="text" name="txtApePaterno" value="<%= apPat %>" placeholder="Apellido Paterno" required>
                            </div>
                            <div class="form-group">
                                <label>Apellido Materno</label>
                                <input type="text" name="txtApeMaterno" value="<%= apMat %>" placeholder="Apellido Materno">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Número de Celular</label>
                            <input type="tel" name="txtTelefono" value="<%= telefono %>" placeholder="Ej: 2291234567" required>
                        </div>
                        <div class="form-group" style="grid-column: span 2;">
                            <label>Correo Electrónico</label>
                            <input type="email" name="txtEmail" value="<%= user.getEmail() %>" readonly>
                        </div>
                        <div class="form-group" style="grid-column: span 2;">
                            <label> Alergias Médicas / Restricciones</label>
                            <input type="text" name="txtAlergias" value="<%= alergiasTexto %>" placeholder="Ej: Penicilina, Látex, Ibuprofeno (Si no tienes pon 'Ninguna')">
                        </div>
                    </div>
                    <button type="submit" class="btn-save"><i class="fa-solid fa-floppy-disk"></i> Guardar Cambios</button>
                </form>
            </div>
        </div>

    </div>

    <script>
        function switchTab(evt, tabId) {
            const tabContents = document.getElementsByClassName("tab-content");
            for (let i = 0; i < tabContents.length; i++) {
                tabContents[i].classList.remove("active");
            }

            const tabBtns = document.getElementsByClassName("tab-btn");
            for (let i = 0; i < tabBtns.length; i++) {
                tabBtns[i].classList.remove("active");
            }

            document.getElementById(tabId).classList.add("active");
            evt.currentTarget.classList.add("active");
        }
    </script>
</body>
</html>