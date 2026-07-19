<%--
    Document   : products
    Created on : Jul 19, 2026, 5:26:42 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách Sản Phẩm</title>
        <style>
            .container {
                display: flex;
                font-family: sans-serif;
            }
            .sidebar {
                width: 25%;
                padding: 15px;
                background: #f4f4f4;
                border-right: 1px solid #ddd;
            }
            .content {
                width: 75%;
                padding: 15px;
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }
            .product-card {
                border: 1px solid #ccc;
                padding: 10px;
                width: 200px;
                text-align: center;
                border-radius: 5px;
            }
            .product-card img {
                width: 150px;
                height: 150px;
                object-fit: cover;
            }
        </style>
    </head>
    <body>
        <h2>Cửa hàng - Trang chủ</h2>
        <hr>
        <div class="container">
            <!-- Cột bên trái: Lọc theo danh mục -->
            <div class="sidebar">
                <h3>Danh mục</h3>
                <ul>
                    <li><a href="products">Tất cả sản phẩm</a></li>
                        <c:forEach items="${listCategories}" var="c">
                        <li>
                            <!-- Truyền categoryId lên URL để ProductServlet hứng -->
                            <a href="products?categoryId=${c.maDanhMuc}">${c.tenDanhMuc}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Cột bên phải: Hiển thị sản phẩm -->
            <div class="content">
                <c:if test="${empty listProducts}">
                    <p>Không có sản phẩm nào.</p>
                </c:if>
                <c:forEach items="${listProducts}" var="p">
                    <div class="product-card">
                        <img src="${p.hinhAnh}" alt="${p.tenSP}">
                        <h4>${p.tenSP}</h4>
                        <p style="color: red; font-weight: bold;">${p.donGia} ${p.donViTinh}</p>
                        <!-- Link dẫn sang trang chi tiết -->
                        <a href="product-detail?id=${p.maSP}">Xem chi tiết</a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </body>
</html>
