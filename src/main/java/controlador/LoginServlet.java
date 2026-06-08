/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import datos.PacientesDAO;
import datos.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

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
        
        String email = request.getParameter("txtEmail");
        String pass = request.getParameter("txtPassword");
        
        UsuarioDAO uDAO = new UsuarioDAO();
        
        Usuarios encontrado = uDAO.login(email,pass);
        
        if(encontrado!=null){
            jakarta.servlet.http.HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado",encontrado);
            
            String rol = encontrado.getFkRol().getNombreRol();
            
            if(rol.equalsIgnoreCase("Administrador")){
                response.sendRedirect("dashboard_admin.jsp");
            }else if(rol.equalsIgnoreCase("Paciente")){
                PacientesDAO pDAO = new PacientesDAO();
            
                modelo.Pacientes pacienteExiste = pDAO.buscarPorEmail(encontrado.getEmail());

                if(pacienteExiste != null){
                    session.setAttribute("pacienteLogueado", pacienteExiste);
                }
                response.sendRedirect("dashboard_paciente.jsp");
            }else if(rol.equalsIgnoreCase("Doctor")){
                response.sendRedirect("dashboard_doctor.jsp");
            }
        
        }else{
            response.sendRedirect("registro.jsp?error=CredencialesIncorrectas");
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
