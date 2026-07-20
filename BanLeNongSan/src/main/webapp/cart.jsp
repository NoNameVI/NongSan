<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ Hàng Của Bạn - Nông Sản Việt</title>
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

        <!-- Navbar (Tích hợp logic từ code cũ của bạn) -->
        <nav class="flex flex-wrap items-center justify-between px-10 py-4 bg-brand-dark text-brand-text border-b border-brand-card sticky top-0 z-50 gap-4">
            <a href="home" class="flex items-center gap-2 text-xl font-bold text-brand-primary">
                <span>🌿</span> Nông Sản Việt
            </a>

            <!-- Tìm kiếm (logic cũ) -->
            <div class="flex-grow flex justify-center w-full md:w-auto order-3 md:order-none">
                <form action="product" method="GET" class="w-full max-w-md flex">
                    <input type="text" name="search" class="w-full bg-brand-card border border-brand-muted/30 rounded-l px-4 py-2 text-white focus:outline-none focus:border-brand-primary" placeholder="Tìm kiếm sản phẩm...">
                    <button type="submit" class="bg-brand-primary text-brand-dark px-4 py-2 rounded-r font-bold hover:bg-green-500">🔍</button>
                </form>
            </div>

            <!-- User Auth (logic cũ) -->
            <div class="flex items-center gap-3">
                <c:if test="${sessionScope.user.maVaiTro.maVaiTro == 2 or sessionScope.user.maVaiTro.maVaiTro == 3}">
                    <a href="${pageContext.request.contextPath}/dashboard" class="text-sm font-bold text-brand-accent hover:text-white transition flex items-center gap-1">
                        ⚙️ Dashboard
                    </a>
                </c:if>
                <a href="profile" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition">
                    👤
                    <c:choose>
                        <c:when test="${not empty cookie.fullname.value}">
                            ${fn:replace(cookie.fullname.value, '_', ' ')}
                        </c:when>
                        <c:otherwise>TÀI KHOẢN</c:otherwise>
                    </c:choose>
                </a>
                <a href="logout" class="text-sm text-brand-muted hover:text-red-400 transition" title="Đăng xuất">🚪 Thoát</a>
            </div>
        </nav>

        <!-- Main Cart Container -->
        <div class="max-w-3xl mx-auto px-4 py-12">

            <a href="products" class="inline-flex items-center text-sm font-bold text-brand-primary hover:underline mb-6">
                &larr; Tiếp tục mua sắm
            </a>

            <h2 class="text-3xl font-serif font-bold text-white mb-8 border-l-4 border-brand-primary pl-3">
                Giỏ hàng của bạn
                <c:if test="${not empty cartItems}">
                    <span class="text-brand-muted text-lg font-normal ml-2">(${fn:length(cartItems)} sản phẩm)</span>
                </c:if>
            </h2>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <!-- Giỏ hàng trống -->
                    <div class="bg-brand-card border border-brand-dark rounded-xl p-12 text-center shadow-lg">
                        <span class="text-6xl mb-4 block opacity-50">🛒</span>
                        <p class="text-xl text-white font-bold mb-6">Giỏ hàng của bạn đang trống.</p>
                        <a href="products" class="inline-block bg-transparent border-2 border-brand-primary text-brand-primary font-bold px-8 py-3 rounded hover:bg-brand-primary hover:text-brand-dark transition">
                            Quay lại cửa hàng
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- Danh sách sản phẩm -->
                    <div class="bg-brand-card border border-brand-dark rounded-xl p-6 mb-6 shadow-lg">
                        <c:set var="tongTienGiaoDich" value="0" />

                        <div class="space-y-6">
                            <c:forEach items="${cartItems}" var="item" varStatus="loop">
                                <c:set var="thanhTienItem" value="${item.sanPham.donGia * item.soLuong}" />

                                <div class="flex items-center gap-4 pb-6 ${!loop.last ? 'border-b border-brand-dark' : ''}">

                                    <!-- Hình ảnh -->
                                    <div class="w-20 h-20 bg-brand-dark rounded-lg overflow-hidden flex-shrink-0">
                                        <img src=".${item.sanPham.hinhAnh}" alt="${item.sanPham.tenSP}" class="w-full h-full object-cover" onerror="this.style.display='none'">
                                    </div>

                                    <!-- Thông tin -->
                                    <div class="flex-grow">
                                        <div class="font-bold text-white text-lg line-clamp-1">${item.sanPham.tenSP}</div>
                                        <div class="text-brand-muted text-sm mt-1">
                                            ${item.sanPham.donViTinh} &middot; <fmt:formatNumber value="${item.sanPham.donGia}" pattern="#,##0đ"/>
                                        </div>
                                    </div>

                                    <!-- Tăng giảm số lượng -->
                                    <form action="cart" method="POST" class="flex items-center bg-brand-dark rounded border border-brand-muted/20 p-1">
                                        <input type="hidden" name="action" value="update" />
                                        <input type="hidden" name="productId" value="${item.sanPham.maSP}" />

                                        <button type="submit" name="quantity" value="${item.soLuong - 1}" class="w-8 h-8 flex items-center justify-center text-white hover:text-brand-primary font-bold text-lg leading-none">&minus;</button>
                                        <input type="text" value="${item.soLuong}" class="w-10 bg-transparent text-center text-white font-bold text-sm outline-none pointer-events-none" readonly />
                                        <button type="submit" name="quantity" value="${item.soLuong + 1}" class="w-8 h-8 flex items-center justify-center text-white hover:text-brand-primary font-bold text-lg leading-none">&plus;</button>
                                    </form>

                                    <!-- Nút xóa -->
                                    <form action="cart" method="POST" class="ml-2">
                                        <input type="hidden" name="action" value="remove" />
                                        <input type="hidden" name="productId" value="${item.sanPham.maSP}" />
                                        <button type="submit" class="p-2 text-brand-muted hover:text-red-500 transition text-xl" title="Xóa sản phẩm">
                                            🗑️
                                        </button>
                                    </form>

                                    <!-- Tổng phụ -->
                                    <div class="w-24 text-right font-bold text-brand-accent text-lg">
                                        <fmt:formatNumber value="${thanhTienItem}" pattern="#,##0đ"/>
                                    </div>
                                </div>

                                <c:set var="tongTienGiaoDich" value="${tongTienGiaoDich + thanhTienItem}" />
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Logic Tính tiền (Giữ nguyên) -->
                    <c:set var="phiShip" value="20000" />
                    <c:set var="freeshipThreshold" value="150000" />
                    <c:if test="${tongTienGiaoDich >= freeshipThreshold}">
                        <c:set var="phiShip" value="0" />
                    </c:if>
                    <c:set var="tongCong" value="${tongTienGiaoDich + phiShip}" />

                    <!-- Tóm tắt đơn hàng -->
                    <div class="bg-brand-card border border-brand-dark rounded-xl p-6 shadow-lg">
                        <div class="flex justify-between text-brand-muted mb-3">
                            <span>Tạm tính</span>
                            <span class="text-white"><fmt:formatNumber value="${tongTienGiaoDich}" pattern="#,##0đ"/></span>
                        </div>
                        <div class="flex justify-between text-brand-muted mb-4">
                            <span>Phí vận chuyển</span>
                            <span class="text-white">
                                <c:choose>
                                    <c:when test="${phiShip == 0}"><span class="text-brand-primary font-bold">Miễn phí</span></c:when>
                                    <c:otherwise><fmt:formatNumber value="${phiShip}" pattern="#,##0đ"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="border-t border-dashed border-brand-muted/30 my-4"></div>

                        <div class="flex justify-between items-center mb-6">
                            <span class="text-xl font-bold text-white">Tổng cộng</span>
                            <span class="text-2xl font-bold text-brand-primary"><fmt:formatNumber value="${tongCong}" pattern="#,##0đ"/></span>
                        </div>

                        <!-- Form Đặt Hàng -->
                        <form action="checkout" method="GET">
                            <input type="hidden" name="tongTien" value="${tongCong}">
                            <button type="submit" class="w-full bg-brand-primary text-brand-dark py-4 rounded-lg font-bold text-lg hover:bg-green-500 transition shadow-lg shadow-brand-primary/20">
                                Tiến hành thanh toán
                            </button>
                        </form>

                        <!-- Thông báo Freeship -->
                        <c:if test="${phiShip > 0}">
                            <div class="text-center mt-4 text-sm text-brand-accent">
                                Mua thêm <span class="font-bold"><fmt:formatNumber value="${freeshipThreshold - tongTienGiaoDich}" pattern="#,##0đ"/></span> để được miễn phí vận chuyển!
                            </div>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>
