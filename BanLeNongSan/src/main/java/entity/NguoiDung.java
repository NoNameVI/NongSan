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
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "NguoiDung")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "NguoiDung.findAll", query = "SELECT n FROM NguoiDung n"),
    @NamedQuery(name = "NguoiDung.findByMaND", query = "SELECT n FROM NguoiDung n WHERE n.maND = :maND"),
    @NamedQuery(name = "NguoiDung.findByHoTen", query = "SELECT n FROM NguoiDung n WHERE n.hoTen = :hoTen"),
    @NamedQuery(name = "NguoiDung.findByEmail", query = "SELECT n FROM NguoiDung n WHERE n.email = :email"),
    @NamedQuery(name = "NguoiDung.findByMatKhau", query = "SELECT n FROM NguoiDung n WHERE n.matKhau = :matKhau"),
    @NamedQuery(name = "NguoiDung.findBySdt", query = "SELECT n FROM NguoiDung n WHERE n.sdt = :sdt"),
    @NamedQuery(name = "NguoiDung.findByDiaChi", query = "SELECT n FROM NguoiDung n WHERE n.diaChi = :diaChi"),
    @NamedQuery(name = "NguoiDung.findByNgayTao", query = "SELECT n FROM NguoiDung n WHERE n.ngayTao = :ngayTao"),
    @NamedQuery(name = "NguoiDung.findByTrangThai", query = "SELECT n FROM NguoiDung n WHERE n.trangThai = :trangThai")})
public class NguoiDung implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "HoTen")
    private String hoTen;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "Email")
    private String email;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "MatKhau")
    private String matKhau;
    @Size(max = 15)
    @Column(name = "SDT")
    private String sdt;
    @Size(max = 255)
    @Column(name = "DiaChi")
    private String diaChi;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "TrangThai")
    private String trangThai;

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "MaND")
    private Integer maND;
    @Column(name = "NgayTao")
    @Temporal(TemporalType.TIMESTAMP)
    private Date ngayTao;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "maKhachHang")
    private Collection<DanhGia> danhGiaCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "maKhachHang")
    private Collection<DonHang> donHangCollection;
    @OneToMany(mappedBy = "maNhanVien")
    private Collection<DonHang> donHangCollection1;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "maKhachHang")
    private GioHang gioHang;
    @JoinColumn(name = "MaVaiTro", referencedColumnName = "MaVaiTro")
    @ManyToOne(optional = false)
    private VaiTro maVaiTro;

    public NguoiDung() {
    }

    public NguoiDung(Integer maND) {
        this.maND = maND;
    }

    public NguoiDung(Integer maND, String hoTen, String email, String matKhau, String trangThai) {
        this.maND = maND;
        this.hoTen = hoTen;
        this.email = email;
        this.matKhau = matKhau;
        this.trangThai = trangThai;
    }

    public Integer getMaND() {
        return maND;
    }

    public void setMaND(Integer maND) {
        this.maND = maND;
    }


    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }


    @XmlTransient
    public Collection<DanhGia> getDanhGiaCollection() {
        return danhGiaCollection;
    }

    public void setDanhGiaCollection(Collection<DanhGia> danhGiaCollection) {
        this.danhGiaCollection = danhGiaCollection;
    }

    @XmlTransient
    public Collection<DonHang> getDonHangCollection() {
        return donHangCollection;
    }

    public void setDonHangCollection(Collection<DonHang> donHangCollection) {
        this.donHangCollection = donHangCollection;
    }

    @XmlTransient
    public Collection<DonHang> getDonHangCollection1() {
        return donHangCollection1;
    }

    public void setDonHangCollection1(Collection<DonHang> donHangCollection1) {
        this.donHangCollection1 = donHangCollection1;
    }

    public GioHang getGioHang() {
        return gioHang;
    }

    public void setGioHang(GioHang gioHang) {
        this.gioHang = gioHang;
    }

    public VaiTro getMaVaiTro() {
        return maVaiTro;
    }

    public void setMaVaiTro(VaiTro maVaiTro) {
        this.maVaiTro = maVaiTro;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (maND != null ? maND.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof NguoiDung)) {
            return false;
        }
        NguoiDung other = (NguoiDung) object;
        if ((this.maND == null && other.maND != null) || (this.maND != null && !this.maND.equals(other.maND))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.NguoiDung[ maND=" + maND + " ]";
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

}
