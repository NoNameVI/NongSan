package dao;

import entity.ChiTietGioHang;
import entity.ChiTietGioHangPK;
import entity.GioHang;
import entity.NguoiDung;
import entity.SanPham;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.Collections;
import java.util.List;

public class GioHangDAO {

    private static final EntityManagerFactory EMF
            = Persistence.createEntityManagerFactory("my_persistence_unit");

    public List<ChiTietGioHang> getCartItems(int userId) {
        EntityManager em = EMF.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM ChiTietGioHang c "
                    + "JOIN FETCH c.sanPham "
                    + "WHERE c.gioHang.maKhachHang.maND = :userId",
                    ChiTietGioHang.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } catch (Exception ex) {
            ex.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public void addToCart(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return;
        }

        EntityManager em = EMF.createEntityManager();
        try {
            em.getTransaction().begin();

            GioHang cart = getOrCreateCart(em, userId);
            SanPham product = em.find(SanPham.class, productId);
            if (product == null) {
                throw new IllegalArgumentException("Sản phẩm không tồn tại");
            }

            ChiTietGioHangPK pk
                    = new ChiTietGioHangPK(cart.getMaGioHang(), productId);
            ChiTietGioHang item = em.find(ChiTietGioHang.class, pk);

            if (item == null) {
                item = new ChiTietGioHang(pk, quantity);
                item.setGioHang(cart);
                item.setSanPham(product);
                em.persist(item);
            } else {
                item.setSoLuong(item.getSoLuong() + quantity);
            }

            em.getTransaction().commit();
        } catch (Exception ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    public void updateCartQuantity(int userId, int productId, int quantity) {
        EntityManager em = EMF.createEntityManager();
        try {
            em.getTransaction().begin();

            GioHang cart = findCart(em, userId);
            if (cart != null) {
                ChiTietGioHangPK pk
                        = new ChiTietGioHangPK(cart.getMaGioHang(), productId);
                ChiTietGioHang item = em.find(ChiTietGioHang.class, pk);

                if (item != null) {
                    if (quantity <= 0) {
                        em.remove(item);
                    } else {
                        item.setSoLuong(quantity);
                    }
                }
            }

            em.getTransaction().commit();
        } catch (Exception ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    public void removeFromCart(int userId, int productId) {
        updateCartQuantity(userId, productId, 0);
    }

    public void clearCart(int userId) {
        EntityManager em = EMF.createEntityManager();
        try {
            em.getTransaction().begin();

            em.createQuery(
                    "DELETE FROM ChiTietGioHang c "
                    + "WHERE c.gioHang.maKhachHang.maND = :userId")
                    .setParameter("userId", userId)
                    .executeUpdate();

            em.getTransaction().commit();
        } catch (Exception ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    private GioHang getOrCreateCart(EntityManager em, int userId) {
        GioHang cart = findCart(em, userId);
        if (cart != null) {
            return cart;
        }

        NguoiDung user = em.find(NguoiDung.class, userId);
        if (user == null) {
            throw new IllegalArgumentException("Người dùng không tồn tại");
        }

        cart = new GioHang();
        cart.setMaKhachHang(user);
        em.persist(cart);
        em.flush();
        return cart;
    }

    private GioHang findCart(EntityManager em, int userId) {
        List<GioHang> carts = em.createQuery(
                "SELECT g FROM GioHang g WHERE g.maKhachHang.maND = :userId",
                GioHang.class)
                .setParameter("userId", userId)
                .setMaxResults(1)
                .getResultList();

        return carts.isEmpty() ? null : carts.get(0);
    }

    private void rollback(EntityManager em) {
        if (em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
    }
}
