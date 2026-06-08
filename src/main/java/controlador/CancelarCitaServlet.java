/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import datos.AgendaDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuarios;
import org.bson.types.ObjectId;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "CancelarCitaServlet", urlPatterns = {"/CancelarCitaServlet"})
public class CancelarCitaServlet extends HttpServlet {

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
        Usuarios user = (Usuarios) session.getAttribute("usuarioLogueado");
        
        if (user == null) {
            response.sendRedirect("login.jsp?error=sesion");
            return;
        }

        try {
            String idCitaStr = request.getParameter("txtIdCita");
            String nuevoStatus = request.getParameter("cmbStatusCita");

            if (idCitaStr != null && "Cancelado".equalsIgnoreCase(nuevoStatus)) {
                
                AgendaDAO aDAO = new AgendaDAO();
                
                ObjectId idCita = new ObjectId(idCitaStr);
                
                var filtro = Filters.eq("_id", idCita);
                var actualizacion = Updates.set("status", "Cancelado");
               
                boolean exito = aDAO.actualizarEstatus(idCita, "Cancelado");

                if (exito) {
                    response.sendRedirect("dashboard_paciente.jsp?status=cancelSuccess");
                } else {
                    response.sendRedirect("dashboard_paciente.jsp?status=cancelError");
                }
            } else {
                response.sendRedirect("dashboard_paciente.jsp");
            }
        } catch (Exception e) {
            System.err.println("Error al cancelar cita: " + e.getMessage());
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
