package controlador;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import datos.DoctoresDAO;
import datos.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Date;
import modelo.Doctores;
import modelo.HorarioDoctor;
import modelo.NombreCompleto;
import modelo.Roles;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(urlPatterns = {"/RegistrarDoctorServlet"})
public class RegistrarDoctorServlet extends HttpServlet {

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
            return;
        }
        
        try{
            String cedulaStr = request.getParameter("txtCedula");
            String nombre = request.getParameter("txtNomDoc");
            String apPaterno = request.getParameter("txtApPatDoc");
            String apMaterno = request.getParameter("txtApMatDoc");
            String especialidad = request.getParameter("cmbEspecialidad");
            String email = request.getParameter("txtEmailDoc");
            String telefono = request.getParameter("txtTelefono");
            String diasTrabajo = request.getParameter("cmbDiasTrabajo");
            String horaEntrada = request.getParameter("cmbHoraEntrada");
            String horaSalida = request.getParameter("cmbHoraSalida");
            String passwordDoc = request.getParameter("txtPasswordDoc");
            String consultorioStr = request.getParameter("cmbConsultorio");
             
            Usuarios nuevoUsuario = new Usuarios();
            String passCifrada = datos.Encriptar.sha256(passwordDoc);
            nuevoUsuario.setEmail(email);
            nuevoUsuario.setPassword(passCifrada);
            
            Roles rolDoctor = new Roles();
            rolDoctor.setNombreRol("Doctor");
            nuevoUsuario.setFkRol(rolDoctor);
            
            UsuarioDAO uDAO = new UsuarioDAO();
            boolean usuarioCreado = uDAO.registrarUsuario(nuevoUsuario);
            
            if(usuarioCreado){
                Doctores nuevoDoc = new Doctores();
                
                int cedula = Integer.parseInt(cedulaStr);
                nuevoDoc.setCedulaProf(cedula);
                nuevoDoc.setEspecialidad(especialidad);
                nuevoDoc.setEmail(email);
                nuevoDoc.setTelefono(telefono);
                nuevoDoc.setFechaReg(new Date());
                nuevoDoc.setActivo(true);
                int consultorio = Integer.parseInt(consultorioStr);
                nuevoDoc.setConsultorio(consultorio);
                
                NombreCompleto nomComp = new NombreCompleto(nombre, apPaterno, apMaterno);
                nuevoDoc.setNomCompD(nomComp);
                
                HorarioDoctor horario = new HorarioDoctor(diasTrabajo, horaEntrada, horaSalida);
                nuevoDoc.setHorarioDisp(horario);
                
                DoctoresDAO dDAO = new DoctoresDAO();
                boolean doctorInsertado = dDAO.insertarDoctor(nuevoDoc);
                
                if (doctorInsertado) {
                    response.sendRedirect("dashboard_admin.jsp?status=docSuccess");
                } else {
                    response.sendRedirect("dashboard_admin.jsp?status=docErrorPerfil");
                }
                
            }else {
                response.sendRedirect("dashboard_admin.jsp?status=docErrorUsuario");
            }
        }catch (Exception e) {
            System.err.println("Error en RegistrarDoctorServlet: " + e.getMessage());
            response.sendRedirect("dashboard_admin.jsp?status=errorException");
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
