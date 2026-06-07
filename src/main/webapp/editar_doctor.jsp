<%-- 
    Document   : editar_doctor
    Created on : 6 jun 2026, 5:40:00 p.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page import="modelo.Doctores"%>
<%@page import="modelo.NombreCompleto"%>
<%@page import="modelo.HorarioDoctor"%>
<%@page import="datos.DoctoresDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CONTROL DE ACCESO: Solo el Administrador puede editar perfiles médicos
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }

    // 2. CAPTURAR LA CÉDULA DE LA URL Y BUSCAR AL DOCTOR
    String cedulaParam = request.getParameter("cedula");
    Doctores doctor = null;
    
    if (cedulaParam != null && !cedulaParam.trim().isEmpty()) {
        try {
            int cedulaInt = Integer.parseInt(cedulaParam);
            DoctoresDAO dDAO = new DoctoresDAO();
            doctor = dDAO.buscarPorCedula(cedulaInt);
        } catch (NumberFormatException e) {
            System.err.println("Error al parsear la cédula en el JSP: " + e.getMessage());
        }
    }

    // Si la cédula no existe o no se encontró al doctor, lo regresamos al panel
    if (doctor == null) {
        response.sendRedirect("dashboard_admin.jsp?status=docNotFound");
        return;
    }

    // 3. EXTRAER VARIABLES PARA LOS INPUTS (Evitar NullPointers)
    NombreCompleto nc = doctor.getNomCompD();
    String nombre = (nc != null && nc.getNombre() != null) ? nc.getNombre() : "";
    String apPat = (nc != null && nc.getApPat() != null) ? nc.getApPat() : "";
    String apMat = (nc != null && nc.getApMat() != null) ? nc.getApMat() : "";
    
    HorarioDoctor hd = doctor.getHorarioDisp();
    String dias = (hd != null && hd.getDia() != null) ? hd.getDia() : "";
    String hEntrada = (hd != null && hd.getHoraInicio()!= null) ? hd.getHoraInicio(): "";
    String hSalida = (hd != null && hd.getHoraSalida() != null) ? hd.getHoraSalida() : "";
    
    String especialidad = (doctor.getEspecialidad() != null) ? doctor.getEspecialidad() : "";
    String telefono = (doctor.getTelefono() != null) ? doctor.getTelefono() : "";
    boolean estaActivo = (doctor.getActivo() != null) ? doctor.getActivo() : true;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Médico - Clínica Dental PD</title>
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
        .btn-back { color: white; text-decoration: none; background-color: rgba(255, 255, 255, 0.1); padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; transition: 0.3s; }
        .btn-back:hover { background-color: rgba(255, 255, 255, 0.2); }

        /* Formulario contenedor */
        .container { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .form-card { background: white; padding: 30px; border-radius: 16px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
        .form-card h2 { color: #0f172a; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; font-size: 22px; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        @media (max-width: 576px) { .form-grid { grid-template-columns: 1fr; } }
        
        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group label { font-weight: 600; color: #334155; font-size: 14px; }
        .form-group input, .form-group select { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 10px; outline: none; transition: 0.3s; font-size: 14px; box-sizing: border-box; }
        .form-group input:focus, .form-group select:focus { border-color: #0f172a; box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.08); }
        .form-group input[readonly] { background-color: #f8fafc; color: #94a3b8; cursor: not-allowed; }

        .btn-save { background-color: #0f172a; color: white; border: none; padding: 14px 28px; border-radius: 10px; font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 15px; width: 100%; font-size: 16px; display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-save:hover { background-color: #1e293b; transform: translateY(-1px); }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo"><i class="fa-solid fa-user-gear"></i> Modificar Personal Médico</div>
        <a href="dashboard_admin.jsp" class="btn-back"><i class="fa-solid fa-arrow-left"></i> Cancelar</a>
    </div>

    <div class="container">
        <div class="form-card">
            <h2><i class="fa-solid fa-user-doctor"></i> Perfil del Dr(a). <%= nombre %> <%= apPat %></h2>
            
            <form action="ActualizarDoctorServlet" method="POST">
                <div class="form-grid">
                    
                    <div class="form-group">
                        <label>Cédula Profesional (No modificable)</label>
                        <input type="number" name="txtCedula" value="<%= doctor.getCedulaProf() %>" readonly>
                    </div>

                    <div class="form-group">
                        <label>Estado Laboral</label>
                        <select name="cmbActivo" required>
                            <option value="true" <%= estaActivo ? "selected" : "" %>>Activo / Disponible</option>
                            <option value="false" <%= !estaActivo ? "selected" : "" %>>Inactivo / Baja Temporal</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Nombre(s)</label>
                        <input type="text" name="txtNomDoc" value="<%= nombre %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Apellido Paterno</label>
                        <input type="text" name="txtApPatDoc" value="<%= apPat %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Apellido Materno</label>
                        <input type="text" name="txtApMatDoc" value="<%= apMat %>">
                    </div>

                    <div class="form-group">
                        <label>Especialidad</label>
                        <select name="cmbEspecialidad" required>
                            <option value="General" <%= "General".equals(especialidad) ? "selected" : "" %>>Odontología General</option>
                            <option value="Ortodoncia" <%= "Ortodoncia".equals(especialidad) ? "selected" : "" %>>Ortodoncia</option>
                            <option value="Endodoncia" <%= "Endodoncia".equals(especialidad) ? "selected" : "" %>>Endodoncia</option>
                            <option value="Cirugia" <%= "Cirugia".equals(especialidad) ? "selected" : "" %>>Cirugía Maxilofacial</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Correo Electrónico (Solo Lectura)</label>
                        <input type="email" name="txtEmailDoc" value="<%= doctor.getEmail() %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Número Telefónico</label>
                        <input type="tel" name="txtTelefono" value="<%= telefono %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Días de Trabajo</label>
                        <select name="cmbDiasTrabajo" required>
                            <option value="Domingo a Viernes" <%= "Domingo a Viernes".equals(dias) ? "selected" : "" %>>Domingo a Viernes</option>
                            <option value="Lunes a Sábado" <%= "Lunes a Sábado".equals(dias) ? "selected" : "" %>>Lunes a Sábado</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fa-solid fa-clock"></i> Hora Entrada.</label>
                        <select name="cmbHoraEntrada" required>
                            <option value="08:00" <%="08:00".equals(hEntrada) ? "selected" : ""%>>08:00 AM</option>
                            <option value="09:00" <%="09:00".equals(hEntrada) ? "selected" : ""%>>09:00 AM</option>
                            <option value="10:00" <%="10:00".equals(hEntrada) ? "selected" : ""%>>10:00 AM</option>
                            <option value="11:00" <%="11:00".equals(hEntrada) ? "selected" : ""%>>11:00 AM</option>
                            <option value="12:00" <%="12:00".equals(hEntrada) ? "selected" : ""%>>12:00 PM</option>
                            <option value="13:00" <%="13:00".equals(hEntrada) ? "selected" : ""%>>01:00 AM</option>
                            <option value="14:00" <%="14:00".equals(hEntrada) ? "selected" : ""%>>02:00 PM</option>
                            <option value="15:00" <%="15:00".equals(hEntrada) ? "selected" : ""%>>03:00 PM</option>
                            <option value="16:00" <%="16:00".equals(hEntrada) ? "selected" : ""%>>04:00 PM</option>
                            <option value="17:00" <%="17:00".equals(hEntrada) ? "selected" : ""%>>05:00 PM.</option>
                            <option value="18:00" <%="18:00".equals(hEntrada) ? "selected" : ""%>>06:00 PM</option>
                            <option value="19:00" <%="19:00".equals(hEntrada) ? "selected" : ""%>>07:00 PM</option>
                            <option value="20:00" <%="20:00".equals(hEntrada) ? "selected" : ""%>>08:00 PM</option>
                            <option value="21:00" <%="21:00".equals(hEntrada) ? "selected" : ""%>>09:00 PM</option>
                            <option value="22:00" <%="22:00".equals(hEntrada) ? "selected" : ""%>>10:00 PM</option>
                            <option value="23:00" <%="23:00".equals(hEntrada) ? "selected" : ""%>>11:00 PM</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fa-solid fa-clock"></i> Hora Salida.</label>
                        <select name="cmbHoraSalida" required>
                            <option value="08:00" <%="08:00".equals(hSalida) ? "selected" : ""%>>08:00 AM</option>
                            <option value="09:00" <%="09:00".equals(hSalida) ? "selected" : ""%>>09:00 AM</option>
                            <option value="10:00" <%="10:00".equals(hSalida) ? "selected" : ""%>>10:00 AM</option>
                            <option value="11:00" <%="11:00".equals(hSalida) ? "selected" : ""%>>11:00 AM</option>
                            <option value="12:00" <%="12:00".equals(hSalida) ? "selected" : ""%>>12:00 PM</option>
                            <option value="13:00" <%="13:00".equals(hSalida) ? "selected" : ""%>>01:00 AM</option>
                            <option value="14:00" <%="14:00".equals(hSalida) ? "selected" : ""%>>02:00 PM</option>
                            <option value="15:00" <%="15:00".equals(hSalida) ? "selected" : ""%>>03:00 PM</option>
                            <option value="16:00" <%="16:00".equals(hSalida) ? "selected" : ""%>>04:00 PM</option>
                            <option value="17:00" <%="17:00".equals(hSalida) ? "selected" : ""%>>05:00 PM.</option>
                            <option value="18:00" <%="18:00".equals(hSalida) ? "selected" : ""%>>06:00 PM</option>
                            <option value="19:00" <%="19:00".equals(hSalida) ? "selected" : ""%>>07:00 PM</option>
                            <option value="20:00" <%="20:00".equals(hSalida) ? "selected" : ""%>>08:00 PM</option>
                            <option value="21:00" <%="21:00".equals(hSalida) ? "selected" : ""%>>09:00 PM</option>
                            <option value="22:00" <%="22:00".equals(hSalida) ? "selected" : ""%>>10:00 PM</option>
                            <option value="23:00" <%="23:00".equals(hSalida) ? "selected" : ""%>>11:00 PM</option>
                        </select>
                    </div>
                    
                </div>
                
                <button type="submit" class="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> Guardar Cambios del Médico
                </button>
            </form>
        </div>
    </div>

</body>
</html>