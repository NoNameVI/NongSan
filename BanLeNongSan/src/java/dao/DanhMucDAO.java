package dao;

import entity.DanhMuc;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class DanhMucDAO {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");

    public List<DanhMuc> getAllCategories() {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT d FROM DanhMuc d";
            TypedQuery<DanhMuc> query = em.createQuery(jpql, DanhMuc.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public DanhMuc getCategoryById(int maDanhMuc) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(DanhMuc.class, maDanhMuc);
        } finally {
            em.close();
        }
    }
}
