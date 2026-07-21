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
@Table(name = "VaiTro")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "VaiTro.findAll", query = "SELECT v FROM VaiTro v"),
    @NamedQuery(name = "VaiTro.findByMaVaiTro", query = "SELECT v FROM VaiTro v WHERE v.maVaiTro = :maVaiTro"),
    @NamedQuery(name = "VaiTro.findByTenVaiTro", query = "SELECT v FROM VaiTro v WHERE v.tenVaiTro = :tenVaiTro")})
public class VaiTro implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 30)
    @Column(name = "TenVaiTro")
    private String tenVaiTro;

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaVaiTro")
    private Integer maVaiTro;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "maVaiTro")
    private Collection<NguoiDung> nguoiDungCollection;

    public VaiTro() {
    }

    public VaiTro(Integer maVaiTro) {
        this.maVaiTro = maVaiTro;
    }

    public VaiTro(Integer maVaiTro, String tenVaiTro) {
        this.maVaiTro = maVaiTro;
        this.tenVaiTro = tenVaiTro;
    }

    public Integer getMaVaiTro() {
        return maVaiTro;
    }

    public void setMaVaiTro(Integer maVaiTro) {
        this.maVaiTro = maVaiTro;
    }


    @XmlTransient
    public Collection<NguoiDung> getNguoiDungCollection() {
        return nguoiDungCollection;
    }

    public void setNguoiDungCollection(Collection<NguoiDung> nguoiDungCollection) {
        this.nguoiDungCollection = nguoiDungCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (maVaiTro != null ? maVaiTro.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof VaiTro)) {
            return false;
        }
        VaiTro other = (VaiTro) object;
        if ((this.maVaiTro == null && other.maVaiTro != null) || (this.maVaiTro != null && !this.maVaiTro.equals(other.maVaiTro))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.VaiTro[ maVaiTro=" + maVaiTro + " ]";
    }

    public String getTenVaiTro() {
        return tenVaiTro;
    }

    public void setTenVaiTro(String tenVaiTro) {
        this.tenVaiTro = tenVaiTro;
    }

}
