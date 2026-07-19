/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "SanPham")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "SanPham.findAll", query = "SELECT s FROM SanPham s"),
    @NamedQuery(name = "SanPham.findByMaSP", query = "SELECT s FROM SanPham s WHERE s.maSP = :maSP"),
    @NamedQuery(name = "SanPham.findByTenSP", query = "SELECT s FROM SanPham s WHERE s.tenSP = :tenSP"),
    @NamedQuery(name = "SanPham.findByDonGia", query = "SELECT s FROM SanPham s WHERE s.donGia = :donGia"),
    @NamedQuery(name = "SanPham.findByDonViTinh", query = "SELECT s FROM SanPham s WHERE s.donViTinh = :donViTinh"),
    @NamedQuery(name = "SanPham.findBySoLuongTon", query = "SELECT s FROM SanPham s WHERE s.soLuongTon = :soLuongTon"),
    @NamedQuery(name = "SanPham.findByMoTa", query = "SELECT s FROM SanPham s WHERE s.moTa = :moTa"),
    @NamedQuery(name = "SanPham.findByHinhAnh", query = "SELECT s FROM SanPham s WHERE s.hinhAnh = :hinhAnh"),
    @NamedQuery(name = "SanPham.findByNgayNhap", query = "SELECT s FROM SanPham s WHERE s.ngayNhap = :ngayNhap"),
    @NamedQuery(name = "SanPham.findByTrangThai", query = "SELECT s FROM SanPham s WHERE s.trangThai = :trangThai")})
public class SanPham implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaSP")
    private Integer maSP;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "TenSP")
    private String tenSP;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "DonGia")
    private BigDecimal donGia;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "DonViTinh")
    private String donViTinh;
    @Basic(optional = false)
    @NotNull
    @Column(name = "SoLuongTon")
    private int soLuongTon;
    @Size(max = 255)
    @Column(name = "MoTa")
    private String moTa;
    @Size(max = 255)
    @Column(name = "HinhAnh")
    private String hinhAnh;
    @Column(name = "NgayNhap")
    @Temporal(TemporalType.DATE)
    private Date ngayNhap;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "TrangThai")
    private String trangThai;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "maSP")
    private Collection<DanhGia> danhGiaCollection;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "maSP")
    private HinhAnhSanPham hinhAnhSanPham;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "sanPham")
    private Collection<ChiTietDonHang> chiTietDonHangCollection;
    @JoinColumn(name = "MaDanhMuc", referencedColumnName = "MaDanhMuc")
    @ManyToOne(optional = false)
    private DanhMuc maDanhMuc;
    @JoinColumn(name = "MaNCC", referencedColumnName = "MaNCC")
    @ManyToOne
    private NhaCungCap maNCC;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "sanPham")
    private Collection<ChiTietGioHang> chiTietGioHangCollection;

    public SanPham() {
    }

    public SanPham(Integer maSP) {
        this.maSP = maSP;
    }

    public SanPham(Integer maSP, String tenSP, BigDecimal donGia, String donViTinh, int soLuongTon, String trangThai) {
        this.maSP = maSP;
        this.tenSP = tenSP;
        this.donGia = donGia;
        this.donViTinh = donViTinh;
        this.soLuongTon = soLuongTon;
        this.trangThai = trangThai;
    }

    public Integer getMaSP() {
        return maSP;
    }

    public void setMaSP(Integer maSP) {
        this.maSP = maSP;
    }

    public String getTenSP() {
        return tenSP;
    }

    public void setTenSP(String tenSP) {
        this.tenSP = tenSP;
    }

    public BigDecimal getDonGia() {
        return donGia;
    }

    public void setDonGia(BigDecimal donGia) {
        this.donGia = donGia;
    }

    public String getDonViTinh() {
        return donViTinh;
    }

    public void setDonViTinh(String donViTinh) {
        this.donViTinh = donViTinh;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    public Date getNgayNhap() {
        return ngayNhap;
    }

    public void setNgayNhap(Date ngayNhap) {
        this.ngayNhap = ngayNhap;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    @XmlTransient
    public Collection<DanhGia> getDanhGiaCollection() {
        return danhGiaCollection;
    }

    public void setDanhGiaCollection(Collection<DanhGia> danhGiaCollection) {
        this.danhGiaCollection = danhGiaCollection;
    }

    public HinhAnhSanPham getHinhAnhSanPham() {
        return hinhAnhSanPham;
    }

    public void setHinhAnhSanPham(HinhAnhSanPham hinhAnhSanPham) {
        this.hinhAnhSanPham = hinhAnhSanPham;
    }

    @XmlTransient
    public Collection<ChiTietDonHang> getChiTietDonHangCollection() {
        return chiTietDonHangCollection;
    }

    public void setChiTietDonHangCollection(Collection<ChiTietDonHang> chiTietDonHangCollection) {
        this.chiTietDonHangCollection = chiTietDonHangCollection;
    }

    public DanhMuc getMaDanhMuc() {
        return maDanhMuc;
    }

    public void setMaDanhMuc(DanhMuc maDanhMuc) {
        this.maDanhMuc = maDanhMuc;
    }

    public NhaCungCap getMaNCC() {
        return maNCC;
    }

    public void setMaNCC(NhaCungCap maNCC) {
        this.maNCC = maNCC;
    }

    @XmlTransient
    public Collection<ChiTietGioHang> getChiTietGioHangCollection() {
        return chiTietGioHangCollection;
    }

    public void setChiTietGioHangCollection(Collection<ChiTietGioHang> chiTietGioHangCollection) {
        this.chiTietGioHangCollection = chiTietGioHangCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (maSP != null ? maSP.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof SanPham)) {
            return false;
        }
        SanPham other = (SanPham) object;
        if ((this.maSP == null && other.maSP != null) || (this.maSP != null && !this.maSP.equals(other.maSP))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.SanPham[ maSP=" + maSP + " ]";
    }

}
