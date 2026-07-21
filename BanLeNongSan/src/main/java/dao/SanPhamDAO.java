package dao;

import entity.SanPham;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class SanPhamDAO {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");

    public List<SanPham> getAllProducts() {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT s FROM SanPham s";
            TypedQuery<SanPham> query = em.createQuery(jpql, SanPham.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<SanPham> getAllProductsAvailable() {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT s FROM SanPham s WHERE s.trangThai = 'Con hang'";
            TypedQuery<SanPham> query = em.createQuery(jpql, SanPham.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<SanPham> search(String keyword) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT s FROM SanPham s WHERE LOWER(s.tenSP) LIKE LOWER(:keyword) AND s.trangThai = 'Con hang'";
            TypedQuery<SanPham> query = em.createQuery(jpql, SanPham.class);
            query.setParameter("keyword", "%" + keyword + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<SanPham> getProductsByCategory(int maDanhMuc) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT s FROM SanPham s WHERE s.maDanhMuc.maDanhMuc = :maDM AND s.trangThai = 'Con hang'";
            TypedQuery<SanPham> query = em.createQuery(jpql, SanPham.class);
            query.setParameter("maDM", maDanhMuc);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public SanPham getProductById(int maSP) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(SanPham.class, maSP);
        } finally {
            em.close();
        }
    }

    public boolean insertProduct(SanPham sp) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            sp.setTrangThai("Con hang");
            em.persist(sp);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

    public boolean updateProduct(SanPham sp) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(sp);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

    public boolean updateStatus(int maSP, String trangThaiMoi) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            SanPham sp = em.find(SanPham.class, maSP);
            if (sp != null) {
                sp.setTrangThai(trangThaiMoi);
                em.merge(sp);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

    public boolean deleteProduct(int maSP) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            SanPham sp = em.find(SanPham.class, maSP);
            if (sp != null) {
                sp.setTrangThai("Ngung ban"); // Cập nhật trạng thái
                em.merge(sp); // Lưu thay đổi
                em.getTransaction().commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

}
