/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import datos.AgendaDAO;
import datos.PacientesDAO;
import datos.TratamientoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Date;
import modelo.Historial;
import modelo.Tratamientos;
import modelo.Usuarios;
import org.bson.types.ObjectId;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "GuardarHistorialServlet", urlPatterns = {"/GuardarHistorialServlet"})
public class GuardarHistorialServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuarios doctorLogueado = (Usuarios) session.getAttribute("usuarioLogueado");
        
        // Control de seguridad: Validar sesión del médico
        if (doctorLogueado == null) {
            response.sendRedirect("login.jsp?error=sesion");
            return;
        }

        try {
            // 1. CAPTURAR PARÁMETROS DEL FORMULARIO
            String idCitaStr = request.getParameter("txtIdCita");
            String emailPaciente = request.getParameter("txtEmailPaciente");
            String codTratamientoStr = request.getParameter("cmbTratamientoAplicado");
            String observaciones = request.getParameter("txtObservaciones");
            String medicamentos = request.getParameter("txtMedicamentos");

            // 2. BUSCAR EL TRATAMIENTO SELECCIONADO EN LA BD
            int codTratamiento = Integer.parseInt(codTratamientoStr);
            TratamientoDAO tDAO = new TratamientoDAO();
            Tratamientos tratamientoAplicado = tDAO.buscarPorCodigo(codTratamiento);

            // 3. ARMAR EL OBJETO HISTORIAL SEGÚN TU MODELO
            Historial nuevaNota = new Historial(); // Autogenera el idHistorial internamente
            nuevaNota.setTratamiento(tratamientoAplicado);
            nuevaNota.setObservaciones(observaciones);
            nuevaNota.setFechaAplicacion(new Date()); // Fecha y hora exacta de la consulta (hoy)
            nuevaNota.setNombreMedico(doctorLogueado.getEmail()); // Guardamos la firma del médico
            nuevaNota.setMedicamentosRecetados(medicamentos != null ? medicamentos : "");

            // 4. EJECUTAR OPERACIONES EN BASE DE DATOS
            PacientesDAO pDAO = new PacientesDAO();
            AgendaDAO aDAO = new AgendaDAO();
            
            // Paso A: Insertar la nota clínica en el expediente del paciente
            boolean historialGuardado = pDAO.agregarHistorial(emailPaciente, nuevaNota);
            
            // Paso B: Marcar la cita de la agenda como Finalizada
            boolean citaFinalizada = aDAO.finalizarCita(new ObjectId(idCitaStr));

            // 5. REDIRECCIONAR SEGÚN EL RESULTADO
            if (historialGuardado && citaFinalizada) {
                // Éxito rotundo: regresamos al panel del doctor
                response.sendRedirect("dashboard_doctor.jsp?status=consultaSuccess");
            } else {
                response.sendRedirect("dashboard_doctor.jsp?status=consultaError");
            }

        } catch (Exception e) {
            System.err.println("Error en GuardarHistorialServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard_doctor.jsp?status=errorException");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
