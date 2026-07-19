/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import entity.DonHang;
import entity.ChiTietDonHang;
import util.DBContext;

public class DonHangDAO {

    public boolean createOrder(DonHang donHang, List<ChiTietDonHang> listChiTiet) {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            // 1. Lưu DonHang
            String sqlDH = "INSERT INTO DonHang (MaKhachHang, DiaChiGiao, TrangThai, TongTien) VALUES (?, ?, N'Chờ xác nhận', ?)";
            PreparedStatement psDH = conn.prepareStatement(sqlDH, Statement.RETURN_GENERATED_KEYS);
            psDH.setInt(1, donHang.getMaKhachHang());
            psDH.setString(2, donHang.getDiaChiGiao());
            psDH.setDouble(3, donHang.getTongTien());
            psDH.executeUpdate();

            ResultSet rsKeys = psDH.getGeneratedKeys();
            int maDH = 0;
            if (rsKeys.next()) {
                maDH = rsKeys.getInt(1);
            }

            // 2. Lưu ChiTietDonHang và Trừ Tồn Kho
            String sqlCT = "INSERT INTO ChiTietDonHang (MaDH, MaSP, SoLuong, DonGia) VALUES (?, ?, ?, ?)";
            PreparedStatement psCT = conn.prepareStatement(sqlCT);

            String sqlUpdateSP = "UPDATE SanPham SET SoLuongTon = SoLuongTon - ? WHERE MaSP = ?";
            PreparedStatement psUpdateSP = conn.prepareStatement(sqlUpdateSP);

            for (ChiTietDonHang ct : listChiTiet) {
                psCT.setInt(1, maDH);
                psCT.setInt(2, ct.getMaSP());
                psCT.setInt(3, ct.getSoLuong());
                psCT.setDouble(4, ct.getDonGia());
                psCT.executeUpdate();

                psUpdateSP.setInt(1, ct.getSoLuong());
                psUpdateSP.setInt(2, ct.getMaSP());
                psUpdateSP.executeUpdate();
            }

            // 3. Xóa giỏ hàng (ChiTietGioHang)
            String sqlXoaGioHang = "DELETE FROM ChiTietGioHang WHERE MaGioHang = (SELECT MaGioHang FROM GioHang WHERE MaKhachHang = ?)";
            PreparedStatement psXoaGH = conn.prepareStatement(sqlXoaGioHang);
            psXoaGH.setInt(1, donHang.getMaKhachHang());
            psXoaGH.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<DonHang> getOrdersByUser(int userId) {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT * FROM DonHang WHERE MaKhachHang = ? ORDER BY NgayDat DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DonHang dh = new DonHang();
                dh.setMaDH(rs.getInt("MaDH"));
                dh.setMaKhachHang(rs.getInt("MaKhachHang"));
                dh.setMaNhanVien(rs.getInt("MaNhanVien"));
                dh.setNgayDat(rs.getTimestamp("NgayDat"));
                dh.setDiaChiGiao(rs.getString("DiaChiGiao"));
                dh.setTrangThai(rs.getString("TrangThai"));
                dh.setTongTien(rs.getDouble("TongTien"));
                list.add(dh);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ChiTietDonHang> getOrderDetails(int orderId) {
        List<ChiTietDonHang> list = new ArrayList<>();
        // JOIN với SanPham để lấy thêm thông tin hiển thị (giả định Entity ChiTietDonHang có thuộc tính TenSP, HinhAnh)
        String sql = "SELECT ct.*, sp.TenSP, sp.HinhAnh FROM ChiTietDonHang ct JOIN SanPham sp ON ct.MaSP = sp.MaSP WHERE ct.MaDH = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ChiTietDonHang ct = new ChiTietDonHang();
                ct.setMaDH(rs.getInt("MaDH"));
                ct.setMaSP(rs.getInt("MaSP"));
                ct.setSoLuong(rs.getInt("SoLuong"));
                ct.setDonGia(rs.getDouble("DonGia"));
                // Các field mở rộng để hiển thị view
                // ct.setTenSP(rs.getString("TenSP"));
                // ct.setHinhAnh(rs.getString("HinhAnh"));
                list.add(ct);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DonHang> getAllOrders() {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT * FROM DonHang ORDER BY NgayDat DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DonHang dh = new DonHang();
                dh.setMaDH(rs.getInt("MaDH"));
                dh.setMaKhachHang(rs.getInt("MaKhachHang"));
                dh.setMaNhanVien(rs.getInt("MaNhanVien"));
                dh.setNgayDat(rs.getTimestamp("NgayDat"));
                dh.setDiaChiGiao(rs.getString("DiaChiGiao"));
                dh.setTrangThai(rs.getString("TrangThai"));
                dh.setTongTien(rs.getDouble("TongTien"));
                list.add(dh);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE DonHang SET TrangThai = ? WHERE MaDH = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();

            // Nếu đơn bị hủy, hoàn lại số lượng tồn kho
            if ("Đã hủy".equals(status)) {
                String sqlGetCT = "SELECT MaSP, SoLuong FROM ChiTietDonHang WHERE MaDH = ?";
                PreparedStatement psGetCT = conn.prepareStatement(sqlGetCT);
                psGetCT.setInt(1, orderId);
                ResultSet rs = psGetCT.executeQuery();

                String sqlUpdateSP = "UPDATE SanPham SET SoLuongTon = SoLuongTon + ? WHERE MaSP = ?";
                PreparedStatement psUpdateSP = conn.prepareStatement(sqlUpdateSP);
                while (rs.next()) {
                    psUpdateSP.setInt(1, rs.getInt("SoLuong"));
                    psUpdateSP.setInt(2, rs.getInt("MaSP"));
                    psUpdateSP.executeUpdate();
                }
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<Double[]> getRevenueByMonth() {
        List<Double[]> revenueList = new ArrayList<>();
        String sql = "SELECT MONTH(NgayDat) AS Thang, SUM(TongTien) AS DoanhThu "
                + "FROM DonHang WHERE TrangThai = N'Đã giao' AND YEAR(NgayDat) = YEAR(GETDATE()) "
                + "GROUP BY MONTH(NgayDat) ORDER BY MONTH(NgayDat)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Double[] data = new Double[2];
                data[0] = rs.getDouble("Thang");
                data[1] = rs.getDouble("DoanhThu");
                revenueList.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueList;
    }

    public List<Object[]> getTopSellingProducts() {
        List<Object[]> topProducts = new ArrayList<>();
        String sql = "SELECT TOP 5 sp.TenSP, SUM(ct.SoLuong) AS TongDaBan "
                + "FROM ChiTietDonHang ct JOIN SanPham sp ON ct.MaSP = sp.MaSP "
                + "JOIN DonHang dh ON ct.MaDH = dh.MaDH "
                + "WHERE dh.TrangThai != N'Đã hủy' "
                + "GROUP BY sp.TenSP ORDER BY TongDaBan DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("TenSP");
                row[1] = rs.getInt("TongDaBan");
                topProducts.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topProducts;
    }
}
