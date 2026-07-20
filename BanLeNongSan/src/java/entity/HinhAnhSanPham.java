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
import java.util.Date;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "HinhAnhSanPham")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "HinhAnhSanPham.findAll", query = "SELECT h FROM HinhAnhSanPham h"),
    @NamedQuery(name = "HinhAnhSanPham.findByMaHinhAnh", query = "SELECT h FROM HinhAnhSanPham h WHERE h.maHinhAnh = :maHinhAnh"),
    @NamedQuery(name = "HinhAnhSanPham.findByDuongDan", query = "SELECT h FROM HinhAnhSanPham h WHERE h.duongDan = :duongDan"),
    @NamedQuery(name = "HinhAnhSanPham.findByLaAnhChinh", query = "SELECT h FROM HinhAnhSanPham h WHERE h.laAnhChinh = :laAnhChinh"),
    @NamedQuery(name = "HinhAnhSanPham.findByThuTu", query = "SELECT h FROM HinhAnhSanPham h WHERE h.thuTu = :thuTu"),
    @NamedQuery(name = "HinhAnhSanPham.findByMoTa", query = "SELECT h FROM HinhAnhSanPham h WHERE h.moTa = :moTa"),
    @NamedQuery(name = "HinhAnhSanPham.findByNgayTao", query = "SELECT h FROM HinhAnhSanPham h WHERE h.ngayTao = :ngayTao")})
public class HinhAnhSanPham implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaHinhAnh")
    private Integer maHinhAnh;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "DuongDan")
    private String duongDan;
    @Basic(optional = false)
    @NotNull
    @Column(name = "LaAnhChinh")
    private boolean laAnhChinh;
    @Basic(optional = false)
    @NotNull
    @Column(name = "ThuTu")
    private int thuTu;
    @Size(max = 255)
    @Column(name = "MoTa")
    private String moTa;
    @Column(name = "NgayTao")
    @Temporal(TemporalType.TIMESTAMP)
    private Date ngayTao;
    @JoinColumn(name = "MaSP", referencedColumnName = "MaSP")
    @OneToOne(optional = false)
    private SanPham maSP;

    public HinhAnhSanPham() {
    }

    public HinhAnhSanPham(Integer maHinhAnh) {
        this.maHinhAnh = maHinhAnh;
    }

    public HinhAnhSanPham(Integer maHinhAnh, String duongDan, boolean laAnhChinh, int thuTu) {
        this.maHinhAnh = maHinhAnh;
        this.duongDan = duongDan;
        this.laAnhChinh = laAnhChinh;
        this.thuTu = thuTu;
    }

    public Integer getMaHinhAnh() {
        return maHinhAnh;
    }

    public void setMaHinhAnh(Integer maHinhAnh) {
        this.maHinhAnh = maHinhAnh;
    }

    public String getDuongDan() {
        return duongDan;
    }

    public void setDuongDan(String duongDan) {
        this.duongDan = duongDan;
    }

    public boolean getLaAnhChinh() {
        return laAnhChinh;
    }

    public void setLaAnhChinh(boolean laAnhChinh) {
        this.laAnhChinh = laAnhChinh;
    }

    public int getThuTu() {
        return thuTu;
    }

    public void setThuTu(int thuTu) {
        this.thuTu = thuTu;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public SanPham getMaSP() {
        return maSP;
    }

    public void setMaSP(SanPham maSP) {
        this.maSP = maSP;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (maHinhAnh != null ? maHinhAnh.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof HinhAnhSanPham)) {
            return false;
        }
        HinhAnhSanPham other = (HinhAnhSanPham) object;
        if ((this.maHinhAnh == null && other.maHinhAnh != null) || (this.maHinhAnh != null && !this.maHinhAnh.equals(other.maHinhAnh))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.HinhAnhSanPham[ maHinhAnh=" + maHinhAnh + " ]";
    }

}
