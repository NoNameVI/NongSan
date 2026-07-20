<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán - Nông Sản Việt</title>
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

        <!-- Navbar Checkout -->
        <nav class="flex items-center justify-between px-10 py-4 bg-brand-card text-brand-text border-b border-brand-dark sticky top-0 z-50">
            <!-- Cột trái -->
            <div class="w-1/3">
                <a href="cart" class="inline-flex items-center gap-2 text-sm font-bold text-brand-primary hover:underline">
                    &larr; Quay lại giỏ hàng
                </a>
            </div>

            <!-- Cột giữa -->
            <div class="w-1/3 text-center text-xl font-bold text-white tracking-wide">
                THANH TOÁN AN TOÀN
            </div>

            <!-- Cột phải (Hồ sơ & Đăng xuất) -->
            <div class="w-1/3 flex justify-end items-center gap-4">
                <c:if test="${sessionScope.user.maVaiTro.maVaiTro == 2}">
                    <a href="${pageContext.request.contextPath}/dashboard" class="text-sm font-bold text-brand-accent hover:text-white transition flex items-center gap-1">
                        ⚙️ Dashboard
                    </a>
                </c:if>

                <a href="profile" class="text-sm font-bold bg-brand-dark px-4 py-2 rounded border border-brand-card hover:border-brand-primary transition flex items-center gap-1">
                    👤
                    <c:choose>
                        <c:when test="${not empty cookie.fullname.value}">
                            ${fn:replace(cookie.fullname.value, '_', ' ')}
                        </c:when>
                        <c:otherwise>Tài khoản</c:otherwise>
                    </c:choose>
                </a>

                <a href="logout" class="text-sm text-brand-muted hover:text-red-400 transition flex items-center gap-1" title="Đăng xuất">
                    🚪 Thoát
                </a>
            </div>
        </nav>


        <div class="max-w-5xl mx-auto px-6 py-12">

            <h2 class="text-3xl font-serif font-bold text-white mb-8 border-l-4 border-brand-primary pl-3">Thông Tin Đặt Hàng</h2>

            <!-- Thông báo lỗi (nếu có) -->
            <c:if test="${not empty err}">
                <div class="bg-red-500/10 border border-red-500 text-red-500 px-4 py-3 rounded mb-6 font-medium">
                    ⚠️ ${err}
                </div>
            </c:if>

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">

                <!-- Cột Form Nhập Liệu -->
                <div class="lg:col-span-7">
                    <div class="bg-brand-card border border-brand-dark p-6 md:p-8 rounded-xl shadow-lg">
                        <h3 class="text-xl font-bold text-white mb-6 border-b border-brand-dark pb-3">Địa chỉ giao hàng</h3>

                        <!-- Gắn ID cho form để liên kết với select bên ngoài form -->
                        <form id="checkoutForm" action="checkout" method="POST" class="space-y-5">

                            <!-- Input SĐT -->
                            <div>
                                <label for="phone" class="block text-sm font-medium text-brand-muted mb-2">
                                    Số điện thoại liên hệ <span class="text-red-500">*</span>
                                </label>
                                <input type="tel" id="phone" name="phone" value="${user.sdt}" required placeholder="Nhập số điện thoại"
                                       class="w-full bg-brand-dark border border-brand-muted/30 rounded-lg px-4 py-3 text-white placeholder-brand-muted focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition">
                            </div>

                            <!-- Input Địa Chỉ -->
                            <div>
                                <label for="address" class="block text-sm font-medium text-brand-muted mb-2">
                                    Địa chỉ nhận hàng chi tiết <span class="text-red-500">*</span>
                                </label>
                                <textarea id="address" name="address" rows="3" required placeholder="Số nhà, Tên đường, Phường/Xã, Quận/Huyện..."
                                          class="w-full bg-brand-dark border border-brand-muted/30 rounded-lg px-4 py-3 text-white placeholder-brand-muted focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition resize-none">${user.diaChi}</textarea>
                            </div>

                            <div class="pt-4">
                                <button type="submit" class="w-full bg-brand-primary text-brand-dark py-4 rounded-lg font-bold text-lg hover:bg-green-500 transition shadow-lg shadow-brand-primary/20">
                                    XÁC NHẬN & ĐẶT HÀNG
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Cột Tóm tắt Đơn Hàng -->
                <div class="lg:col-span-5">
                    <div class="bg-brand-dark border border-brand-card p-6 md:p-8 rounded-xl shadow-lg sticky top-24">
                        <h3 class="text-xl font-bold text-white mb-6 border-b border-brand-card pb-3">Đơn hàng của bạn</h3>

                        <div class="space-y-4 mb-6 max-h-60 overflow-y-auto pr-2 custom-scrollbar">
                            <c:forEach items="${cartItems}" var="item">
                                <div class="flex justify-between items-center text-sm">
                                    <span class="text-brand-text truncate pr-4" title="${item.sanPham.tenSP}">
                                        ${item.sanPham.tenSP} <span class="text-brand-muted">x${item.soLuong}</span>
                                    </span>
                                    <span class="font-bold text-white whitespace-nowrap">
                                        <fmt:formatNumber value="${item.sanPham.donGia * item.soLuong}" pattern="#,##0đ"/>
                                    </span>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="border-t border-dashed border-brand-muted/30 my-4"></div>

                        <div class="flex justify-between items-center pt-2 mb-6">
                            <span class="text-lg font-bold text-brand-muted">Tổng thanh toán</span>
                            <span class="text-2xl font-bold text-brand-accent">
                                <fmt:formatNumber value="${not empty tongTien ? tongTien : 0}" pattern="#,##0đ"/>
                            </span>
                        </div>

                        <!-- PHƯƠNG THỨC THANH TOÁN (Liên kết với form thông qua form="checkoutForm") -->
                        <div class="bg-brand-card p-4 rounded-lg border border-brand-muted/20">
                            <label for="paymentMethod" class="block text-sm font-bold text-white mb-3">
                                Phương thức thanh toán
                            </label>
                            <div class="relative">
                                <select id="paymentMethod" name="paymentMethod" form="checkoutForm"
                                        class="w-full bg-brand-dark border border-brand-muted/30 rounded-lg px-4 py-3 text-white appearance-none focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition cursor-pointer">
                                    <option value="COD">Thanh toán khi nhận hàng (COD)</option>
                                    <option value="Ví điện tử">Ví điện tử (Momo, ZaloPay)</option>
                                    <option value="Chuyển khoản">Chuyển khoản ngân hàng</option>
                                </select>
                                <!-- Custom mũi tên dropdown -->
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-4 text-brand-primary">
                                    <svg class="w-4 h-4 fill-current" viewBox="0 0 20 20"><path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/></svg>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Thêm style cho scrollbar của giỏ hàng thu gọn -->
        <style>
            .custom-scrollbar::-webkit-scrollbar {
                width: 4px;
            }
            .custom-scrollbar::-webkit-scrollbar-track {
                background: #112518;
            }
            .custom-scrollbar::-webkit-scrollbar-thumb {
                background: #4ade80;
                border-radius: 10px;
            }

            /* Tùy chỉnh màu nền cho các option trong dropdown */
            select#paymentMethod option {
                background-color: #183625;
                color: #e2e8f0;
            }
        </style>
    </body>
</html>