<%--
    Document   : homepage
    Created on : Jul 19, 2026, 5:33:35 PM
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
        <title>Trang Chủ - Nông Sản Việt</title>
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
            <div class="flex items-center gap-2 text-xl font-bold text-brand-primary cursor-pointer" onclick="window.location.href = 'home'">
                <span>🌿</span> Nông Sản Việt
            </div>
            <div class="flex gap-8 text-sm font-medium">
                <a href="home" class="hover:text-brand-primary transition">Trang chủ</a>
                <a href="products" class="hover:text-brand-primary transition">Cửa hàng</a>
                <a href="#" class="hover:text-brand-primary transition">Về chúng tôi</a>
            </div>

            <!-- KHU VỰC NÚT BẤM BÊN PHẢI -->
            <div class="flex items-center gap-4">
                <!-- Giỏ hàng -->
                <a href="cart" class="relative p-2 bg-brand-card rounded hover:bg-brand-primary hover:text-brand-dark transition font-bold flex items-center gap-1">
                    🛒 Giỏ hàng
                    <c:if test="${not empty sessionScope.cartItems}">
                        <span class="absolute -top-2 -right-2 bg-brand-accent text-white text-xs font-bold w-5 h-5 flex items-center justify-center rounded-full">${fn:length(sessionScope.cartItems)}</span>
                    </c:if>
                </a>

                <!-- Dashboard chỉ hiện cho nhân viên (2) và admin (3). -->
                <c:if test="${sessionScope.user.maVaiTro.maVaiTro == 2 or sessionScope.user.maVaiTro.maVaiTro == 3}">
                    <a href="${pageContext.request.contextPath}/dashboard" class="text-sm font-bold text-brand-accent hover:text-white transition flex items-center gap-1">
                        ⚙️ Dashboard
                    </a>
                </c:if>

                <!-- Profile -->
                <a href="profile" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">
                    👤
                    <c:choose>
                        <c:when test="${not empty cookie.fullname.value}">
                            ${fn:replace(cookie.fullname.value, '_', ' ')}
                        </c:when>
                        <c:otherwise>Tài khoản</c:otherwise>
                    </c:choose>
                </a>

                <!-- Logout -->
                <a href="logout" class="text-sm text-brand-muted hover:text-red-400 transition flex items-center gap-1" title="Đăng xuất">
                    🚪 Thoát
                </a>
            </div>
        </nav>

        <div class="bg-brand-card py-20 px-6 text-center border-b border-brand-dark">
            <h1 class="text-5xl font-serif font-bold text-white mb-4">Nông Sản Sạch Từ Nông Trại Tới Tay Bạn</h1>            <p class="text-brand-muted max-w-2xl mx-auto mb-8">Trải nghiệm hương vị tươi ngon, nguyên bản từ những vùng trồng trọt tốt nhất Việt Nam.</p>
            <a href="products" class="inline-block bg-brand-primary text-brand-dark font-bold px-8 py-3 rounded-full hover:bg-green-500 transition shadow-lg shadow-brand-primary/20">
                Mua sắm ngay
            </a>
        </div>

        <div class="max-w-7xl mx-auto px-6 py-12">
            <div class="mb-16">
                <h2 class="text-2xl font-serif font-bold text-white mb-6 border-l-4 border-brand-primary pl-3">Danh mục sản phẩm</h2>
                <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                    <c:choose>
                        <c:when test="${not empty listCategories}">
                            <c:forEach items="${listCategories}" var="dm">
                                <a href="products?categoryId=${dm.maDanhMuc}" class="bg-brand-card border border-brand-dark p-4 rounded-xl text-center hover:-translate-y-1 hover:border-brand-primary transition duration-300">
                                    <div class="w-16 h-16 bg-brand-dark rounded-full mx-auto mb-3 flex items-center justify-center text-2xl">
                                        🌱
                                    </div>
                                    <h3 class="text-sm font-bold text-white">${dm.tenDanhMuc}</h3>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <a href="products" class="bg-brand-card border border-brand-dark p-4 rounded-xl text-center hover:-translate-y-1 hover:border-brand-primary transition duration-300">
                                <div class="w-16 h-16 bg-brand-dark rounded-full mx-auto mb-3 flex items-center justify-center text-2xl">🥬</div>
                                <h3 class="text-sm font-bold text-white">Rau củ quả</h3>
                            </a>
                            <a href="products" class="bg-brand-card border border-brand-dark p-4 rounded-xl text-center hover:-translate-y-1 hover:border-brand-primary transition duration-300">
                                <div class="w-16 h-16 bg-brand-dark rounded-full mx-auto mb-3 flex items-center justify-center text-2xl">🍎</div>
                                <h3 class="text-sm font-bold text-white">Trái cây</h3>
                            </a>
                            <a href="products" class="bg-brand-card border border-brand-dark p-4 rounded-xl text-center hover:-translate-y-1 hover:border-brand-primary transition duration-300">
                                <div class="w-16 h-16 bg-brand-dark rounded-full mx-auto mb-3 flex items-center justify-center text-2xl">🌾</div>
                                <h3 class="text-sm font-bold text-white">Gạo & Ngũ cốc</h3>
                            </a>
                            <a href="products" class="bg-brand-card border border-brand-dark p-4 rounded-xl text-center hover:-translate-y-1 hover:border-brand-primary transition duration-300">
                                <div class="w-16 h-16 bg-brand-dark rounded-full mx-auto mb-3 flex items-center justify-center text-2xl">🥩</div>
                                <h3 class="text-sm font-bold text-white">Thịt & Trứng</h3>
                            </a>
                            <a href="products" class="bg-brand-card border border-brand-dark p-4 rounded-xl text-center hover:-translate-y-1 hover:border-brand-primary transition duration-300">
                                <div class="w-16 h-16 bg-brand-dark rounded-full mx-auto mb-3 flex items-center justify-center text-2xl">🦐</div>
                                <h3 class="text-sm font-bold text-white">Thủy hải sản</h3>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div>
                <div class="flex justify-between items-end mb-6">
                    <h2 class="text-2xl font-serif font-bold text-white border-l-4 border-brand-accent pl-3">Sản phẩm nổi bật</h2>
                    <a href="products" class="text-sm text-brand-primary hover:underline">Xem tất cả &rarr;</a>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <c:forEach items="${listProducts}" var="p" end="7">
                        <div class="bg-brand-card border border-brand-dark rounded-xl overflow-hidden group hover:border-brand-primary transition duration-300 flex flex-col">
                            <a href="productdetail?id=${p.maSP}" class="block relative overflow-hidden aspect-square">
                                <img src="${pageContext.request.contextPath}/${p.hinhAnh}" alt="${p.tenSP}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                                <div class="absolute top-2 right-2 bg-brand-dark/80 backdrop-blur text-xs font-bold px-2 py-1 rounded text-brand-primary">
                                    ${p.maDanhMuc.tenDanhMuc}
                                </div>
                            </a>
                            <div class="p-4 flex flex-col flex-grow">
                                <a href="productdetail?id=${p.maSP}" class="text-lg font-bold text-white hover:text-brand-primary transition line-clamp-1 mb-1">${p.tenSP}</a>
                                <p class="text-xl font-bold text-brand-accent mb-4">${p.donGia}đ <span class="text-sm text-brand-muted font-normal">/${p.donViTinh}</span></p>

                                <div class="mt-auto flex gap-2">
                                    <a href="productdetail?id=${p.maSP}" class="flex-1 text-center bg-brand-dark border border-brand-muted text-brand-text py-2 rounded hover:bg-white/10 transition text-sm">Chi tiết</a>
                                    <form action="cart" method="GET" class="flex-1">
                                        <input type="hidden" name="action" value="quickAdd">
                                        <input type="hidden" name="productId" value="${p.maSP}">
                                        <button type="submit" class="w-full bg-brand-primary text-brand-dark py-2 rounded font-bold hover:bg-green-500 transition text-sm">Thêm 🛒</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </body>
</html>
