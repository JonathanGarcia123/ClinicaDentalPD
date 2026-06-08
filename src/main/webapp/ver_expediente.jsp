<%-- 
    Document   : ver_expediente
    Created on : 8 jun 2026, 12:52:23 p.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page import="modelo.Pacientes"%>
<%@page import="datos.PacientesDAO"%>
<%@page import="modelo.Historial"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CONTROL DE ACCESO: Solo el Administrador puede auditar expedientes globales
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }

    // 2. RECUPERAR PARÁMETRO Y BUSCAR AL PACIENTE EN MONGO
    String emailParam = request.getParameter("email");
    Pacientes paciente = null;

    if (emailParam != null && !emailParam.trim().isEmpty()) {
        try {
            PacientesDAO pDAO = new PacientesDAO();
            
            // ¡Listo! Usamos tu función nativa sin inventar métodos nuevos
            paciente = pDAO.buscarPorEmail(emailParam.trim());
            
        } catch (Exception e) {
            System.err.println("Error al recuperar expediente en el JSP: " + e.getMessage());
        }
    }

    // Si el paciente no existe o la CURP es inválida, regresamos al panel con alerta
    if (paciente == null) {
        response.sendRedirect("dashboard_admin.jsp?status=patientNotFound");
        return;
    }

    // Mapeo seguro de datos personales
    String nombreCompleto = paciente.getNomCompP().getNombre() + " " + 
                           paciente.getNomCompP().getApPat() + " " + 
                           (paciente.getNomCompP().getApMat() != null ? paciente.getNomCompP().getApMat() : "");
    
    String alergiasTexto = (paciente.getAlergias() != null && !paciente.getAlergias().isEmpty()) 
                           ? String.join(", ", paciente.getAlergias()) : "Ninguna registrada";
                           
    List<Historial> listaHistorial = paciente.getHistorialClinico();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expediente Clínico: <%= paciente.getNomCompP().getNombre() %> - Clínica PD</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; }

        /* Navbar estilo Administrador */
        .navbar {
            background-color: #0f172a; color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        .navbar .logo { font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .btn-back { color: white; text-decoration: none; background-color: rgba(255, 255, 255, 0.1); padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; transition: 0.3s; }
        .btn-back:hover { background-color: rgba(255, 255, 255, 0.2); }

        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        
        /* Tarjetas de Información */
        .panel-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 25px; }
        .panel-card h3 { color: #0f172a; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-size: 18px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; }
        
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-weight: 600; font-size: 13px; color: #64748b; }
        .form-group input { padding: 12px; border: 1px solid #cbd5e1; border-radius: 10px; font-size: 14px; background-color: #f8fafc; color: #334155; cursor: not-allowed; outline: none; width: 100%; }

        /* Caja de Alergias */
        .alergias-badge { background-color: #fff1f2; border: 1px solid #fecdd3; color: #9f1239; padding: 12px 20px; border-radius: 10px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-size: 14px; }

        /* Tabla de historial de consultas */
        .table-responsive { width: 100%; overflow-x: auto; margin-top: 15px; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background-color: #f8fafc; color: #64748b; padding: 12px; font-size: 14px; border-bottom: 2px solid #e2e8f0; }
        td { padding: 15px 12px; border-bottom: 1px solid #e2e8f0; font-size: 14px; }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo"><i class="fa-solid fa-folder-open"></i> Auditoría de Expediente Clínico</div>
        <a href="dashboard_admin.jsp" class="btn-back"><i class="fa-solid fa-arrow-left"></i> Volver al Panel</a>
    </div>

    <div class="container">
        
        <div class="panel-card">
            <h3><i class="fa-solid fa-address-card"></i> Ficha de Identificación</h3>
            
            <% if(paciente.getAlergias() != null && !paciente.getAlergias().isEmpty()) { %>
                <div class="alergias-badge">
                    <i class="fa-solid fa-triangle-exclamation" style="font-size: 18px;"></i>
                    <span>Restricciones de Alergia: <%= alergiasTexto %></span>
                </div>
            <% } %>

            <div class="form-grid">
                <div class="form-group">
                    <label>Nombre del Paciente</label>
                    <input type="text" value="<%= nombreCompleto %>" readonly>
                </div>
                <div class="form-group">
                    <label>CURP</label>
                    <input type="text" value="<%= paciente.getCurp() %>" readonly>
                </div>
                <div class="form-group">
                    <label>Teléfono de Contacto</label>
                    <input type="text" value="<%= paciente.getTelefono() %>" readonly>
                </div>
                <div class="form-group">
                    <label>Correo Electrónico Asociado</label>
                    <input type="text" value="<%= paciente.getEmail() %>" readonly>
                </div>
            </div>
        </div>

        <div class="panel-card">
            <h3><i class="fa-solid fa-clock-rotate-left"></i> Historial Clínico de Evolución y Diagnósticos</h3>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Fecha Consulta</th>
                            <th>Servicio / Tratamiento</th>
                            <th>Dentista Tratante</th>
                            <th>Diagnóstico / Observaciones</th>
                            <th>Tratamiento Recetado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (listaHistorial == null || listaHistorial.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="5" style="text-align: center; color: #64748b; padding: 30px;">El paciente aún no cuenta con consultas concluidas registradas en su expediente.</td>
                            </tr>
                        <%
                            } else {
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
                                // Bucle descendente: Muestra la última intervención médica hasta arriba
                                for (int i = listaHistorial.size() - 1; i >= 0; i--) {
                                    Historial nota = listaHistorial.get(i);
                                    String fechaFormateada = (nota.getFechaAplicacion() != null) ? sdf.format(nota.getFechaAplicacion()) : 
                                                            (nota.getFechaAplicacion() != null ? sdf.format(nota.getFechaAplicacion()) : "N/A");
                                                            
                                    String tratamientoNom = (nota.getTratamiento() != null) ? nota.getTratamiento().getNombre() : "Servicio General";
                        %>
                            <tr>
                                <td><strong><%= fechaFormateada %></strong></td>
                                <td>
                                    <span style="background-color: #e0f2fe; color: #0369a1; padding: 4px 10px; border-radius: 20px; font-weight: 600; font-size: 12px; display: inline-block;">
                                        <%= tratamientoNom %>
                                    </span>
                                </td>
                                <td><%= nota.getNombreMedico() %></td>
                                <td style="color: #475569; max-width: 350px;"><%= nota.getObservaciones() %></td>
                                <td>
                                    <% if (nota.getMedicamentosRecetados() != null && !nota.getMedicamentosRecetados().trim().isEmpty()) { %>
                                        <span style="font-size: 13px; font-style: italic; color: #0369a1;">
                                            <i class="fa-solid fa-pills"></i> <%= nota.getMedicamentosRecetados() %>
                                        </span>
                                    <% } else { %>
                                        <span style="color: #94a3b8; font-size: 13px;">Ninguno recetado</span>
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