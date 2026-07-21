/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "ThanhToan")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ThanhToan.findAll", query = "SELECT t FROM ThanhToan t"),
    @NamedQuery(name = "ThanhToan.findByMaThanhToan", query = "SELECT t FROM ThanhToan t WHERE t.maThanhToan = :maThanhToan"),
    @NamedQuery(name = "ThanhToan.findByPhuongThuc", query = "SELECT t FROM ThanhToan t WHERE t.phuongThuc = :phuongThuc"),
    @NamedQuery(name = "ThanhToan.findBySoTien", query = "SELECT t FROM ThanhToan t WHERE t.soTien = :soTien"),
    @NamedQuery(name = "ThanhToan.findByNgayThanhToan", query = "SELECT t FROM ThanhToan t WHERE t.ngayThanhToan = :ngayThanhToan"),
    @NamedQuery(name = "ThanhToan.findByTrangThai", query = "SELECT t FROM ThanhToan t WHERE t.trangThai = :trangThai")})
public class ThanhToan implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "PhuongThuc")
    private String phuongThuc;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "SoTien")
    private BigDecimal soTien;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "TrangThai")
    private String trangThai;

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaThanhToan")
    private Integer maThanhToan;
    @Column(name = "NgayThanhToan")
    @Temporal(TemporalType.TIMESTAMP)
    private Date ngayThanhToan;
    @JoinColumn(name = "MaDH", referencedColumnName = "MaDH")
    @OneToOne(optional = false)
    private DonHang maDH;

    public ThanhToan() {
    }

    public ThanhToan(Integer maThanhToan) {
        this.maThanhToan = maThanhToan;
    }

    public ThanhToan(Integer maThanhToan, String phuongThuc, BigDecimal soTien, String trangThai) {
        this.maThanhToan = maThanhToan;
        this.phuongThuc = phuongThuc;
        this.soTien = soTien;
        this.trangThai = trangThai;
    }

    public Integer getMaThanhToan() {
        return maThanhToan;
    }

    public void setMaThanhToan(Integer maThanhToan) {
        this.maThanhToan = maThanhToan;
    }


    public Date getNgayThanhToan() {
        return ngayThanhToan;
    }

    public void setNgayThanhToan(Date ngayThanhToan) {
        this.ngayThanhToan = ngayThanhToan;
    }


    public DonHang getMaDH() {
        return maDH;
    }

    public void setMaDH(DonHang maDH) {
        this.maDH = maDH;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (maThanhToan != null ? maThanhToan.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ThanhToan)) {
            return false;
        }
        ThanhToan other = (ThanhToan) object;
        if ((this.maThanhToan == null && other.maThanhToan != null) || (this.maThanhToan != null && !this.maThanhToan.equals(other.maThanhToan))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.ThanhToan[ maThanhToan=" + maThanhToan + " ]";
    }

    public String getPhuongThuc() {
        return phuongThuc;
    }

    public void setPhuongThuc(String phuongThuc) {
        this.phuongThuc = phuongThuc;
    }

    public BigDecimal getSoTien() {
        return soTien;
    }

    public void setSoTien(BigDecimal soTien) {
        this.soTien = soTien;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

}
