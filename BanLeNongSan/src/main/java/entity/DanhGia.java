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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
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
@Table(name = "DanhGia")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "DanhGia.findAll", query = "SELECT d FROM DanhGia d"),
    @NamedQuery(name = "DanhGia.findByMaDanhGia", query = "SELECT d FROM DanhGia d WHERE d.maDanhGia = :maDanhGia"),
    @NamedQuery(name = "DanhGia.findBySoSao", query = "SELECT d FROM DanhGia d WHERE d.soSao = :soSao"),
    @NamedQuery(name = "DanhGia.findByNoiDung", query = "SELECT d FROM DanhGia d WHERE d.noiDung = :noiDung"),
    @NamedQuery(name = "DanhGia.findByNgayDanhGia", query = "SELECT d FROM DanhGia d WHERE d.ngayDanhGia = :ngayDanhGia")})
public class DanhGia implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaDanhGia")
    private Integer maDanhGia;
    @Basic(optional = false)
    @NotNull
    @Column(name = "SoSao")
    private short soSao;
    @Size(max = 500)
    @Column(name = "NoiDung")
    private String noiDung;
    @Column(name = "NgayDanhGia")
    @Temporal(TemporalType.TIMESTAMP)
    private Date ngayDanhGia;
    @JoinColumn(name = "MaKhachHang", referencedColumnName = "MaND")
    @ManyToOne(optional = false)
    private NguoiDung maKhachHang;
    @JoinColumn(name = "MaSP", referencedColumnName = "MaSP")
    @ManyToOne(optional = false)
    private SanPham maSP;

    public DanhGia() {
    }

    public DanhGia(Integer maDanhGia) {
        this.maDanhGia = maDanhGia;
    }

    public DanhGia(Integer maDanhGia, short soSao) {
        this.maDanhGia = maDanhGia;
        this.soSao = soSao;
    }

    public Integer getMaDanhGia() {
        return maDanhGia;
    }

    public void setMaDanhGia(Integer maDanhGia) {
        this.maDanhGia = maDanhGia;
    }

    public short getSoSao() {
        return soSao;
    }

    public void setSoSao(short soSao) {
        this.soSao = soSao;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public Date getNgayDanhGia() {
        return ngayDanhGia;
    }

    public void setNgayDanhGia(Date ngayDanhGia) {
        this.ngayDanhGia = ngayDanhGia;
    }

    public NguoiDung getMaKhachHang() {
        return maKhachHang;
    }

    public void setMaKhachHang(NguoiDung maKhachHang) {
        this.maKhachHang = maKhachHang;
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
        hash += (maDanhGia != null ? maDanhGia.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof DanhGia)) {
            return false;
        }
        DanhGia other = (DanhGia) object;
        if ((this.maDanhGia == null && other.maDanhGia != null) || (this.maDanhGia != null && !this.maDanhGia.equals(other.maDanhGia))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.DanhGia[ maDanhGia=" + maDanhGia + " ]";
    }

}
