/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "ChiTietGioHang")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ChiTietGioHang.findAll", query = "SELECT c FROM ChiTietGioHang c"),
    @NamedQuery(name = "ChiTietGioHang.findByMaGioHang", query = "SELECT c FROM ChiTietGioHang c WHERE c.chiTietGioHangPK.maGioHang = :maGioHang"),
    @NamedQuery(name = "ChiTietGioHang.findByMaSP", query = "SELECT c FROM ChiTietGioHang c WHERE c.chiTietGioHangPK.maSP = :maSP"),
    @NamedQuery(name = "ChiTietGioHang.findBySoLuong", query = "SELECT c FROM ChiTietGioHang c WHERE c.soLuong = :soLuong")})
public class ChiTietGioHang implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected ChiTietGioHangPK chiTietGioHangPK;
    @Basic(optional = false)
    @NotNull
    @Column(name = "SoLuong")
    private int soLuong;
    @JoinColumn(name = "MaGioHang", referencedColumnName = "MaGioHang", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private GioHang gioHang;
    @JoinColumn(name = "MaSP", referencedColumnName = "MaSP", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private SanPham sanPham;

    public ChiTietGioHang() {
    }

    public ChiTietGioHang(ChiTietGioHangPK chiTietGioHangPK) {
        this.chiTietGioHangPK = chiTietGioHangPK;
    }

    public ChiTietGioHang(ChiTietGioHangPK chiTietGioHangPK, int soLuong) {
        this.chiTietGioHangPK = chiTietGioHangPK;
        this.soLuong = soLuong;
    }

    public ChiTietGioHang(int maGioHang, int maSP) {
        this.chiTietGioHangPK = new ChiTietGioHangPK(maGioHang, maSP);
    }

    public ChiTietGioHangPK getChiTietGioHangPK() {
        return chiTietGioHangPK;
    }

    public void setChiTietGioHangPK(ChiTietGioHangPK chiTietGioHangPK) {
        this.chiTietGioHangPK = chiTietGioHangPK;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public GioHang getGioHang() {
        return gioHang;
    }

    public void setGioHang(GioHang gioHang) {
        this.gioHang = gioHang;
    }

    public SanPham getSanPham() {
        return sanPham;
    }

    public void setSanPham(SanPham sanPham) {
        this.sanPham = sanPham;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (chiTietGioHangPK != null ? chiTietGioHangPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ChiTietGioHang)) {
            return false;
        }
        ChiTietGioHang other = (ChiTietGioHang) object;
        if ((this.chiTietGioHangPK == null && other.chiTietGioHangPK != null) || (this.chiTietGioHangPK != null && !this.chiTietGioHangPK.equals(other.chiTietGioHangPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.ChiTietGioHang[ chiTietGioHangPK=" + chiTietGioHangPK + " ]";
    }

}
