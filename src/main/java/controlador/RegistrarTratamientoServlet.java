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
import java.time.LocalDate;
import java.util.Date;
import modelo.Tratamientos;
import modelo.Usuarios;

/**
 *
 * @author jonyx
 */
@WebServlet(name = "RegistrarTratamientoServlet", urlPatterns = {"/RegistrarTratamientoServlet"})
public class RegistrarTratamientoServlet extends HttpServlet {

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
            String codProductoStr = request.getParameter("txtCodProducto");
            String nomTratamiento = request.getParameter("txtNombreTratamiento");
            String precioStr = request.getParameter("txtPrecioBase");
            String stockSrt = request.getParameter("txtStock");
            String fechaCaducidadStr = request.getParameter("txtFechaCaducidad");
            String DescServicio = request.getParameter("txtDescripcion");
            String tipo = request.getParameter("cmbTipo");
            
            Tratamientos nuevoTratamiento = new Tratamientos();
            
            if(fechaCaducidadStr!=null && !fechaCaducidadStr.trim().isEmpty()){
                java.text.SimpleDateFormat formato = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.util.Date fechaCaducidad = formato.parse(fechaCaducidadStr);
                nuevoTratamiento.setFechaCaducidad(fechaCaducidad);
            }else{
                nuevoTratamiento.setFechaCaducidad(null);
            }
            
            if(stockSrt!=null && !stockSrt.trim().isEmpty()){
                int stock = Integer.parseInt(stockSrt);
                nuevoTratamiento.setStock(stock);
            }else{
                nuevoTratamiento.setStock(null);
            }
            
            int codProducto = Integer.parseInt(codProductoStr);
            nuevoTratamiento.setCodProducto(codProducto);
            nuevoTratamiento.setNombre(nomTratamiento);
            double precio = Double.parseDouble(precioStr);
            nuevoTratamiento.setPrecioBase(precio);
            nuevoTratamiento.setDescription(DescServicio);
            nuevoTratamiento.setTipo(tipo);
            
            TratamientoDAO tDAO = new TratamientoDAO();
            boolean tratamientoInsertado = tDAO.insertarTratamiento(nuevoTratamiento);
            
            if(tratamientoInsertado){
                response.sendRedirect("dashboard_admin.jsp?status=treatSuccess");
            }else{
                response.sendRedirect("dashboard_admin.jsp?status=errorInsertTratamiento");
            }
        }catch(Exception e){
            System.err.println("Error en RegistrarTratamientoServlet: "+e.getMessage());
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
