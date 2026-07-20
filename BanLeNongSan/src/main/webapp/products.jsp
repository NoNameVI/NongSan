<%--
    Document   : products
    Created on : Jul 19, 2026, 5:26:42 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cửa hàng - Nông Sản Việt</title>
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

        <nav class="flex items-center justify-between px-10 py-4 bg-brand-dark text-brand-text border-b border-brand-card sticky top-0 z-50">
            <div class="flex items-center gap-2 text-xl font-bold text-brand-primary">
                <span>🌿</span> Nông Sản Việt
            </div>
            <div class="flex gap-8 text-sm font-medium">
                <a href="home" class="hover:text-brand-primary transition">Trang chủ</a>
                <a href="products" class="text-brand-primary transition">Cửa hàng</a>
                <a href="#" class="hover:text-brand-primary transition">Về chúng tôi</a>
            </div>
            <div class="flex items-center gap-4">
                <a href="cart" class="p-2 bg-brand-card rounded hover:bg-brand-primary hover:text-brand-dark transition">🛒 Giỏ hàng</a>
            </div>
        </nav>

        <div class="max-w-7xl mx-auto px-6 py-8">

            <!-- Breadcrumb -->
            <div class="text-sm text-brand-muted mb-8">
                <a href="home" class="hover:text-brand-text">Trang chủ</a> &gt;
                <span class="text-brand-text">Cửa hàng</span>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

                <div class="lg:col-span-1 space-y-6">
                    <div class="bg-brand-card p-6 rounded-xl border border-brand-dark sticky top-24">
                        <h3 class="text-lg font-bold text-white mb-4 uppercase border-b border-brand-dark pb-2">Danh mục</h3>
                        <ul class="space-y-2">
                            <li>
                                <a href="products" class="block py-2 text-brand-text hover:text-brand-primary transition ${empty param.categoryId ? 'text-brand-primary font-bold' : ''}">
                                    Tất cả sản phẩm
                                </a>
                            </li>
                            <c:forEach items="${listCategories}" var="dm">
                                <li>
                                    <a href="products?categoryId=${dm.maDanhMuc}" class="block py-2 text-brand-text hover:text-brand-primary transition ${param.categoryId == dm.maDanhMuc ? 'text-brand-primary font-bold' : ''}">
                                        ${dm.tenDanhMuc}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <div class="lg:col-span-3">
                    <div class="flex justify-between items-center mb-6">
                        <h1 class="text-3xl font-serif font-bold text-white">
                            <c:choose>
                                <c:when test="${not empty param.categoryId}">
                                    Sản phẩm theo danh mục
                                </c:when>
                                <c:otherwise>
                                    Toàn Bộ Sản Phẩm
                                </c:otherwise>
                            </c:choose>
                        </h1>
                        <span class="text-brand-muted text-sm">Đang hiển thị các sản phẩm có sẵn</span>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach items="${listProducts}" var="p">
                            <!-- Product Card -->
                            <div class="bg-brand-card border border-brand-dark rounded-xl overflow-hidden group hover:border-brand-primary transition duration-300 flex flex-col">
                                <a href="productdetail?id=${p.maSP}" class="block relative overflow-hidden aspect-square">
                                    <img src="${p.hinhAnh}" alt="${p.tenSP}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                                    <div class="absolute top-2 right-2 bg-brand-dark/80 backdrop-blur text-xs font-bold px-2 py-1 rounded text-brand-primary">
                                        ${p.maDanhMuc.tenDanhMuc}
                                    </div>
                                </a>
                                <div class="p-4 flex flex-col flex-grow">
                                    <a href="productdetail?id=${p.maSP}" class="text-lg font-bold text-white hover:text-brand-primary transition line-clamp-1 mb-1">${p.tenSP}</a>
                                    <p class="text-xl font-bold text-brand-accent mb-4">${p.donGia}đ <span class="text-sm text-brand-muted font-normal">/${p.donViTinh}</span></p>

                                    <div class="mt-auto flex gap-2">
                                        <a href="productdetail?id=${p.maSP}" class="flex-1 text-center bg-brand-dark border border-brand-muted text-brand-text py-2 rounded hover:bg-white/10 transition text-sm">Chi tiết</a>
                                        <form action="cart" method="POST" class="flex-1">
                                            <input type="hidden" name="productId" value="${p.maSP}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="w-full bg-brand-primary text-brand-dark py-2 rounded font-bold hover:bg-green-500 transition text-sm">Thêm 🛒</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty listProducts}">
                            <div class="col-span-full text-center py-12 bg-brand-card rounded-xl border border-brand-dark">
                                <span class="text-4xl mb-4 block">🍃</span>
                                <h3 class="text-xl text-white font-bold mb-2">Chưa có sản phẩm nào!</h3>
                                <p class="text-brand-muted">Hiện tại danh mục này đang trống, vui lòng quay lại sau.</p>
                            </div>
                        </c:if>
                    </div>
                </div>

            </div>
        </div>
    </body>
</html>
