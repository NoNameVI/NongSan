package dao;

import entity.HinhAnhSanPham;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class HinhAnhSanPhamDAO {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");

    public List<HinhAnhSanPham> getImagesByProductId(int maSP) {
        EntityManager em = emf.createEntityManager();
        try {
            // Dùng JPQL để lấy danh sách ảnh theo maSP
            String jpql = "SELECT h FROM HinhAnhSanPham h WHERE h.sanPham.maSP = :maSP";
            TypedQuery<HinhAnhSanPham> query = em.createQuery(jpql, HinhAnhSanPham.class);
            query.setParameter("maSP", maSP);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}
