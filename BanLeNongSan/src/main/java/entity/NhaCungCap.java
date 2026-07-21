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
@Table(name = "NhaCungCap")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "NhaCungCap.findAll", query = "SELECT n FROM NhaCungCap n"),
    @NamedQuery(name = "NhaCungCap.findByMaNCC", query = "SELECT n FROM NhaCungCap n WHERE n.maNCC = :maNCC"),
    @NamedQuery(name = "NhaCungCap.findByTenNCC", query = "SELECT n FROM NhaCungCap n WHERE n.tenNCC = :tenNCC"),
    @NamedQuery(name = "NhaCungCap.findByDiaChi", query = "SELECT n FROM NhaCungCap n WHERE n.diaChi = :diaChi"),
    @NamedQuery(name = "NhaCungCap.findBySdt", query = "SELECT n FROM NhaCungCap n WHERE n.sdt = :sdt"),
    @NamedQuery(name = "NhaCungCap.findByEmail", query = "SELECT n FROM NhaCungCap n WHERE n.email = :email")})
public class NhaCungCap implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "TenNCC")
    private String tenNCC;
    @Size(max = 255)
    @Column(name = "DiaChi")
    private String diaChi;
    @Size(max = 15)
    @Column(name = "SDT")
    private String sdt;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Size(max = 100)
    @Column(name = "Email")
    private String email;

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaNCC")
    private Integer maNCC;
    @OneToMany(mappedBy = "maNCC")
    private Collection<SanPham> sanPhamCollection;

    public NhaCungCap() {
    }

    public NhaCungCap(Integer maNCC) {
        this.maNCC = maNCC;
    }

    public NhaCungCap(Integer maNCC, String tenNCC) {
        this.maNCC = maNCC;
        this.tenNCC = tenNCC;
    }

    public Integer getMaNCC() {
        return maNCC;
    }

    public void setMaNCC(Integer maNCC) {
        this.maNCC = maNCC;
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
        hash += (maNCC != null ? maNCC.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof NhaCungCap)) {
            return false;
        }
        NhaCungCap other = (NhaCungCap) object;
        if ((this.maNCC == null && other.maNCC != null) || (this.maNCC != null && !this.maNCC.equals(other.maNCC))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.NhaCungCap[ maNCC=" + maNCC + " ]";
    }

    public String getTenNCC() {
        return tenNCC;
    }

    public void setTenNCC(String tenNCC) {
        this.tenNCC = tenNCC;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

}
