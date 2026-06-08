/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import datos.AgendaDAO;
import datos.DoctoresDAO;
import datos.TratamientoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import modelo.Agenda;
import modelo.Doctores;
import modelo.Pacientes;
import modelo.Tratamientos;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "AgendarCitaServlet", urlPatterns = {"/AgendarCitaServlet"})
public class AgendarCitaServlet extends HttpServlet {

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
        Usuarios userLogueado = (Usuarios) session.getAttribute("usuarioLogueado");
        
        if (userLogueado == null) {
            response.sendRedirect("login.jsp?error=sesion");
            return;
        }

        try{
            String cedulaDocStr = request.getParameter("cmbDoctor");
            int cedulaDoc = Integer.parseInt(cedulaDocStr);
            String codTratamientoStr = request.getParameter("cmbServicio");
            int codTratamiento = Integer.parseInt(codTratamientoStr);
            String fechaStr = request.getParameter("txtFecha");
            String hora = request.getParameter("cmbHora"); 
            String tipo = "Tratamiento";
            datos.PacientesDAO pDAO = new datos.PacientesDAO();
            modelo.Pacientes paciente = pDAO.buscarPorEmail(userLogueado.getEmail());
            
            if (paciente == null) {
                System.err.println("Error: No se encontró un perfil de Paciente para el correo: " + userLogueado.getEmail());
                response.sendRedirect("dashboard_paciente.jsp?status=perfilNotFound");
                return;
            }
            
            DoctoresDAO dDAO = new DoctoresDAO();
            Doctores doctorSeleccionado = dDAO.buscarPorCedula(cedulaDoc);
            
            TratamientoDAO tDAO = new TratamientoDAO();
            Tratamientos tratamientoSeleccionado = tDAO.buscarPorTipo(tipo);
            
            SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaCita = formatoFecha.parse(fechaStr);
            
            AgendaDAO aDAO = new AgendaDAO();
            boolean disponible = aDAO.verificarDisponibilidad(cedulaDoc, fechaCita, hora);
            
            if (!disponible) {
                response.sendRedirect("dashboard_paciente.jsp?status=horarioOcupado");
                return;
            }
            
            Agenda nuevaCita = new Agenda();
            nuevaCita.setFkPaciente(paciente);
            nuevaCita.setFkDoctor(doctorSeleccionado); 
            nuevaCita.setFecha(fechaCita);
            nuevaCita.setHora(hora);
            nuevaCita.setDuracionMin(30); 
            nuevaCita.setMotivo(tratamientoSeleccionado.getNombre()); 
            nuevaCita.setStatus("Activo"); 
            nuevaCita.setConsultorio(doctorSeleccionado.getConsultorio());
            
            boolean insertado = aDAO.insertarCita(nuevaCita);
            
            if (insertado) {
                response.sendRedirect("dashboard_paciente.jsp?status=citaSuccess");
            } else {
                response.sendRedirect("dashboard_paciente.jsp?status=citaError");
            }
        }catch(Exception e){
            System.err.println("Error en AgendarCitaServlet: " + e.getMessage());
            response.sendRedirect("dashboard_paciente.jsp?status=errorException");
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
