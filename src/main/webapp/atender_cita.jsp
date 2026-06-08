<%-- 
    Document   : atender_cita
    Created on : 8 jun 2026, 11:48:57 a.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page import="modelo.Agenda"%>
<%@page import="datos.AgendaDAO"%>
<%@page import="modelo.Pacientes"%>
<%@page import="modelo.Tratamientos"%>
<%@page import="datos.TratamientoDAO"%>
<%@page import="java.util.List"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CONTROL DE ACCESO
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Doctor")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }

    // 2. RECUPERAR LA CITA DE MONGODB
    String idCitaStr = request.getParameter("idCita");
    Agenda cita = null;
    
    if (idCitaStr != null && !idCitaStr.trim().isEmpty()) {
        try {
            AgendaDAO aDAO = new AgendaDAO();
            // Buscamos la cita por su ObjectId real
            cita = aDAO.buscarPorId(new ObjectId(idCitaStr));
        } catch (Exception e) {
            System.err.println("Error al recuperar la cita en el JSP: " + e.getMessage());
        }
    }

    if (cita == null) {
        response.sendRedirect("dashboard_doctor.jsp?status=citaNotFound");
        return;
    }

    // Extraemos el paciente embebido dentro de la cita de forma segura
    Pacientes paciente = cita.getFkPaciente();
    String nombrePac = paciente.getNomCompP().getNombre() + " " + paciente.getNomCompP().getApPat();
    String alergias = (paciente.getAlergias() != null && !paciente.getAlergias().isEmpty()) 
                      ? String.join(", ", paciente.getAlergias()) : "Ninguna registrada";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atención Clínica - Clínica Dental PD</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; }

        .navbar {
            background-color: #0f172a; color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        .navbar .logo { font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .btn-back { color: white; text-decoration: none; background-color: rgba(255, 255, 255, 0.1); padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; transition: 0.3s; }
        .btn-back:hover { background-color: rgba(255, 255, 255, 0.2); }

        .container { max-width: 850px; margin: 30px auto; padding: 0 20px; }
        
        .panel-card { background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 25px; }
        .panel-card h3 { color: #0f172a; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-size: 18px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-weight: 600; font-size: 13px; color: #475569; }
        .form-group input, .form-group textarea, .form-group select { padding: 12px; border: 1px solid #cbd5e1; border-radius: 10px; outline: none; font-size: 14px; width: 100%; box-sizing: border-box; }
        .form-group input[readonly], .form-group textarea[readonly] { background-color: #f8fafc; color: #64748b; cursor: not-allowed; }
        
        /* Alerta de Alergias Crítica */
        .alergias-box { background-color: #fff1f2; border: 1px solid #fecdd3; color: #9f1239; padding: 15px; border-radius: 10px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }

        .btn-submit { background-color: #10b981; color: white; border: none; padding: 14px 28px; border-radius: 10px; font-weight: 600; cursor: pointer; transition: 0.3s; width: 100%; font-size: 16px; display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-submit:hover { background-color: #059669; }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo"><i class="fa-solid fa-stethoscope"></i> Consulta Clínica General</div>
        <a href="dashboard_doctor.jsp" class="btn-back"><i class="fa-solid fa-arrow-left"></i> Salir de Consulta</a>
    </div>

    <div class="container">
        
        <div class="panel-card">
            <h3><i class="fa-solid fa-id-card"></i> Ficha de Identificación del Paciente</h3>
            
            <% if(paciente.getAlergias() != null && !paciente.getAlergias().isEmpty()) { %>
                <div class="alergias-box">
                    <i class="fa-solid fa-triangle-exclamation" style="font-size: 20px;"></i>
                    <span>ALERGIAS DETECTADAS: <%= alergias %></span>
                </div>
            <% } %>

            <div class="form-grid">
                <div class="form-group">
                    <label>Nombre Completo</label>
                    <input type="text" value="<%= nombrePac %>" readonly>
                </div>
                <div class="form-group">
                    <label>CURP</label>
                    <input type="text" value="<%= paciente.getCurp() %>" readonly>
                </div>
                <div class="form-group">
                    <label>Número de Contacto</label>
                    <input type="text" value="<%= paciente.getTelefono() %>" readonly>
                </div>
                <div class="form-group">
                    <label>Correo de Cuenta</label>
                    <input type="text" value="<%= paciente.getEmail() %>" readonly>
                </div>
            </div>
        </div>

        <div class="panel-card">
            <h3><i class="fa-solid fa-file-signature"></i> Registro de Diagnóstico y Evolución</h3>
            
            <form action="GuardarHistorialServlet" method="POST">
                <input type="hidden" name="txtIdCita" value="<%= idCitaStr %>">
                <input type="hidden" name="txtEmailPaciente" value="<%= paciente.getEmail() %>">
                
                <div class="form-grid">
                    
                    <div class="form-group" style="grid-column: span 2;">
                        <label>Servicio Clínico Aplicado / Tratamiento</label>
                        <select name="cmbTratamientoAplicado" required>
                            <option value="" disabled selected>-- Selecciona el procedimiento realizado --</option>
                            <%
                                TratamientoDAO tDAO = new TratamientoDAO();
                                List<Tratamientos> listaServicios = tDAO.obtenerTodos();
                                if (listaServicios != null) {
                                    for (Tratamientos serv : listaServicios) {
                                        // Filtramos dinámicamente para mostrar solo tratamientos, no medicinas
                                        if (serv.getFechaCaducidad() == null) {
                            %>
                                            <option value="<%= serv.getCodProducto() %>" <%= cita.getMotivo().equalsIgnoreCase(serv.getNombre()) ? "selected" : "" %>>
                                                <%= serv.getNombre() %> (Costo base: $<%= serv.getPrecioBase() %>)
                                            </option>
                            <%
                                        }
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label>Observaciones Clínicas / Notas de Diagnóstico</label>
                        <textarea name="txtObservaciones" rows="5" placeholder="Escribe el estado del paciente, anomalías detectadas y el trabajo realizado en el sillón dental..." required></textarea>
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label>Receta Médica / Medicamentos Enviados a Casa</label>
                        <textarea name="txtMedicamentos" rows="3" placeholder="Ej: Ibuprofeno 400mg - Tomar 1 tableta cada 8 horas por 3 días si presenta inflamación..."></textarea>
                    </div>

                </div>
                
                <button type="submit" class="btn-submit" style="margin-top: 25px;">
                    <i class="fa-solid fa-notes-medical"></i> Concluir Consulta y Guardar Historial
                </button>
            </form>
        </div>

    </div>

</body>
</html>