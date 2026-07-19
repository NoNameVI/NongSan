/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.ThanhToan;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 *
 * @author HoangNLHCE200759
 */
public class ThanhToanDAO {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");
    private final EntityManager em = emf.createEntityManager();

    public boolean createPayment(ThanhToan thanhToan) {
        try {
            em.getTransaction().begin();
            em.persist(thanhToan); // Ghi nhận thông tin thanh toán vào DB
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        }
    }

    public static void main(String[] args) {

    }
}
