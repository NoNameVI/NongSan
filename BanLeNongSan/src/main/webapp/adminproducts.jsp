<%--
    Document   : adminproducts
    Created on : Jul 19, 2026, 5:35:23 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Sản Phẩm - Admin</title>
        <style>
            body {
                font-family: sans-serif;
                padding: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            .btn-add {
                background: #0275d8;
                color: white;
                padding: 10px 15px;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <h2>Quản Trị Sản Phẩm</h2>

        <!-- Link trỏ tới trang thêm mới của bạn -->
        <a href="addproduct.jsp" class="btn-add">+ Thêm Sản Phẩm Mới</a>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Hình Ảnh</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Giá bán</th>
                    <th>Tồn kho</th>
                    <th>Danh mục</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach items="${listProducts}" var="p">
                <tr>
                    <td>${p.maSP}</td>
                    <td><img src="${p.hinhAnh}" width="60" height="60" style="object-fit:cover;"></td>
                    <td>${p.tenSP}</td>
                    <td>${p.donGia} ${p.donViTinh}</td>
                    <td>${p.soLuongTon}</td>
                    <td>${p.maDanhMuc.tenDanhMuc}</td>
                    <td>
                        <!-- Nút sửa trỏ về trang productupdate.jsp của bạn -->
                        <a href="productupdate.jsp?id=${p.maSP}" style="color: orange; text-decoration: none;">✏️ Sửa</a> |
                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.maSP}"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm: ${p.tenSP}?')"
                           style="color: red; text-decoration: none;">❌ Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
