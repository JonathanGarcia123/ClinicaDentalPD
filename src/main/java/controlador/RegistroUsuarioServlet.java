/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import datos.RolesDAO;
import datos.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Roles;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroUsuarioServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RolesDAO rDAO = new RolesDAO();
        String email = request.getParameter("txtEmail");
        String pass = request.getParameter("txtPassword");
        
        Roles rolNuevoUsuario = rDAO.buscarPorNombre("Paciente");
        
        if(rolNuevoUsuario==null){
            response.sendRedirect("registro.jsp?error=rol_no_encontrado");
            return;
        }
        
        Usuarios nuevoUser = new Usuarios();
        nuevoUser.setEmail(email);
        String passCifrada = datos.Encriptar.sha256(pass);
        nuevoUser.setPassword(passCifrada);
        nuevoUser.setFkRol(rolNuevoUsuario);
        
        UsuarioDAO uDAO = new UsuarioDAO();
        boolean exito = uDAO.registrarUsuario(nuevoUser);
        
        if(exito){
            response.sendRedirect("login.jsp?msj=resgistrado");
        }else{
            response.sendRedirect("registro.jsp?error=1");
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