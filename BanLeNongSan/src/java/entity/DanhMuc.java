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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "DanhMuc")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "DanhMuc.findAll", query = "SELECT d FROM DanhMuc d"),
    @NamedQuery(name = "DanhMuc.findByMaDanhMuc", query = "SELECT d FROM DanhMuc d WHERE d.maDanhMuc = :maDanhMuc"),
    @NamedQuery(name = "DanhMuc.findByTenDanhMuc", query = "SELECT d FROM DanhMuc d WHERE d.tenDanhMuc = :tenDanhMuc"),
    @NamedQuery(name = "DanhMuc.findByMoTa", query = "SELECT d FROM DanhMuc d WHERE d.moTa = :moTa")})
public class DanhMuc implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaDanhMuc")
    private Integer maDanhMuc;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "TenDanhMuc")
    private String tenDanhMuc;
    @Size(max = 255)
    @Column(name = "MoTa")
    private String moTa;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "maDanhMuc")
    private Collection<SanPham> sanPhamCollection;

    public DanhMuc() {
    }

    public DanhMuc(Integer maDanhMuc) {
        this.maDanhMuc = maDanhMuc;
    }

    public DanhMuc(Integer maDanhMuc, String tenDanhMuc) {
        this.maDanhMuc = maDanhMuc;
        this.tenDanhMuc = tenDanhMuc;
    }

    public Integer getMaDanhMuc() {
        return maDanhMuc;
    }

    public void setMaDanhMuc(Integer maDanhMuc) {
        this.maDanhMuc = maDanhMuc;
    }

    public String getTenDanhMuc() {
        return tenDanhMuc;
    }

    public void setTenDanhMuc(String tenDanhMuc) {
        this.tenDanhMuc = tenDanhMuc;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    @XmlTransient
    public Collection<SanPham> getSanPhamCollection() {
        return sanPhamCollection;
    }

    public void setSanPhamCollection(Collection<SanPham> sanPhamCollection) {
        this.sanPhamCollection = sanPhamCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (maDanhMuc != null ? maDanhMuc.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof DanhMuc)) {
            return false;
        }
        DanhMuc other = (DanhMuc) object;
        if ((this.maDanhMuc == null && other.maDanhMuc != null) || (this.maDanhMuc != null && !this.maDanhMuc.equals(other.maDanhMuc))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.DanhMuc[ maDanhMuc=" + maDanhMuc + " ]";
    }

}
