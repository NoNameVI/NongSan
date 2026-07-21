<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ Sơ Cá Nhân - Rau Thép</title>
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
        <!-- Tích hợp Tailwind CSS và cấu hình màu sắc tương tự trang chủ[cite: 17] -->
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
    <body class="bg-brand-dark text-brand-text font-sans antialiased min-h-screen flex flex-col">

        <!-- Navbar đồng bộ với trang chủ[cite: 17] -->
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
                    <a href="products" class="hover:text-brand-primary transition">Cửa hàng</a>
                    <a href="aboutus.jsp" class="hover:text-brand-primary transition">Về chúng tôi</a>
                </div>
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
                        <a href="profile" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark bg-brand text-brand-primary transition transition flex items-center gap-1">👤 ${fn:replace(cookie.fullname.value, '_', ' ')}</a>
                        <a href="logout" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1" title="Đăng xuất">🚪 Thoát</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">👤 Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>

        <!-- Container chính -->
        <div class="flex-grow flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
            <div class="max-w-2xl w-full space-y-8 bg-brand-card p-8 md:p-10 rounded-2xl border border-brand-dark shadow-2xl">
                <div>
                    <h2 class="text-3xl font-bold text-white border-l-4 border-brand-primary pl-4 mb-2">Hồ Sơ Cá Nhân</h2>
                    <p class="text-brand-muted pl-5 text-sm">Quản lý thông tin cá nhân và địa chỉ giao hàng của bạn.</p>
                </div>

                <!-- Hiển thị thông báo trạng thái cập nhật[cite: 16] -->
                <c:if test="${not empty msg}">
                    <div class="bg-green-900/40 border border-brand-primary text-brand-primary px-4 py-3 rounded relative text-center" role="alert">
                        <span class="block sm:inline">${msg}</span>
                    </div>
                </c:if>
                <c:if test="${not empty err}">
                    <div class="bg-red-900/40 border border-red-500 text-red-400 px-4 py-3 rounded relative text-center" role="alert">
                        <span class="block sm:inline">${err}</span>
                    </div>
                </c:if>

                <!-- Form thông tin[cite: 16] -->
                <form action="profile" method="POST" class="mt-8 space-y-6">
                    <div class="space-y-4">
                        <!-- Email (Tài khoản - Readonly)[cite: 16] -->
                        <div>
                            <label for="email" class="block text-sm font-medium text-brand-muted mb-1">Email (Tài khoản)</label>
                            <input type="email" id="email" value="${user.email}" readonly
                                   class="w-full bg-brand-dark border border-brand-dark rounded-lg px-4 py-3 text-brand-muted cursor-not-allowed opacity-80 focus:outline-none">
                        </div>

                        <!-- Họ và tên[cite: 16] -->
                        <div>
                            <label for="hoTen" class="block text-sm font-medium text-brand-muted mb-1">Họ và tên</label>
                            <input type="text" id="hoTen" name="hoTen" value="${user.hoTen}" required
                                   class="w-full bg-brand-dark border border-brand-dark rounded-lg px-4 py-3 text-white focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition">
                        </div>

                        <!-- Số điện thoại[cite: 16] -->
                        <div>
                            <label for="sdt" class="block text-sm font-medium text-brand-muted mb-1">Số điện thoại</label>
                            <input type="tel" id="sdt" name="sdt" value="${user.sdt}" pattern="[0-9]{10,11}" required
                                   class="w-full bg-brand-dark border border-brand-dark rounded-lg px-4 py-3 text-white focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition">
                        </div>

                        <!-- Địa chỉ[cite: 16] -->
                        <div>
                            <label for="diaChi" class="block text-sm font-medium text-brand-muted mb-1">Địa chỉ giao hàng</label>
                            <textarea id="diaChi" name="diaChi" rows="3" required
                                      class="w-full bg-brand-dark border border-brand-dark rounded-lg px-4 py-3 text-white focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition">${user.diaChi}</textarea>
                        </div>
                    </div>

                    <!-- Nút hành động[cite: 16] -->
                    <div class="flex flex-col sm:flex-row gap-4 pt-4 border-t border-brand-dark">
                        <button type="submit" class="flex-1 bg-brand-primary text-brand-dark font-bold px-6 py-3 rounded-lg hover:bg-green-500 transition text-center shadow-lg shadow-brand-primary/20">
                            Lưu thay đổi
                        </button>
                        <a href="home" class="flex-1 bg-brand-dark border border-brand-muted text-brand-text font-medium px-6 py-3 rounded-lg hover:bg-white/10 transition text-center">
                            Quay lại trang chủ
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>