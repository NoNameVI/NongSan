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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "GioHang")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "GioHang.findAll", query = "SELECT g FROM GioHang g"),
    @NamedQuery(name = "GioHang.findByMaGioHang", query = "SELECT g FROM GioHang g WHERE g.maGioHang = :maGioHang")})
public class GioHang implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaGioHang")
    private Integer maGioHang;
    @JoinColumn(name = "MaKhachHang", referencedColumnName = "MaND")
    @OneToOne(optional = false)
    private NguoiDung maKhachHang;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "gioHang")
    private Collection<ChiTietGioHang> chiTietGioHangCollection;

    public GioHang() {
    }

    public GioHang(Integer maGioHang) {
        this.maGioHang = maGioHang;
    }

    public Integer getMaGioHang() {
        return maGioHang;
    }

    public void setMaGioHang(Integer maGioHang) {
        this.maGioHang = maGioHang;
    }

    public NguoiDung getMaKhachHang() {
        return maKhachHang;
    }

    public void setMaKhachHang(NguoiDung maKhachHang) {
        this.maKhachHang = maKhachHang;
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
        hash += (maGioHang != null ? maGioHang.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof GioHang)) {
            return false;
        }
        GioHang other = (GioHang) object;
        if ((this.maGioHang == null && other.maGioHang != null) || (this.maGioHang != null && !this.maGioHang.equals(other.maGioHang))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.GioHang[ maGioHang=" + maGioHang + " ]";
    }

}
