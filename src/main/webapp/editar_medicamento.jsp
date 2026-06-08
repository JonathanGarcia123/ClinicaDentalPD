<%-- 
    Document   : editar_medicamento
    Created on : 7 jun 2026, 10:43:26 p.m.
    Author     : jonyx
--%>

<%@page import="modelo.Usuarios"%>
<%@page import="modelo.Tratamientos"%>
<%@page import="datos.TratamientoDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CONTROL DE ACCESO: Solo el Administrador puede gestionar el inventario/tratamientos
    Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
    if (user == null || !user.getFkRol().getNombreRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp?error=sesion");
        return;
    }

    // 2. CAPTURAR EL CÓDIGO DE LA URL Y BUSCAR EN MONGO
    String codigoParam = request.getParameter("codigo");
    Tratamientos tratamiento = null;
    
    if (codigoParam != null && !codigoParam.trim().isEmpty()) {
        try {
            int codigoInt = Integer.parseInt(codigoParam);
            TratamientoDAO tDAO = new TratamientoDAO();
            tratamiento = tDAO.buscarPorCodigo(codigoInt);
        } catch (NumberFormatException e) {
            System.err.println("Error al parsear el código en el JSP de edición: " + e.getMessage());
        }
    }

    // Si el código no es válido o el tratamiento no existe, regresamos al panel
    if (tratamiento == null) {
        response.sendRedirect("dashboard_admin.jsp?status=treatNotFound");
        return;
    }

    // 3. EXTRAER VALORES Y FORMATEAR LA FECHA PARA EL INPUT DATE (yyyy-MM-dd)
    String nombre = (tratamiento.getNombre() != null) ? tratamiento.getNombre() : "";
    String descripcion = (tratamiento.getDescription() != null) ? tratamiento.getDescription() : "";
    double precio = (tratamiento.getPrecioBase() != null) ? tratamiento.getPrecioBase() : 0.0;
    int stock = tratamiento.getStock();
    
    String fechaFormateada = "";
    if (tratamiento.getFechaCaducidad() != null) {
        SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
        fechaFormateada = sdfInput.format(tratamiento.getFechaCaducidad());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modificar Tratamiento - Clínica Dental PD</title>
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
        <div class="logo"><i class="fa-solid fa-boxes-stacked"></i> Modificar Catálogo de Insumos</div>
        <a href="dashboard_admin.jsp" class="btn-back"><i class="fa-solid fa-arrow-left"></i> Cancelar</a>
    </div>

    <div class="container">
        <div class="form-card">
            <h2><i class="fa-solid fa-pills"></i> Editar: <%= nombre %></h2>
            
            <form action="ActualizarTratamientoServlet" method="POST">
                <div class="form-grid">
                    
                    <div class="form-group">
                        <label>Código del Tratamiento (No modificable)</label>
                        <input type="number" name="txtCodProducto" value="<%= tratamiento.getCodProducto() %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Nombre del Tratamiento / Medicamento</label>
                        <input type="text" name="txtNombreTratamiento" value="<%= nombre %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Precio Base ($ MXN)</label>
                        <input type="number" step="0.01" name="txtPrecioBase" value="<%= precio %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Stock / Unidades Disponibles</label>
                        <input type="number" name="txtStock" value="<%= stock %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Fecha de Caducidad</label>
                        <input type="date" name="txtFechaCaducidad" value="<%= fechaFormateada %>" required>
                    </div>
                    
                    <div class="form-group" style="grid-column: span 2;">
                        <label>Descripción del Servicio o Medicamento</label>
                        <input type="text" name="txtDescripcion" value="<%= descripcion %>" placeholder="Detalles o restricciones...">
                    </div>
                    
                </div>
                
                <button type="submit" class="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> Guardar Cambios en Inventario
                </button>
            </form>
        </div>
    </div>

</body>
</html>
