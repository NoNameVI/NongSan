<%--
    Document   : productdetail
    Created on : Jul 19, 2026, 5:28:20 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Chi tiết: ${product.tenSP}</title>
        <style> body {
            font-family: sans-serif;
            padding: 20px;
            max-width: 1000px;
            margin: auto;
        } </style>
    </head>
    <body>
        <a href="products" style="text-decoration: none; color: blue;">⬅ Quay lại Trang chủ</a>
        <hr>

        <div style="display: flex; gap: 30px; margin-top: 20px;">
            <img src="${product.hinhAnh}" alt="Ảnh SP" style="width: 400px; height: 400px; object-fit: cover; border: 1px solid #eee; border-radius: 8px;">

            <div>
                <h2>${product.tenSP}</h2>
                <h3 style="color: #d9534f;">Giá: ${product.donGia} ${product.donViTinh}</h3>
                <p><strong>Danh mục:</strong> ${product.maDanhMuc.tenDanhMuc}</p>
                <p><strong>Nhà cung cấp:</strong> ${product.maNCC.tenNCC}</p>
                <p><strong>Kho còn:</strong> ${product.soLuongTon} sản phẩm</p>
                <p><strong>Tình trạng:</strong> ${product.trangThai}</p>
                <div style="background: #f9f9f9; padding: 15px; border-radius: 5px; margin-top: 15px;">
                    <strong>Mô tả chi tiết:</strong><br>
                    ${product.moTa}
                </div>
                <br>
                <button style="padding: 10px 20px; background: #5cb85c; color: white; border: none; border-radius: 4px; cursor: pointer;">Thêm vào giỏ hàng (Cart)</button>
            </div>
        </div>
    </body>
</html>
