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
@Table(name = "DonHang")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "DonHang.findAll", query = "SELECT d FROM DonHang d"),
    @NamedQuery(name = "DonHang.findByMaDH", query = "SELECT d FROM DonHang d WHERE d.maDH = :maDH"),
    @NamedQuery(name = "DonHang.findByNgayDat", query = "SELECT d FROM DonHang d WHERE d.ngayDat = :ngayDat"),
    @NamedQuery(name = "DonHang.findByDiaChiGiao", query = "SELECT d FROM DonHang d WHERE d.diaChiGiao = :diaChiGiao"),
    @NamedQuery(name = "DonHang.findByTrangThai", query = "SELECT d FROM DonHang d WHERE d.trangThai = :trangThai"),
    @NamedQuery(name = "DonHang.findByTongTien", query = "SELECT d FROM DonHang d WHERE d.tongTien = :tongTien")})
public class DonHang implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaDH")
    private Integer maDH;
    @Column(name = "NgayDat")
    @Temporal(TemporalType.TIMESTAMP)
    private Date ngayDat;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "DiaChiGiao")
    private String diaChiGiao;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "TrangThai")
    private String trangThai;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "TongTien")
    private BigDecimal tongTien;
    @JoinColumn(name = "MaKhachHang", referencedColumnName = "MaND")
    @ManyToOne(optional = false)
    private NguoiDung maKhachHang;
    @JoinColumn(name = "MaNhanVien", referencedColumnName = "MaND")
    @ManyToOne
    private NguoiDung maNhanVien;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "donHang")
    private Collection<ChiTietDonHang> chiTietDonHangCollection;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "maDH")
    private ThanhToan thanhToan;

    public DonHang() {
    }

    public DonHang(Integer maDH) {
        this.maDH = maDH;
    }

    public DonHang(Integer maDH, String diaChiGiao, String trangThai, BigDecimal tongTien) {
        this.maDH = maDH;
        this.diaChiGiao = diaChiGiao;
        this.trangThai = trangThai;
        this.tongTien = tongTien;
    }

    public Integer getMaDH() {
        return maDH;
    }

    public void setMaDH(Integer maDH) {
        this.maDH = maDH;
    }

    public Date getNgayDat() {
        return ngayDat;
    }

    public void setNgayDat(Date ngayDat) {
        this.ngayDat = ngayDat;
    }

    public String getDiaChiGiao() {
        return diaChiGiao;
    }

    public void setDiaChiGiao(String diaChiGiao) {
        this.diaChiGiao = diaChiGiao;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public NguoiDung getMaKhachHang() {
        return maKhachHang;
    }

    public void setMaKhachHang(NguoiDung maKhachHang) {
        this.maKhachHang = maKhachHang;
    }

    public NguoiDung getMaNhanVien() {
        return maNhanVien;
    }

    public void setMaNhanVien(NguoiDung maNhanVien) {
        this.maNhanVien = maNhanVien;
    }

    @XmlTransient
    public Collection<ChiTietDonHang> getChiTietDonHangCollection() {
        return chiTietDonHangCollection;
    }

    public void setChiTietDonHangCollection(Collection<ChiTietDonHang> chiTietDonHangCollection) {
        this.chiTietDonHangCollection = chiTietDonHangCollection;
    }

    public ThanhToan getThanhToan() {
        return thanhToan;
    }

    public void setThanhToan(ThanhToan thanhToan) {
        this.thanhToan = thanhToan;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (maDH != null ? maDH.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof DonHang)) {
            return false;
        }
        DonHang other = (DonHang) object;
        if ((this.maDH == null && other.maDH != null) || (this.maDH != null && !this.maDH.equals(other.maDH))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.DonHang[ maDH=" + maDH + " ]";
    }

}
