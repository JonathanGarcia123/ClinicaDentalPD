<%-- 
    Document   : dashboard_admin
    Created on : 4 jun 2026, 7:36:56 p.m.
    Author     : jonyx
--%>

<%@page import="modelo.Agenda"%>
<%@page import="datos.AgendaDAO"%>
<%@page import="modelo.NombreCompleto"%>
<%@page import="modelo.Pacientes"%>
<%@page import="datos.PacientesDAO"%>
<%@page import="modelo.Usuarios"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Doctores"%>
<%@page import="datos.DoctoresDAO"%>
<%-- NUEVOS IMPORTS PARA LA PESTAÑA TRATAMIENTOS --%>
<%@page import="modelo.Tratamientos"%>
<%@page import="datos.TratamientoDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CONTROL DE ACCESO: Si no hay sesión o no es Administrador, directo al login
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }
    
    String status = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración - Clínica Dental PD</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; }

        /* Navbar */
        .navbar {
            background-color: #0f172a; /* Un tono más oscuro y serio para el Admin */
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
        .container { max-width: 1300px; margin: 30px auto; padding: 0 20px; }
        
        .welcome-card { 
            background: linear-gradient(135deg, #0f172a 0%, #334155 100%); 
            color: white; padding: 25px 30px; border-radius: 16px; margin-bottom: 30px; 
        }

        /* Tabs de Navegación */
        .tabs-nav { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px; overflow-x: auto; }
        .tab-btn { background: none; border: none; padding: 10px 20px; font-size: 15px; font-weight: 600; color: #64748b; cursor: pointer; transition: 0.3s; border-radius: 8px; white-space: nowrap; }
        .tab-btn:hover { background-color: #e2e8f0; color: #0f172a; }
        .tab-btn.active { background-color: #0f172a; color: white; }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; animation: fadeIn 0.4s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }

        /* Tarjetas y Contenedores */
        .panel-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 25px; }
        .panel-card h3 { color: #0f172a; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }

        /* Tablas */
        .table-responsive { width: 100%; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background-color: #f8fafc; color: #64748b; padding: 12px; font-size: 14px; border-bottom: 2px solid #e2e8f0; }
        td { padding: 15px 12px; border-bottom: 1px solid #e2e8f0; font-size: 14px; }
        
        /* Estados (Badges) */
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge.active { background-color: #dcfce7; color: #15803d; }
        .badge.inactive { background-color: #fee2e2; color: #b91c1c; }

        /* Botones de Acción */
        .btn-table { padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 5px; }
        .btn-view { background-color: #e0f2fe; color: #0369a1; }
        .btn-view:hover { background-color: #bae6fd; }
        .btn-status { background-color: #f1f5f9; color: #334155; }
        .btn-status:hover { background-color: #e2e8f0; }
        
        .btn-add { background-color: #10b981; color: white; padding: 12px 24px; border-radius: 10px; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 10px; margin-bottom: 20px; transition: 0.2s; }
        .btn-add:hover { background-color: #059669; transform: translateY(-1px); }

        /* Grid de Formularios de Registro Corto */
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px; margin-bottom: 15px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-weight: 600; font-size: 13px; color: #475569; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; font-size: 14px; }
        .form-group input:focus, .form-group select:focus { border-color: #0f172a; }
        
        /* Estilo para Alertas de Éxito o Error */
        .alert {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideDown 0.3s ease-in-out;
        }
        .alert-success {
            background-color: #dcfce7;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }
        .alert-error {
            background-color: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo"><i class="fa-solid fa-screwdriver-wrench"></i> Panel de Administración - Clínica PD</div>
        <div style="display: flex; align-items: center; gap: 20px;">
            <span><i class="fa-solid fa-user-shield"></i> <%= user.getEmail() %></span>
            <a href="LogoutServlet" class="btn-logout">Cerrar Sesión</a>
        </div>
    </div>

    <div class="container">
        
        <div class="welcome-card">
            <h1>Bienvenido, Administrador</h1>
            <p>Control total del sistema: gestión de personal médico, monitor de citas y expedientes de pacientes.</p>
        </div>
        
        <% if ("docSuccess".equals(status)) { %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check" style="font-size: 18px;"></i>
                <span>¡El médico ha sido dado de alta exitosamente! Se creó su cuenta de acceso y su expediente médico.</span>
            </div>
        <% } else if ("docErrorUsuario".equals(status)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-exclamation" style="font-size: 18px;"></i>
                <span>Error: El correo electrónico ya se encuentra registrado en el sistema.</span>
            </div>
        <% } else if ("docErrorPerfil".equals(status)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-exclamation" style="font-size: 18px;"></i>
                <span>Error: No se pudo generar el perfil del médico en la base de datos.</span>
            </div>
        <% } else if ("errorException".equals(status)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-xmark" style="font-size: 18px;"></i>
                <span>Ocurrió un error inesperado al procesar los datos del formulario.</span>
            </div>
        <% } else if ("treatSuccess".equals(status)) { %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check" style="font-size: 18px;"></i>
                <span>¡El medicamento/tratamiento ha sido agregado al inventario correctamente!</span>
            </div>
        <% } else if ("errorInsertTratamiento".equals(status)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-xmark" style="font-size: 18px;"></i>
                <span>¡El medicamento/tratamiento no pudo ser insertado correctamente!</span>
            </div>
        <% } else if ("updateTreatSuccess".equals(status)) { %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check" style="font-size: 18px;"></i>
                <span>¡Los datos del tratamiento han sido actualizados con éxito!</span>
            </div>
        <% } else if ("updateDocError".equals(status)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-exclamation" style="font-size: 18px;"></i>
                <span>Error: No se pudo registrar el tratamiento. Comprueba que el código no esté duplicado.</span>
            </div>
        <% } %>

        <div class="tabs-nav">
            <button class="tab-btn active" onclick="switchTab(event, 'tab-doctores')"><i class="fa-solid fa-user-doctor"></i> Gestionar Doctores</button>
            <button class="tab-btn" onclick="switchTab(event, 'tab-pacientes')"><i class="fa-solid fa-hospital-user"></i> Lista de Pacientes</button>
            <button class="tab-btn" onclick="switchTab(event, 'tab-tratamientos')"><i class="fa-solid fa-pills"></i> Tratamientos y Medicamentos</button>
            <button class="tab-btn" onclick="switchTab(event, 'tab-citas-global')"><i class="fa-solid fa-notes-medical"></i> Agenda de Citas</button>
        </div>

        <!-- PESTAÑA 1: DOCTORES -->
        <div id="tab-doctores" class="tab-content active">
            <div class="panel-card">
                <h3><i class="fa-solid fa-user-plus"></i> Registrar Nuevo Médico</h3>
                <form action="RegistrarDoctorServlet" method="POST">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Cedula Profesional</label>
                            <input type="text" name="txtCedula" placeholder="Ej: 12345678" required>
                        </div>
                        <div class="form-group">
                            <label>Nombre(s)</label>
                            <input type="text" name="txtNomDoc" placeholder="Ej: Alejandro" required>
                        </div>
                        <div class="form-group">
                            <label>Apellido Paterno</label>
                            <input type="text" name="txtApPatDoc" placeholder="Ej: Olvera" required>
                        </div>
                        <div class="form-group">
                            <label>Apellido Materno</label>
                            <input type="text" name="txtApMatDoc" placeholder="Ej: Olvera">
                        </div>
                        <div class="form-group">
                            <label>Especialidad</label>
                            <select name="cmbEspecialidad" required>
                                <option value="" disabled selected>-- Elegir --</option>
                                <option value="General">Odontología General</option>
                                <option value="Ortodoncia">Ortodoncia</option>
                                <option value="Endodoncia">Endodoncia</option>
                                <option value="Cirugia">Cirugía Maxilofacial</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Correo Electrónico</label>
                            <input type="email" name="txtEmailDoc" placeholder="doctor@clinica.com" required>
                        </div>
                        <div class="form-group">
                            <label>Numero telefonico</label>
                            <input type="tel" name="txtTelefono" placeholder="Ej: 1234567890" required>
                        </div>
                        <div class="form-group">
                            <label>Dias de trabajo</label>
                            <select name="cmbDiasTrabajo" required>
                                <option value="" disabled selected>-- Elegir --</option>
                                <option value="Domingo a Viernes">Domingo a Viernes</option>
                                <option value="Luneas a Sabado">Luneas a Sabado</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label><i class="fa-solid fa-clock"></i> Hora entrada.</label>
                            <select name="cmbHoraEntrada" required>
                                <option value="" disabled selected>-- Selecciona la hora --</option>
                                <option value="08:00">08:00 AM</option>
                                <option value="09:00">09:00 AM</option>
                                <option value="10:00">10:00 AM</option>
                                <option value="11:00">11:00 AM</option>
                                <option value="12:00">12:00 PM</option>
                                <option value="13:00">01:00 AM</option>
                                <option value="14:00">02:00 PM</option>
                                <option value="15:00">03:00 PM</option>
                                <option value="16:00">04:00 PM</option>
                                <option value="17:00">05:00 PM.</option>
                                <option value="18:00">06:00 PM</option>
                                <option value="19:00">07:00 PM</option>
                                <option value="20:00">08:00 PM</option>
                                <option value="21:00">09:00 PM</option>
                                <option value="22:00">10:00 PM</option>
                                <option value="23:00">11:00 PM</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label><i class="fa-solid fa-clock"></i> Hora salida.</label>
                            <select name="cmbHoraSalida" required>
                                <option value="" disabled selected>-- Selecciona la hora --</option>
                                <option value="08:00">08:00 AM</option>
                                <option value="09:00">09:00 AM</option>
                                <option value="10:00">10:00 AM</option>
                                <option value="11:00">11:00 AM</option>
                                <option value="12:00">12:00 PM</option>
                                <option value="13:00">01:00 AM</option>
                                <option value="14:00">02:00 PM</option>
                                <option value="15:00">03:00 PM</option>
                                <option value="16:00">04:00 PM</option>
                                <option value="17:00">05:00 PM.</option>
                                <option value="18:00">06:00 PM</option>
                                <option value="19:00">07:00 PM</option>
                                <option value="20:00">08:00 PM</option>
                                <option value="21:00">09:00 PM</option>
                                <option value="22:00">10:00 PM</option>
                                <option value="23:00">11:00 PM</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Contraseña (temporal)</label>
                            <input type="password" name="txtPasswordDoc" placeholder="••••••••" required>
                        </div>
                        <div class="form-group">
                            <label>Consultorio</label>
                            <select name="cmbConsultorio" required>
                                <option value="" disabled selected>-- Selecciona el consultorio --</option>
                                <option value="1">Consultorio 1</option>
                                <option value="2">Consultorio 2</option>
                                <option value="3">Consultorio 3</option>
                                <option value="4">Consultorio 4</option>
                                <option value="5">Consultorio 5</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn-add" style="margin-bottom: 0; padding: 10px 20px; font-size: 14px;">
                        <i class="fa-solid fa-user-check"></i> Dar de Alta Doctor
                    </button>
                </form>
            </div>

            <div class="panel-card">
                <h3><i class="fa-solid fa-address-book"></i> Personal Médico Registrado</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Nombre Completo</th>
                                <th>Especialidad</th>
                                <th>Correo</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                DoctoresDAO dDAO = new DoctoresDAO();
                                List<Doctores> listaDoctores = dDAO.obtenerTodos();

                                if (listaDoctores == null || listaDoctores.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align: center; color: #64748b;">No hay médicos registrados en el sistema.</td>
                                </tr>
                            <%
                                } else {
                                    for (Doctores doc : listaDoctores) {
                                        String nombreCompleto = doc.getNomCompD().getNombre() + " " + 
                                                               doc.getNomCompD().getApPat() + " " + 
                                                               (doc.getNomCompD().getApMat() != null ? doc.getNomCompD().getApMat() : "");
                            %>
                                <tr>
                                    <td><%= nombreCompleto %></td>
                                    <td><%= doc.getEspecialidad() %></td>
                                    <td><%= doc.getEmail() %></td>
                                    <td>
                                        <% if (doc.getActivo() != null && doc.getActivo()) { %>
                                            <span class="badge active">Activo</span>
                                        <% } else { %>
                                            <span class="badge inactive">Inactivo</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <a href="editar_doctor.jsp?cedula=<%= doc.getCedulaProf() %>" class="btn-table btn-view" style="background-color: #f0fdf4; color: #16a34a;">
                                            <i class="fa-solid fa-user-pen"></i> Editar Perfil
                                        </a>
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

        <!-- PESTAÑA 2: PACIENTES -->
        <div id="tab-pacientes" class="tab-content">
            <div class="panel-card">
                <h3><i class="fa-solid fa-users"></i> Expedientes de Pacientes</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>CURP</th>
                                <th>Nombre del Paciente</th>
                                <th>Teléfono</th>
                                <th>Correo Asociado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                PacientesDAO pDAO = new PacientesDAO();
                                List<Pacientes> listaPacientes = pDAO.obtenerTodos();

                                if (listaPacientes == null || listaPacientes.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align: center; color: #64748b;">No hay pacientes registrados en el sistema.</td>
                                </tr>
                            <%
                                } else {
                                    for (Pacientes pac : listaPacientes) {
                                        String nombreCompletoPac = "Datos incompletos (Primer ingreso)";
                                        NombreCompleto ncPac = pac.getNomCompP();

                                        if (ncPac != null && ncPac.getNombre() != null) {
                                            nombreCompletoPac = ncPac.getNombre() + " " + 
                                                                ncPac.getApPat() + " " + 
                                                                (ncPac.getApMat() != null ? ncPac.getApMat() : "");
                                        }

                                        String curpPac = (pac.getCurp() != null) ? pac.getCurp() : "No registrada";
                                        String telPac = (pac.getTelefono() != null) ? pac.getTelefono() : "No registrado";
                            %>
                                <tr>
                                    <td><%= curpPac %></td>
                                    <td><%= nombreCompletoPac %></td>
                                    <td><%= telPac %></td>
                                    <td><%= pac.getEmail() %></td>
                                    <td>
                                        <a href="VerExpedienteAdminServlet?curp=<%= curpPac %>" class="btn-table btn-view">
                                            <i class="fa-solid fa-folder-open"></i> Ver Expediente / Historial
                                        </a>
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

        <!-- NUEVA PESTAÑA 3: GESTIONAR TRATAMIENTOS / MEDICAMENTOS -->
        <div id="tab-tratamientos" class="tab-content">
            <!-- Formulario de Registro basado en el Modelo -->
            <div class="panel-card">
                <h3><i class="fa-solid fa-plus-circle"></i> Registrar Insumo / Servicio Médico</h3>
                <form action="RegistrarTratamientoServlet" method="POST">
                    <div class="form-grid">

                        <div class="form-group">
                            <label>Tipo de Registro</label>
                            <select name="cmbTipo" id="cmbTipo" onchange="evaluarTipo()" required>
                                <option value="" disabled selected>-- Selecciona el tipo --</option>
                                <option value="Medicamento">Medicamento / Insumo Físico</option>
                                <option value="Tratamiento">Tratamiento / Servicio Clínico</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Código (Numérico)</label>
                            <input type="number" name="txtCodProducto" placeholder="Ej: 80112" required>
                        </div>
                        <div class="form-group">
                            <label>Nombre del Tratamiento / Medicamento</label>
                            <input type="text" name="txtNombreTratamiento" placeholder="Ej: Resina / Amoxicilina" required>
                        </div>
                        <div class="form-group">
                            <label>Precio Base ($ MXN)</label>
                            <input type="number" step="0.01" name="txtPrecioBase" placeholder="Ej: 349.50" required>
                        </div>

                        <div class="form-group" id="grupoStock">
                            <label>Stock / Cantidad Disponible</label>
                            <input type="number" name="txtStock" id="txtStock" placeholder="Ej: 45" required>
                        </div>

                        <div class="form-group" id="grupoCaducidad">
                            <label>Fecha de Caducidad</label>
                            <input type="date" name="txtFechaCaducidad" id="txtFechaCaducidad">
                        </div>

                        <div class="form-group" style="grid-column: span 2;">
                            <label>Descripción del Servicio o Medicamento</label>
                            <input type="text" name="txtDescripcion" placeholder="Escribe detalles del uso o restricciones...">
                        </div>
                    </div>
                    <button type="submit" class="btn-add" style="margin-bottom: 0; padding: 10px 20px; font-size: 14px; background-color: #0f172a;">
                        <i class="fa-solid fa-floppy-disk"></i> Guardar en Catálogo
                    </button>
                </form>
            </div>

            <!-- Tabla de Visualización del Catálogo / Medicamentos -->
            <div class="panel-card">
                <h3><i class="fa-solid fa-boxes-stacked"></i> Catálogo de Medicamentos y Servicios Activos</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Medicamento / Tratamiento</th>
                                <th>Descripción</th>
                                <th>Precio Base</th>
                                <th>Stock</th>
                                <th>Caducidad</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                TratamientoDAO tDAO = new TratamientoDAO();
                                List<Tratamientos> listaTratamientos = tDAO.obtenerTodos();
                                
                                if (listaTratamientos == null || listaTratamientos.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="7" style="text-align: center; color: #64748b;">No hay tratamientos ni medicamentos en el inventario.</td>
                                </tr>
                            <%
                                } else {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                    for (Tratamientos t : listaTratamientos) {
                                        String fechaFormat = (t.getFechaCaducidad() != null) ? sdf.format(t.getFechaCaducidad()) : "N/A";
                            %>
                                <tr>
                                    <td><strong>#<%= t.getCodProducto() %></strong></td>
                                    <td><%= t.getNombre() %></td>
                                    <td><%= (t.getDescription() != null) ? t.getDescription() : "Sin descripción" %></td>
                                    <td>$<%= String.format("%.2f", t.getPrecioBase()) %></td>
                                    <td>
                                        <% if(t.getStock() <= 5) { %>
                                            <span class="badge inactive" style="font-size: 13px;"><%= t.getStock() %> (Crítico)</span>
                                        <% } else { %>
                                            <span class="badge active" style="background-color: #e0f2fe; color: #0369a1;"><%= t.getStock() %> uds</span>
                                        <% } %>
                                    </td>
                                    <td><%= fechaFormat %></td>
                                    <td>
                                        <% 
                                            // Si no tiene fecha de caducidad, es un Tratamiento clínico
                                            String paginaDestino = "editar_medicamento.jsp";
                                            if (t.getFechaCaducidad() == null) {
                                                paginaDestino = "editar_tratamiento.jsp";
                                            }
                                        %>
                                        <a href="<%= paginaDestino %>?codigo=<%= t.getCodProducto() %>" class="btn-table btn-view" style="background-color: #f0fdf4; color: #16a34a;">
                                            <i class="fa-solid fa-pen-to-square"></i> Editar
                                        </a>
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

        <!-- PESTAÑA 4: CITAS -->
        <div id="tab-citas-global" class="tab-content">
            <div class="panel-card">
                <h3><i class="fa-solid fa-clock"></i> Registro General de Consultas Programadas</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Fecha / Hora</th>
                                <th>Paciente</th>
                                <th>Médico Tratante</th>
                                <th>Tratamiento</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // 1. Instanciamos el DAO de Agenda para recuperar todas las citas registradas en MongoDB
                                AgendaDAO agendaDAO = new AgendaDAO();
                                List<Agenda> todasLasCitas = agendaDAO.obtenerTodos();

                                if (todasLasCitas == null || todasLasCitas.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align: center; color: #64748b;">No hay consultas médicas programadas en el sistema.</td>
                                </tr>
                            <%
                                } else {
                                    java.text.SimpleDateFormat sdfVisual = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                    for (Agenda cita : todasLasCitas) {
                                        // Formateamos la fecha de MongoDB
                                        String fechaCitaStr = (cita.getFecha() != null) ? sdfVisual.format(cita.getFecha()) : "N/A";

                                        // Extraer nombre del Paciente de forma segura
                                        String nombrePaciente = "Datos incompletos";
                                        if (cita.getFkPaciente() != null && cita.getFkPaciente().getNomCompP() != null) {
                                            nombrePaciente = cita.getFkPaciente().getNomCompP().getNombre() + " " + 
                                                             cita.getFkPaciente().getNomCompP().getApPat();
                                        }

                                        // Extraer nombre del Médico de forma segura
                                        String nombreMedico = "Por asignar";
                                        if (cita.getFkDoctor() != null && cita.getFkDoctor().getNomCompD() != null) {
                                            nombreMedico = "Dr(a). " + cita.getFkDoctor().getNomCompD().getNombre() + " " + 
                                                           cita.getFkDoctor().getNomCompD().getApPat();
                                        }

                                        // Control dinámico de estilos para el Badge de Estado (Activo vs Cancelado)
                                        String badgeStyle = "background-color: #e0f2fe; color: #0369a1;"; // Azul para Agendada/Activo
                                        if ("Cancelado".equalsIgnoreCase(cita.getStatus())) {
                                            badgeStyle = "background-color: #fee2e2; color: #b91c1c;"; // Rojo para Cancelada
                                        }
                            %>
                                <tr>
                                    <td><strong><%= fechaCitaStr %> - <%= cita.getHora() %></strong></td>
                                    <td><%= nombrePaciente %></td>
                                    <td><%= nombreMedico %></td>
                                    <td><%= cita.getMotivo() %></td>
                                    <td>
                                        <span class="badge" style="<%= badgeStyle %>">
                                            <%= "Activo".equalsIgnoreCase(cita.getStatus()) ? "Agendada" : cita.getStatus() %>
                                        </span>
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
        
        function evaluarTipo() {
            const tipo = document.getElementById("cmbTipo").value;
            const grupoCaducidad = document.getElementById("grupoCaducidad");
            const inputCaducidad = document.getElementById("txtFechaCaducidad");

            const grupoStock = document.getElementById("grupoStock");
            const inputStock = document.getElementById("txtStock");

            if (tipo === "Tratamiento") {
                // 1. Ocultamos la Fecha de Caducidad y limpiamos su valor
                grupoCaducidad.style.display = "none";
                inputCaducidad.value = ""; 
                inputCaducidad.removeAttribute("required");

                // 2. Un tratamiento no maneja "piezas de stock" de forma estricta (puedes ocultarlo o ponerlo opcional)
                // Si prefieres ocultar el stock para los servicios:
                grupoStock.style.display = "none";
                inputStock.value = "0"; // Mandamos un 0 por defecto a Java para que no truene el parseo
                inputStock.removeAttribute("required");

            } else if (tipo === "Medicamento") {
                // Si es medicamento, ambos campos son visibles y obligatorios
                grupoCaducidad.style.display = "flex";
                inputCaducidad.setAttribute("required", "required");

                grupoStock.style.display = "flex";
                inputStock.value = "";
                inputStock.setAttribute("required", "required");
            }
        }
    </script>
</body>
</html>