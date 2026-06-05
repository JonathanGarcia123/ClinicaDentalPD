<%-- 
    Document   : agendar_cita
    Created on : 4 jun 2026, 7:16:23 p.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // CONTROL DE ACCESO: Solo pacientes logueados pueden agendar
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Paciente")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendar Cita - Clínica Dental PD</title>
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

        .btn-back {
            color: white;
            text-decoration: none;
            background-color: rgba(255, 255, 255, 0.1);
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-back:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .container { 
            max-width: 700px; 
            margin: 40px auto; 
            padding: 0 20px; 
        }

        .form-card { 
            background: white; 
            padding: 30px; 
            border-radius: 16px; 
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); 
            border: 1px solid #e2e8f0; 
        }

        .form-card h2 { 
            color: #005088; 
            margin-bottom: 25px; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
            font-size: 24px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 576px) {
            .form-grid { grid-template-columns: 1fr; }
        }

        .form-group { 
            display: flex; 
            flex-direction: column; 
            gap: 8px; 
        }

        /* Aplica a los grupos que deban ocupar todo el ancho */
        .full-width {
            grid-column: span 2;
        }
        @media (max-width: 576px) {
            .full-width { grid-column: span 1; }
        }

        .form-group label { 
            font-weight: 600; 
            color: #334155; 
            font-size: 14px; 
        }
        
        .form-group input, .form-group select { 
            width: 100%;
            padding: 12px; 
            border: 1px solid #e2e8f0; 
            border-radius: 10px; 
            outline: none; 
            transition: 0.3s; 
            font-size: 14px;
            background-color: white;
            box-sizing: border-box;
        }
        
        .form-group input:focus, .form-group select:focus { 
            border-color: #11CAA0; 
            box-shadow: 0 0 0 3px rgba(17, 202, 160, 0.1);
        }

        .btn-submit { 
            background-color: #11CAA0; 
            color: white; 
            border: none; 
            padding: 14px 28px; 
            border-radius: 10px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: 0.3s; 
            margin-top: 15px; 
            width: 100%;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-submit:hover { 
            background-color: #0da885; 
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo"><i class="fa-solid fa-tooth"></i> Clínica Dental PD</div>
        <a href="dashboard_paciente.jsp" class="btn-back"><i class="fa-solid fa-arrow-left"></i> Volver al Panel</a>
    </div>

    <div class="container">
        <div class="form-card">
            <h2><i class="fa-solid fa-calendar-check"></i> Agendar Nueva Cita</h2>
            
            <form action="AgendarCitaServlet" method="POST">
                <div class="form-grid">
                    
                    <div class="form-group full-width">
                        <label><i class="fa-solid fa-user-doctor"></i> Selecciona al Dentista Asignado</label>
                        <select name="cmbDoctor" required>
                            <option value="" disabled selected>-- Elige un médico --</option>
                            <option value="ID_DOC_ALEJANDRO">Dr. Alejandro Olvera (General)</option>
                            <option value="ID_DOC_MARIANA">Dra. Mariana Costa (Ortodoncia)</option>
                            </select>
                    </div>

                    <div class="form-group full-width">
                        <label><i class="fa-solid fa-stethoscope"></i> Tratamiento / Servicio Requerido</label>
                        <select name="cmbServicio" required>
                            <option value="" disabled selected>-- Selecciona un tratamiento --</option>
                            <option value="Limpieza">Limpieza Profunda</option>
                            <option value="Extraccion">Extracción / Exodoncia</option>
                            <option value="Carillas">Carillas Estéticas</option>
                            <option value="Resina">Resinas Dentales</option>
                            <option value="Ortodoncia">Revisión de Ortodoncia (Brackets)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><i class="fa-solid fa-calendar-day"></i> Fecha de la Cita</label>
                        <input type="date" id="txtFecha" name="txtFecha" required>
                    </div>

                    <div class="form-group">
                        <label><i class="fa-solid fa-clock"></i> Horario Disponible</label>
                        <select name="cmbHora" required>
                            <option value="" disabled selected>-- Selecciona la hora --</option>
                            <option value="09:00">09:00 AM</option>
                            <option value="10:00">10:00 AM</option>
                            <option value="11:00">11:00 AM</option>
                            <option value="12:00">12:00 PM</option>
                            <option value="16:00">04:00 PM</option>
                            <option value="17:00">05:00 PM</option>
                            <option value="18:00">06:00 PM</option>
                        </select>
                    </div>
                    
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-check-circle"></i> Confirmar y Reservar Cita
                </button>
            </form>
        </div>
    </div>

    <script>
        // Bloquear fechas pasadas en el calendario para que no agenden en días que ya pasaron
        const fechaInput = document.getElementById('txtFecha');
        const hoy = new Date();
        const yyyy = hoy.getFullYear();
        let mm = hoy.getMonth() + 1; // Enero es 0
        let dd = hoy.getUTCDate();

        if (mm < 10) mm = '0' + mm;
        if (dd < 10) dd = '0' + dd;

        const fechaMinima = yyyy + '-' + mm + '-' + dd;
        fechaInput.setAttribute('min', fechaMinima);
    </script>
</body>
</html>