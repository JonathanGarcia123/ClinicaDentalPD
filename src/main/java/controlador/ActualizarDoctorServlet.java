/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import datos.DoctoresDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Doctores;
import modelo.HorarioDoctor;
import modelo.NombreCompleto;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "ActualizarDoctorServlet", urlPatterns = {"/ActualizarDoctorServlet"})
public class ActualizarDoctorServlet extends HttpServlet {

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
        
        if (userLogueado == null || !userLogueado.getFkRol().getNombreRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp?error=sesion");
            return;
        }
        
        try{
            String cedulaStr = request.getParameter("txtCedula");
            String activoStr = request.getParameter("cmbActivo");
            String nombre = request.getParameter("txtNomDoc");
            String apPaterno = request.getParameter("txtApPatDoc");
            String apMaterno = request.getParameter("txtApMatDoc");
            String especialidad = request.getParameter("cmbEspecialidad");
            String email = request.getParameter("txtEmailDoc");
            String telefono = request.getParameter("txtTelefono");
            String diasTrabajo = request.getParameter("cmbDiasTrabajo");
            String horaEntrada = request.getParameter("cmbHoraEntrada");
            String horaSalida = request.getParameter("cmbHoraSalida");
            
            int cedulaInt = Integer.parseInt(cedulaStr);
            DoctoresDAO dDAO = new DoctoresDAO();
            Doctores doctorExistente = dDAO.buscarPorCedula(cedulaInt);
            
            if(doctorExistente!=null){
                doctorExistente.setEspecialidad(especialidad);
                doctorExistente.setTelefono(telefono);
                boolean activo = Boolean.parseBoolean(activoStr);
                doctorExistente.setActivo(activo);
                
                NombreCompleto nomComp = new NombreCompleto(nombre, apPaterno, apMaterno);
                doctorExistente.setNomCompD(nomComp);
                
                HorarioDoctor horario = new HorarioDoctor(diasTrabajo, horaEntrada, horaSalida);
                doctorExistente.setHorarioDisp(horario);
                
                boolean actualizado = dDAO.actualizarDoctor(doctorExistente);
                
                if(actualizado){
                    response.sendRedirect("dashboard_admin.jsp?status=updateDocSuccess");
                }else{
                    response.sendRedirect("dashboard_admin.jsp?status=updateDocError");
                }
            }else{
                response.sendRedirect("dashboard_admin.jsp?status=docNotFound");
            } 
        }catch(Exception e){
            System.err.println("Error en el servlet Actualizar doctor: "+e.getMessage());
            response.sendRedirect("dashboard_admin.jsp?statuts=errorException");
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
