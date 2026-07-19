package dao;

import entity.DanhGia;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class DanhGiaDAO {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");
    public List<DanhGia> getReviewsByProduct(int maSP) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT d FROM DanhGia d WHERE d.maSP.maSP = :maSP ORDER BY d.ngayDanhGia DESC";
            TypedQuery<DanhGia> query = em.createQuery(jpql, DanhGia.class);
            query.setParameter("maSP", maSP);
            return query.getResultList();
        } finally {
        }
    }
    public boolean insertReview(DanhGia danhGia) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(danhGia);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {

        }
    }
}
