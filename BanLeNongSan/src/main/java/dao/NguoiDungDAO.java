/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.NguoiDung;
import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBContext;

/**
 *
 * @author asus
 */
public class NguoiDungDAO extends DBContext {

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
        NguoiDung u = new NguoiDung();
        String sql = "select * from NguoiDung\n"
                + "where Email =?  and MatKhau=?";
        try {
            PreparedStatement ps = conn.prepareCall(sql);
            ps.setString(1, email);
            ps.setString(2, hashMD5(pass));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u.setMaND(rs.getInt("MaND"));
                u.setEmail(rs.getString("Email"));
                u.setMatKhau(rs.getString("MatKhau"));
                u.setHoTen(rs.getString("HoTen"));
            }
        } catch (Exception e) {
        }
        return u;
    }

    public static void main(String[] args) {
        NguoiDungDAO dao = new NguoiDungDAO();
    }
}
