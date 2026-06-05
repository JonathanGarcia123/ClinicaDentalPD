/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import datos.PacientesDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import modelo.NombreCompleto;
import modelo.Pacientes;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "ActualizarPerfilServlet", urlPatterns = {"/ActualizarPerfilServlet"})
public class ActualizarPerfilServlet extends HttpServlet {

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
        
        if(userLogueado==null){
            response.sendRedirect("login.jsp?error=sesion");
        }
        
        try{
            String curp = request.getParameter("txtCurp");
            String nombre = request.getParameter("txtNombre");
            String apPaterno = request.getParameter("txtApePaterno");
            String apMaterno = request.getParameter("txtApeMaterno");
            String telefono = request.getParameter("txtTelefono");
            String alergias = request.getParameter("txtAlergias");

            Pacientes pacienteActual = (Pacientes) session.getAttribute("pacienteLogueado");
            Pacientes nuevoPaciente = new Pacientes();
            
            if (pacienteActual != null && pacienteActual.getIdPaciente() != null) {
                nuevoPaciente.setIdPaciente(pacienteActual.getIdPaciente());
            }
            
            nuevoPaciente.setCurp(curp);
            nuevoPaciente.setTelefono(telefono);
            nuevoPaciente.setEmail(userLogueado.getEmail());

            NombreCompleto nomComp = new NombreCompleto(nombre, apPaterno, apMaterno);
            nuevoPaciente.setNomCompP(nomComp);

            if(pacienteActual != null && pacienteActual.getFechaRegP() != null){
                nuevoPaciente.setFechaRegP(pacienteActual.getFechaRegP());
            }else{
                nuevoPaciente.setFechaRegP(new Date());
            }
            
            if (pacienteActual != null && pacienteActual.getHistorialClinico() != null) {
                nuevoPaciente.setHistorialClinico(pacienteActual.getHistorialClinico());
            } else {
                nuevoPaciente.setHistorialClinico(new ArrayList<>());
            }
            
            ArrayList<String> listaAlergias = new ArrayList<>();
            if (alergias != null && !alergias.trim().isEmpty()) {
                String[] items = alergias.split(",");
                for (String item : items) {
                    listaAlergias.add(item.trim());
                }
            }
            nuevoPaciente.setAlergias(listaAlergias);
            
            PacientesDAO dao = new PacientesDAO();
            boolean exito = dao.datosPaciente(nuevoPaciente);
            
            if(exito){
                session.setAttribute("pacienteLogueado", nuevoPaciente);
                response.sendRedirect("dashboard_paciente.jsp?status=success");
            }else{
                response.sendRedirect("dashboard_paciente.jsp?status=error");
            }
        }catch(Exception e){
            System.err.println("Error en el servlet: "+e.getMessage());
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
