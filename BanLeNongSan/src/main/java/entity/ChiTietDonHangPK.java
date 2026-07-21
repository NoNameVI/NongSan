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
public class ChiTietDonHangPK implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Column(name = "MaDH")
    private int maDH;
    @Basic(optional = false)
    @NotNull
    @Column(name = "MaSP")
    private int maSP;

    public ChiTietDonHangPK() {
    }

    public ChiTietDonHangPK(int maDH, int maSP) {
        this.maDH = maDH;
        this.maSP = maSP;
    }

    public int getMaDH() {
        return maDH;
    }

    public void setMaDH(int maDH) {
        this.maDH = maDH;
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
        hash += (int) maDH;
        hash += (int) maSP;
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ChiTietDonHangPK)) {
            return false;
        }
        ChiTietDonHangPK other = (ChiTietDonHangPK) object;
        if (this.maDH != other.maDH) {
            return false;
        }
        if (this.maSP != other.maSP) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.ChiTietDonHangPK[ maDH=" + maDH + ", maSP=" + maSP + " ]";
    }

}
