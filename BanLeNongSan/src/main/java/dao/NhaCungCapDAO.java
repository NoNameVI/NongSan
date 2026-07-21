package dao;

import entity.NhaCungCap;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class NhaCungCapDAO {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");

    public List<NhaCungCap> getAllSuppliers() {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT n FROM NhaCungCap n";
            TypedQuery<NhaCungCap> query = em.createQuery(jpql, NhaCungCap.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public NhaCungCap getSupplierById(int maNhaCungCap) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(NhaCungCap.class, maNhaCungCap);
        } finally {
            em.close();
        }
    }
}
