<%-- 
    Document   : dashboard_doctor
    Created on : 8 jun 2026, 11:01:21 a.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page import="modelo.Agenda"%>
<%@page import="datos.AgendaDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CONTROL DE ACCESO: Validar que el usuario haya iniciado sesión y sea un Doctor
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Doctor")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }

    // 2. OBTENER LAS CITAS: Usamos el correo del doctor logueado con tu función del DAO
    AgendaDAO agendaDAO = new AgendaDAO();
    List<Agenda> listaCitas = agendaDAO.obtenerPorDoctor(user.getEmail());
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Médico - Clínica Dental PD</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; }

        /* Navbar */
        .navbar {
            background-color: #0f172a;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        .navbar .logo { font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .btn-logout { color: white; background-color: #ef4444; text-decoration: none; padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; transition: 0.3s; }
        .btn-logout:hover { background-color: #dc2626; }

        /* Contenedor Principal */
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        
        .welcome-card { 
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); 
            color: white; padding: 25px 30px; border-radius: 16px; margin-bottom: 30px; 
        }

        .panel-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
        .panel-card h3 { color: #0f172a; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }

        /* Tablas */
        .table-responsive { width: 100%; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background-color: #f8fafc; color: #64748b; padding: 12px; font-size: 14px; border-bottom: 2px solid #e2e8f0; }
        td { padding: 15px 12px; border-bottom: 1px solid #e2e8f0; font-size: 14px; }
        
        /* Badges */
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge.active { background-color: #dcfce7; color: #15803d; }
        .badge.inactive { background-color: #fee2e2; color: #b91c1c; }

        .btn-table { padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 5px; }
        .btn-view { background-color: #e0f2fe; color: #0369a1; }
        .btn-view:hover { background-color: #bae6fd; }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo"><i class="fa-solid fa-user-doctor"></i> Portal Médico - Clínica PD</div>
        <div style="display: flex; align-items: center; gap: 20px;">
            <span><i class="fa-solid fa-circle-user"></i> <%= user.getEmail() %></span>
            <a href="LogoutServlet" class="btn-logout">Cerrar Sesión</a>
        </div>
    </div>

    <div class="container">
        <div class="welcome-card">
            <h1>Panel de Control de Consultas</h1>
            <p>Monitoreo de citas asignadas para hoy y control de expedientes clínicos de pacientes.</p>
        </div>

        <div class="panel-card">
            <h3><i class="fa-solid fa-calendar-list"></i> Próximos Pacientes Programados</h3>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Paciente</th>
                            <th>Tratamiento / Servicio</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (listaCitas == null || listaCitas.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: #64748b; padding: 30px;">No tienes pacientes programados en tu agenda por el momento.</td>
                            </tr>
                        <%
                            } else {
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                for (Agenda cita : listaCitas) {
                                    String fechaStr = (cita.getFecha() != null) ? sdf.format(cita.getFecha()) : "N/A";
                                    
                                    // Extraemos el nombre completo del paciente embebido de forma segura
                                    String nombrePaciente = "Datos incompletos";
                                    if (cita.getFkPaciente() != null && cita.getFkPaciente().getNomCompP() != null) {
                                        nombrePaciente = cita.getFkPaciente().getNomCompP().getNombre() + " " + 
                                                         cita.getFkPaciente().getNomCompP().getApPat();
                                    }
                                    
                                    boolean esActiva = "Activo".equalsIgnoreCase(cita.getStatus());
                        %>
                            <tr>
                                <td><strong><%= fechaStr %></strong></td>
                                <td><%= cita.getHora() %></td>
                                <td><%= nombrePaciente %></td>
                                <td><%= cita.getMotivo() %></td>
                                <td>
                                    <% if ("Activo".equalsIgnoreCase(cita.getStatus())) { %>
                                        <span class="badge active">Activa</span>
                                    <% } else if ("Finalizado".equalsIgnoreCase(cita.getStatus())) { %>
                                        <span class="badge" style="background-color: #e0f2fe; color: #0369a1;">Finalizada</span>
                                    <% } else { %>
                                        <span class="badge inactive">Cancelada</span>
                                    <% } %>
                                </td>

                                <td>
                                    <% if ("Activo".equalsIgnoreCase(cita.getStatus())) { %>
                                        <a href="atender_cita.jsp?idCita=<%= cita.getIdAgenda().toHexString() %>" class="btn-table btn-view" style="background-color: #f0fdf4; color: #16a34a;">
                                            <i class="fa-solid fa-notes-medical"></i> Atender Cita
                                        </a>
                                    <% } else if ("Finalizado".equalsIgnoreCase(cita.getStatus())) { %>
                                        <span style="color: #10b981; font-weight: 600;"><i class="fa-solid fa-circle-check"></i> Atendida con éxito</span>
                                    <% } else { %>
                                        <button class="btn-table" style="background-color: #f1f5f9; color: #94a3b8; cursor: not-allowed;" disabled>No disponible</button>
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

</body>
</html>