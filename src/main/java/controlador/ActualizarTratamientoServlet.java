/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import datos.TratamientoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Tratamientos;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "ActualizarTratamientoServlet", urlPatterns = {"/ActualizarTratamientoServlet"})
public class ActualizarTratamientoServlet extends HttpServlet {

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
            String codProductoStr = request.getParameter("txtCodProducto");
            String nomTratamiento = request.getParameter("txtNombreTratamiento");
            String precioStr = request.getParameter("txtPrecioBase");
            String stockSrt = request.getParameter("txtStock");
            String fechaCaducidadStr = request.getParameter("txtFechaCaducidad");
            String DescServicio = request.getParameter("txtDescripcion");
            
            int codProducto = Integer.parseInt(codProductoStr);
            TratamientoDAO tDAO = new TratamientoDAO();
            Tratamientos tratamientoExiste = tDAO.buscarPorCodigo(codProducto);
            
            if(tratamientoExiste!=null){
                tratamientoExiste.setCodProducto(codProducto);
                tratamientoExiste.setNombre(nomTratamiento);
                double precio = Double.parseDouble(precioStr);
                tratamientoExiste.setPrecioBase(precio);
                int stock = Integer.parseInt(stockSrt);
                tratamientoExiste.setStock(stock);
                java.text.SimpleDateFormat formato = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.util.Date fechaCaducidad = formato.parse(fechaCaducidadStr);
                tratamientoExiste.setFechaCaducidad(fechaCaducidad);
                tratamientoExiste.setDescription(DescServicio);
                
                boolean actualizado = tDAO.actualizarTratamiento(tratamientoExiste);
                
                if(actualizado){
                    response.sendRedirect("dashboard_admin.jsp?status=updateTreatSuccess");
                }else{
                    response.sendRedirect("dashboard_admin.jsp?status=updateDocError");
                }
            }else{
                response.sendRedirect("dashboard_admin.jsp?status=updateDocError");
            }
        }catch(Exception e){
            System.err.println("Error al actualizar el tratamiento: "+e.getMessage());
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
