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
import java.math.BigDecimal;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "ChiTietDonHang")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ChiTietDonHang.findAll", query = "SELECT c FROM ChiTietDonHang c"),
    @NamedQuery(name = "ChiTietDonHang.findByMaDH", query = "SELECT c FROM ChiTietDonHang c WHERE c.chiTietDonHangPK.maDH = :maDH"),
    @NamedQuery(name = "ChiTietDonHang.findByMaSP", query = "SELECT c FROM ChiTietDonHang c WHERE c.chiTietDonHangPK.maSP = :maSP"),
    @NamedQuery(name = "ChiTietDonHang.findBySoLuong", query = "SELECT c FROM ChiTietDonHang c WHERE c.soLuong = :soLuong"),
    @NamedQuery(name = "ChiTietDonHang.findByDonGia", query = "SELECT c FROM ChiTietDonHang c WHERE c.donGia = :donGia"),
    @NamedQuery(name = "ChiTietDonHang.findByThanhTien", query = "SELECT c FROM ChiTietDonHang c WHERE c.thanhTien = :thanhTien")})
public class ChiTietDonHang implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Column(name = "SoLuong")
    private int soLuong;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "DonGia")
    private BigDecimal donGia;

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected ChiTietDonHangPK chiTietDonHangPK;
    // SQL Server tự tính ThanhTien = SoLuong * DonGia, nên JPA không được INSERT/UPDATE cột này.
    @Column(name = "ThanhTien", insertable = false, updatable = false)
    private BigDecimal thanhTien;
    @JoinColumn(name = "MaDH", referencedColumnName = "MaDH", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private DonHang donHang;
    @JoinColumn(name = "MaSP", referencedColumnName = "MaSP", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private SanPham sanPham;

    public ChiTietDonHang() {
    }

    public ChiTietDonHang(ChiTietDonHangPK chiTietDonHangPK) {
        this.chiTietDonHangPK = chiTietDonHangPK;
    }

    public ChiTietDonHang(ChiTietDonHangPK chiTietDonHangPK, int soLuong, BigDecimal donGia) {
        this.chiTietDonHangPK = chiTietDonHangPK;
        this.soLuong = soLuong;
        this.donGia = donGia;
    }

    public ChiTietDonHang(int maDH, int maSP) {
        this.chiTietDonHangPK = new ChiTietDonHangPK(maDH, maSP);
    }

    public ChiTietDonHangPK getChiTietDonHangPK() {
        return chiTietDonHangPK;
    }

    public void setChiTietDonHangPK(ChiTietDonHangPK chiTietDonHangPK) {
        this.chiTietDonHangPK = chiTietDonHangPK;
    }

    public BigDecimal getThanhTien() {
        return thanhTien;
    }

    public void setThanhTien(BigDecimal thanhTien) {
        this.thanhTien = thanhTien;
    }

    public DonHang getDonHang() {
        return donHang;
    }

    public void setDonHang(DonHang donHang) {
        this.donHang = donHang;
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
        hash += (chiTietDonHangPK != null ? chiTietDonHangPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ChiTietDonHang)) {
            return false;
        }
        ChiTietDonHang other = (ChiTietDonHang) object;
        if ((this.chiTietDonHangPK == null && other.chiTietDonHangPK != null) || (this.chiTietDonHangPK != null && !this.chiTietDonHangPK.equals(other.chiTietDonHangPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.ChiTietDonHang[ chiTietDonHangPK=" + chiTietDonHangPK + " ]";
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public BigDecimal getDonGia() {
        return donGia;
    }

    public void setDonGia(BigDecimal donGia) {
        this.donGia = donGia;
    }

}
