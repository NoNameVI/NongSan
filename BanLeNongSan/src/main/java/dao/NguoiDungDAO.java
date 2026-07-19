/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.NguoiDung;
import entity.VaiTro;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import util.DBContext;

/**
 *
 * @author asus
 */
public class NguoiDungDAO extends DBContext {

    EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");
    EntityManager em = emf.createEntityManager();

    public String hashMD5(String pass) {
        String hash = "";
        try {
            MessageDigest md = MessageDigest.getInstance("md5");
            byte[] bytes = md.digest(pass.getBytes());
            for (byte b : bytes) {
                hash += String.format("%02x", b);
            }
        } catch (Exception e) {
        }
        return hash;
    }

    public NguoiDung login(String email, String pass) {
        try {

            String jpql = "SELECT n FROM NguoiDung n WHERE n.email = :email AND n.matKhau = :pass";
            TypedQuery<NguoiDung> query = em.createQuery(jpql, NguoiDung.class);
            query.setParameter("email", email);
            query.setParameter("pass", hashMD5(pass));

            NguoiDung u = query.getSingleResult();
            if (u != null) {
                return u;
            }

        } catch (jakarta.persistence.NoResultException e) {
            System.out.println("Không tìm thấy tài khoản với email này hoặc sai mật khẩu.");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<NguoiDung> getAllUsers() {
        try {
            // Thêm điều kiện WHERE để loại bỏ người dùng có maVaiTro = 3
            String jpql = "SELECT n FROM NguoiDung n WHERE n.maVaiTro.maVaiTro <> 3";
            TypedQuery<NguoiDung> tq = em.createQuery(jpql, NguoiDung.class);
            return tq.getResultList();
        } catch (Exception e) {
            e.printStackTrace(); // Nên in log lỗi thay vì để trống
        }
        return null;
    }

    public NguoiDung getUserProfile(int MaND) {
        try {
            // Lấy thông tin người dùng bằng khóa chính
            NguoiDung user = em.find(NguoiDung.class, MaND);

            // Kiểm tra nếu user tồn tại và có vai trò là 3 thì từ chối trả về dữ liệu (return null)
            if (user != null && user.getMaVaiTro() != null && user.getMaVaiTro().getMaVaiTro() == 3) {
                return null;
            }

            return user;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateProfile(NguoiDung nguoidung) {
        try {
            em.getTransaction().begin();
            em.merge(nguoidung);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    public NguoiDung registerUser(NguoiDung nguoidung) {
        try {
            em.getTransaction().begin();
            em.persist(nguoidung);
            em.getTransaction().commit();
            return nguoidung; // Đổi từ return null thành return đối tượng
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateUserStatus(int MaND, String TrangThai) {
        try {
            NguoiDung u = em.find(NguoiDung.class, MaND);
            u.setTrangThai(TrangThai);
            em.getTransaction().begin();
            em.merge(u);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        }
        return false;
    }

//    public static void main(String[] args) {
//        NguoiDungDAO dao = new NguoiDungDAO();
//        NguoiDung nd = new NguoiDung();
//
//        // 1. Điền các thông tin bắt buộc (NOT NULL)[cite: 4]
//        nd.setMaND(8);
//        nd.setHoTen("Nguyễn Văn Thức");
//        nd.setEmail("thucn@gmail.com");
//        nd.setMatKhau(dao.hashMD5("123456")); // Bắt buộc phải hash mật khẩu
//        nd.setTrangThai("Khoa");
//
//        // 2. Điền các thông tin bổ sung
//        nd.setSdt("0123456789");
//        nd.setDiaChi("Hồ Chí Minh");
//        nd.setNgayTao(new Date());
//
//        // 3. Khởi tạo và gán khóa ngoại VaiTro (Bắt buộc)[cite: 4]
//        // Giả sử MaVaiTro = 1 (Khách hàng) đã tồn tại trong Database
//        VaiTro vaiTro = new VaiTro(1);
//        nd.setMaVaiTro(vaiTro);
//
//        // 4. Thực thi test
//        System.out.println("Đang tiến hành insert dữ liệu...");
//        NguoiDung result = dao.registerUser(nd);
//        if (result != null) {
//            System.out.println("Insert thành công!");
//        } else {
//            System.out.println("Insert thất bại do lỗi phía Database (xem log Exception).");
//        }
//    }
}
