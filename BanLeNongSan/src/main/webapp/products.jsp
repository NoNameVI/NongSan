<%--
    Document   : products
    Created on : Jul 19, 2026, 5:26:42 PM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cửa hàng - Rau Thép</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&family=Montserrat:wght@600;700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --app-font: 'Be Vietnam Pro', 'Segoe UI', Arial, sans-serif;
                --heading-font: 'Montserrat', 'Be Vietnam Pro', 'Segoe UI', Arial, sans-serif;
            }
            body {
                font-family: var(--app-font);
            }
            h1, h2, h3, h4, h5, h6 {
                font-family: var(--heading-font);
            }
        </style>
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {extend: {colors: {
                            brand: {dark: '#112518', card: '#183625', primary: '#4ade80', accent: '#f97316', text: '#e2e8f0', muted: '#94a3b8'}
                        }}}
            }
        </script>
    </head>
    <body class="bg-brand-dark text-brand-text font-sans antialiased min-h-screen">

        <!-- NAVBAR CÓ THANH TÌM KIẾM Ở GIỮA -->
        <nav class="flex items-center justify-between px-10 py-4 bg-brand-dark text-brand-text border-b border-brand-card sticky top-0 z-50">
            <!-- Cột trái: Logo + Links -->
            <div class="flex items-center gap-8">
                <a href="home" class="flex items-center gap-2 text-xl font-bold text-brand-primary cursor-pointer">
                    <span>🌿</span> Rau Thép
                </a>
                <div class="hidden xl:flex gap-6 text-sm font-medium">
                    <c:if test="${sessionScope.user.maVaiTro.maVaiTro == 2 or sessionScope.user.maVaiTro.maVaiTro == 3}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="text-brand-text hover:text-orange-400 transition font-bold flex items-center gap-1">⚙️ Dashboard</a>
                    </c:if>
                    <a href="home" class="hover:text-brand-primary transition">Trang chủ</a>
                    <a href="products" class="text-brand-primary transition">Cửa hàng</a>
                    <a href="aboutus.jsp" class="hover:text-brand-primary transition">Về chúng tôi</a>
                </div>
            </div>

            <!-- Cột giữa: Thanh tìm kiếm (CHỈ HIỆN Ở ĐÂY) -->
            <div class="flex-1 max-w-lg mx-8 hidden md:block">
                <form action="products" method="POST" class="flex w-full shadow-lg">
                    <!-- Truyền action=search -->
                    <input type="hidden" name="action" value="search">
                    <!-- Giữ lại giá trị searchKeyword sau khi tìm kiếm -->
                    <input type="text" name="search" value="${searchKeyword}" class="w-full bg-brand-card border border-brand-muted/30 rounded-l-full px-5 py-2 text-sm text-white focus:outline-none focus:border-brand-primary transition" placeholder="Tìm kiếm sản phẩm...">
                    <button type="submit" class="bg-brand-primary text-brand-dark px-6 py-2 rounded-r-full font-bold hover:bg-green-500 transition">🔍</button>
                </form>
            </div>

            <!-- Cột phải: User Actions -->
            <div class="flex items-center gap-4 shrink-0">
                <a href="cart" class="relative p-2 bg-brand-card rounded border border-brand-dark hover:border-brand-primary text-brand-text transition font-bold flex items-center gap-1">
                    🛒 Giỏ hàng
                    <c:if test="${not empty sessionScope.cartItems}">
                        <span class="absolute -top-2 -right-2 bg-brand-accent text-white text-xs font-bold w-5 h-5 flex items-center justify-center rounded-full">${fn:length(sessionScope.cartItems)}</span>
                    </c:if>
                </a>
                <c:choose>
                    <c:when test="${not empty cookie.fullname.value}">
                        <a href="orderhistory" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">📜 Lịch sử GD</a>
                        <a href="profile" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">👤 ${fn:replace(cookie.fullname.value, '_', ' ')}</a>
                        <a href="logout" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1" title="Đăng xuất">🚪 Thoát</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">👤 Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>

        <div class="max-w-7xl mx-auto px-6 py-8">
            <!-- Breadcrumb -->
            <div class="text-sm text-brand-muted mb-8">
                <a href="home" class="hover:text-brand-text">Trang chủ</a> &gt;
                <span class="text-white font-semibold">Cửa hàng</span>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                <!-- Sidebar Danh Mục -->
                <div class="lg:col-span-1 space-y-6">
                    <div class="bg-brand-card p-6 rounded-xl border border-brand-dark sticky top-24 shadow-lg">
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

                <!-- Main Content -->
                <div class="lg:col-span-3">
                    <div class="flex justify-between items-center mb-6">
                        <h1 class="text-3xl font-bold text-white border-l-4 border-brand-primary pl-3">
                            <c:choose>
                                <c:when test="${not empty param.categoryId}">Sản phẩm theo danh mục</c:when>
                                <c:otherwise>Toàn Bộ Sản Phẩm</c:otherwise>
                            </c:choose>
                        </h1>
                        <span class="text-brand-muted text-sm">Đang hiển thị các sản phẩm có sẵn</span>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach items="${listProducts}" var="p">
                            <!-- Product Card -->
                            <div class="bg-brand-card border border-brand-dark rounded-xl overflow-hidden group hover:border-brand-primary transition duration-300 flex flex-col shadow-md">
                                <a href="productdetail?id=${p.maSP}" class="block relative overflow-hidden aspect-square m-2 rounded-xl border border-brand-primary shadow-sm hover:border-brand-accent transition duration-300">
                                    <img src="${pageContext.request.contextPath}/${p.hinhAnh}" alt="${p.tenSP}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500 bg-white">
                                    <div class="absolute top-2 right-2 bg-brand-dark/90 backdrop-blur text-xs font-bold px-2 py-1 rounded text-brand-primary">
                                        ${p.maDanhMuc.tenDanhMuc}
                                    </div>
                                </a>
                                <div class="p-4 flex flex-col flex-grow">
                                    <a href="productdetail?id=${p.maSP}" class="text-lg font-bold text-white hover:text-brand-primary transition line-clamp-1 mb-1">${p.tenSP}</a>
                                    <p class="text-xl font-bold text-brand-accent mb-4">${p.donGia}đ <span class="text-sm text-brand-muted font-normal">/${p.donViTinh}</span></p>

                                    <div class="mt-auto flex gap-2">
                                        <a href="productdetail?id=${p.maSP}" class="flex-1 text-center bg-brand-dark border border-brand-muted/30 text-brand-text py-2 rounded font-medium hover:bg-white/10 transition text-sm">Chi tiết</a>
                                        <form action="cart" method="GET" class="flex-1">
                                            <input type="hidden" name="action" value="quickAdd">
                                            <input type="hidden" name="productId" value="${p.maSP}">
                                            <button type="submit" class="w-full bg-brand-primary text-brand-dark py-2 rounded font-bold hover:bg-green-500 transition text-sm shadow-lg shadow-brand-primary/20">Thêm 🛒</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Empty State -->
                        <c:if test="${empty listProducts}">
                            <div class="col-span-full text-center py-16 bg-brand-card rounded-xl border border-brand-dark shadow-inner">
                                <span class="text-5xl mb-4 block opacity-50">🍃</span>
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
