package dao;

import entity.ChiTietGioHang;
import entity.ChiTietGioHangPK;
import entity.GioHang;
import entity.NguoiDung;
import entity.SanPham;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class GioHangDAO {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("my_persistence_unit");
    private final EntityManager em = emf.createEntityManager();

    // Hàm hỗ trợ: Lấy giỏ hàng của User, nếu chưa có thì tự động tạo mới
    public GioHang getOrCreateCart(int userId) {
        String jpql = "SELECT g FROM GioHang g WHERE g.maKhachHang.maND = :userId";
        List<GioHang> carts = em.createQuery(jpql, GioHang.class)
                .setParameter("userId", userId)
                .getResultList();
        if (!carts.isEmpty()) {
            return carts.get(0);
        }

        // Tạo giỏ hàng mới nếu user chưa có
        em.getTransaction().begin();
        GioHang newCart = new GioHang();
        NguoiDung user = em.find(NguoiDung.class, userId);
        newCart.setMaKhachHang(user);
        em.persist(newCart);
        em.getTransaction().commit();

        return newCart;
    }

    public List<ChiTietGioHang> getCartItems(int userId) {
        String jpql = "SELECT c FROM ChiTietGioHang c WHERE c.gioHang.maKhachHang.maND = :userId";
        return em.createQuery(jpql, ChiTietGioHang.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public void addToCart(int userId, int productId, int quantity) {
        GioHang cart = getOrCreateCart(userId);
        ChiTietGioHangPK pk = new ChiTietGioHangPK(cart.getMaGioHang(), productId);
        ChiTietGioHang item = em.find(ChiTietGioHang.class, pk);

        em.getTransaction().begin();
        if (item != null) {
            // Đã có trong giỏ -> Cộng dồn số lượng
            item.setSoLuong(item.getSoLuong() + quantity);
            em.merge(item);
        } else {
            // Chưa có trong giỏ -> Thêm mới
            item = new ChiTietGioHang(pk, quantity);
            item.setGioHang(cart);
            item.setSanPham(em.find(SanPham.class, productId));
            em.persist(item);
        }
        em.getTransaction().commit();
    }

    public void updateCartQuantity(int userId, int productId, int quantity) {
        GioHang cart = getOrCreateCart(userId);
        ChiTietGioHangPK pk = new ChiTietGioHangPK(cart.getMaGioHang(), productId);
        ChiTietGioHang item = em.find(ChiTietGioHang.class, pk);

        if (item != null) {
            em.getTransaction().begin();
            if (quantity <= 0) {
                em.remove(item); // Nếu update số lượng về 0 thì xóa luôn
            } else {
                item.setSoLuong(quantity);
                em.merge(item);
            }
            em.getTransaction().commit();
        }
    }

    public void removeFromCart(int userId, int productId) {
        GioHang cart = getOrCreateCart(userId);
        ChiTietGioHangPK pk = new ChiTietGioHangPK(cart.getMaGioHang(), productId);
        ChiTietGioHang item = em.find(ChiTietGioHang.class, pk);

        if (item != null) {
            em.getTransaction().begin();
            em.remove(item);
            em.getTransaction().commit();
        }
    }

    public void clearCart(int userId) {
        GioHang cart = getOrCreateCart(userId);
        em.getTransaction().begin();
        String jpql = "DELETE FROM ChiTietGioHang c WHERE c.chiTietGioHangPK.maGioHang = :cartId";
        em.createQuery(jpql).setParameter("cartId", cart.getMaGioHang()).executeUpdate();
        em.getTransaction().commit();
    }

    public static void main(String[] args) {

    }
}
