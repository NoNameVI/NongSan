package controller;

import dao.NguoiDungDAO;
import entity.NguoiDung;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UserManageServlet", urlPatterns = {"/admin/users"})
public class UserManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        NguoiDungDAO dao = new NguoiDungDAO();
        List<NguoiDung> allUsers = dao.getAllUsers();
        
        // 1. Chức năng tìm kiếm
        String searchQuery = request.getParameter("search");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            final String keyword = searchQuery.toLowerCase().trim();
            allUsers = allUsers.stream()
                .filter(u -> u.getHoTen().toLowerCase().contains(keyword) 
                          || u.getEmail().toLowerCase().contains(keyword))
                .collect(Collectors.toList());
        }
        
        // 2. Chức năng phân trang
        int page = 1;
        int pageSize = 5; // Số lượng người dùng trên mỗi trang
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int totalItems = allUsers.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
        // Tính toán vị trí cắt danh sách
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        List<NguoiDung> paginatedUsers = allUsers.subList(start, end);
        
        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("listUsers", paginatedUsers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery);
        
        request.getRequestDispatcher("/adminusers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            if ("toggleStatus".equals(action)) {
                int maND = Integer.parseInt(request.getParameter("maND"));
                String currentStatus = request.getParameter("currentStatus");
                
                // Đảo ngược trạng thái
                String newStatus = "Khoa".equals(currentStatus) ? "Hoat dong" : "Khoa";
                
                NguoiDungDAO dao = new NguoiDungDAO();
                dao.updateUserStatus(maND, newStatus);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Sau khi xử lý xong, tải lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    @Override
    public String getServletInfo() {
        return "Admin User Management Servlet";
    }
}
