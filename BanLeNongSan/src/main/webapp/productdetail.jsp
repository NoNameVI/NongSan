<%--
    Document   : adminproducts
    Created on : Jul 19, 2026, 5:35:23 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý sản phẩm - Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            brand: {
                                dark: '#112518',
                                card: '#183625',
                                primary: '#4ade80',
                                accent: '#f97316',
                                text: '#e2e8f0',
                                muted: '#94a3b8'
                            }
                        }
                    }
                }
            }
        </script>
    </head>
    <body class="bg-brand-dark text-brand-text font-sans antialiased min-h-screen">

        <!-- NAVBAR -->
        <nav class="flex items-center justify-between px-10 py-4 bg-brand-dark text-brand-text border-b border-brand-card sticky top-0 z-50">
            <div class="flex items-center gap-2 text-xl font-bold text-brand-primary">
                <span>🌿</span> Nông Sản Việt (Admin)
            </div>
            <div class="flex gap-8 text-sm font-medium">
                <a href="home" class="hover:text-brand-primary transition">Trang chủ</a>
                <a href="products" class="hover:text-brand-primary transition">Cửa hàng</a>
            </div>
            <div class="flex items-center gap-4">
                <a href="addproduct.jsp" class="bg-brand-accent px-4 py-2 rounded text-sm font-bold text-white hover:bg-orange-600 transition">+ Thêm sản phẩm mới</a>
            </div>
        </nav>

        <!-- CONTENT -->
        <div class="p-8 max-w-7xl mx-auto">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-serif font-bold text-white">Quản lý sản phẩm</h1>
                    <p class="text-brand-muted mt-1">Chỉnh sửa, cập nhật tồn kho và xóa sản phẩm trong kho</p>
                </div>
                <a href="addproduct.jsp" class="bg-brand-accent px-4 py-2 rounded text-sm font-bold text-white hover:bg-orange-600 transition">+ Thêm sản phẩm mới</a>
            </div>

            <!-- Bảng danh sách sản phẩm -->
            <div class="bg-brand-card rounded-lg overflow-hidden border border-brand-dark">
                <div class="grid grid-cols-12 gap-4 p-4 border-b border-brand-dark text-sm font-bold text-brand-muted uppercase">
                    <div class="col-span-5">Sản phẩm</div>
                    <div class="col-span-2">Danh mục</div>
                    <div class="col-span-2">Giá</div>
                    <div class="col-span-1">Tồn kho</div>
                    <div class="col-span-2 text-right">Thao tác</div>
                </div>

                <c:forEach items="${listProducts}" var="p">
                    <div class="grid grid-cols-12 gap-4 p-4 items-center border-b border-brand-dark hover:bg-white/5 transition">
                        <div class="col-span-5 flex items-center gap-4">
                            <img src="${p.hinhAnh}" class="w-12 h-12 rounded object-cover border border-brand-dark">
                            <span class="font-medium text-white">${p.tenSP}</span>
                        </div>
                        <div class="col-span-2 text-brand-muted">${p.maDanhMuc.tenDanhMuc}</div>
                        <div class="col-span-2 text-brand-primary font-bold">${p.donGia}đ</div>
                        <div class="col-span-1 font-semibold">${p.soLuongTon}</div>
                        <div class="col-span-2 flex justify-end gap-2">
                            <a href="productupdate.jsp?id=${p.maSP}" class="px-3 py-1 bg-transparent border border-brand-muted rounded text-xs hover:text-white transition">✏️ Sửa</a>
                            <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.maSP}"
                               class="px-3 py-1 bg-red-900/50 text-red-400 rounded text-xs hover:bg-red-600 hover:text-white transition"
                               onclick="return confirm('Bạn chắc chắn muốn xóa vĩnh viễn sản phẩm: ${p.tenSP}?')">🗑️ Xóa</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </body>
</html>
