/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;

/**
 *
 * @author Asus
 */
@Embeddable
public class ChiTietGioHangPK implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Column(name = "MaGioHang")
    private int maGioHang;
    @Basic(optional = false)
    @NotNull
    @Column(name = "MaSP")
    private int maSP;

    public ChiTietGioHangPK() {
    }

    public ChiTietGioHangPK(int maGioHang, int maSP) {
        this.maGioHang = maGioHang;
        this.maSP = maSP;
    }

    public int getMaGioHang() {
        return maGioHang;
    }

    public void setMaGioHang(int maGioHang) {
        this.maGioHang = maGioHang;
    }

    public int getMaSP() {
        return maSP;
    }

    public void setMaSP(int maSP) {
        this.maSP = maSP;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (int) maGioHang;
        hash += (int) maSP;
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ChiTietGioHangPK)) {
            return false;
        }
        ChiTietGioHangPK other = (ChiTietGioHangPK) object;
        if (this.maGioHang != other.maGioHang) {
            return false;
        }
        if (this.maSP != other.maSP) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.ChiTietGioHangPK[ maGioHang=" + maGioHang + ", maSP=" + maSP + " ]";
    }

}
