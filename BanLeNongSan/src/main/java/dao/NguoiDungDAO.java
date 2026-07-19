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
            String jpql = "select n from NguoiDung n";
            TypedQuery<NguoiDung> tq = em.createQuery(jpql, NguoiDung.class);
            return tq.getResultList();
        } catch (Exception e) {
        }
        return null;
    }

    public NguoiDung getUserProfile(int MaND) {
        try {
            return em.find(NguoiDung.class, MaND);
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
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return null;
        } finally {

        }
        return null;
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

}
