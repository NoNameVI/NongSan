<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Về chúng tôi - Rau Thép</title>
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
    <body class="min-h-screen bg-brand-dark text-brand-text font-sans antialiased">
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
                    <a href="aboutus.jsp" class="text-brand-primary transition">Về chúng tôi</a>
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
                        <a href="profile" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">👤 ${fn:replace(cookie.fullname.value, '_', ' ')}</a>
                        <a href="logout" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1" title="Đăng xuất">🚪 Thoát</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">👤 Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto px-6 py-16">
            <section class="rounded-3xl border border-brand-card bg-brand-card/90 p-8 md:p-12 shadow-2xl">
                <div class="mb-8">
                    <p class="text-sm uppercase tracking-[0.3em] text-brand-primary font-semibold">About Us</p>
                    <h1 class="text-4xl md:text-5xl font-bold text-white mt-3">Chúng tôi mang rau củ sạch, tươi ngon và đáng tin cậy đến từng mái nhà</h1>
                    <p class="mt-5 text-lg text-brand-muted max-w-3xl leading-relaxed">
                        Rau Thép là dự án thương mại điện tử dành cho việc kết nối người tiêu dùng với các sản phẩm nông sản tươi sạch, an toàn và thân thiện với sức khỏe. Chúng tôi tin rằng mỗi bữa ăn tốt đẹp bắt đầu từ những nguồn nguyên liệu đáng tin cậy.
                    </p>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-10">
                    <div class="rounded-2xl border border-brand-dark bg-brand-dark/70 p-6">
                        <h2 class="text-xl font-semibold text-white">Sứ mệnh</h2>
                        <p class="mt-3 text-brand-muted leading-relaxed">
                            Cung cấp các sản phẩm nông sản chất lượng, được chọn lọc kỹ lưỡng và giao đến tận nơi nhanh chóng, giúp khách hàng dễ dàng mua sắm và an tâm sử dụng.
                        </p>
                    </div>
                    <div class="rounded-2xl border border-brand-dark bg-brand-dark/70 p-6">
                        <h2 class="text-xl font-semibold text-white">Tầm nhìn</h2>
                        <p class="mt-3 text-brand-muted leading-relaxed">
                            Trở thành một nền tảng mua sắm nông sản trực tuyến đáng tin cậy, góp phần nâng cao chất lượng cuộc sống và thúc đẩy tiêu dùng bền vững.
                        </p>
                    </div>
                    <div class="rounded-2xl border border-brand-dark bg-brand-dark/70 p-6">
                        <h2 class="text-xl font-semibold text-white">Giá trị cốt lõi</h2>
                        <p class="mt-3 text-brand-muted leading-relaxed">
                            Minh bạch, chất lượng, tận tâm và luôn đặt trải nghiệm khách hàng lên hàng đầu trong mọi hoạt động.
                        </p>
                    </div>
                </div>

                <!-- Cập nhật chi tiết Nhóm Phát Triển -->
                <section class="mt-12 rounded-2xl border border-brand-dark bg-brand-dark/70 p-8">
                    <h2 class="text-2xl font-semibold text-white border-l-4 border-brand-primary pl-3 mb-6">Đội ngũ thực hiện dự án</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        <!-- Thành viên 1 -->
                        <div class="rounded-xl border border-brand-card bg-brand-card/70 p-5 hover:border-brand-primary transition duration-300">
                            <h3 class="text-lg font-bold text-brand-primary">Thức</h3>
                            <p class="text-sm font-semibold text-white mt-1">Quản Lý Người Dùng & Xác Thực</p>
                            <p class="mt-2 text-sm text-brand-muted">Phụ trách logic đăng nhập, đăng ký, hồ sơ cá nhân và chức năng khóa/mở khóa tài khoản Admin.</p>
                        </div>

                        <!-- Thành viên 2 -->
                        <div class="rounded-xl border border-brand-card bg-brand-card/70 p-5 hover:border-brand-primary transition duration-300">
                            <h3 class="text-lg font-bold text-brand-primary">Thanh</h3>
                            <p class="text-sm font-semibold text-white mt-1">Quản Lý Sản Phẩm & Danh Mục</p>
                            <p class="mt-2 text-sm text-brand-muted">Phụ trách hiển thị sản phẩm, phân trang, chi tiết sản phẩm và các chức năng thêm/sửa/xóa kho hàng.</p>
                        </div>

                        <!-- Thành viên 3 -->
                        <div class="rounded-xl border border-brand-card bg-brand-card/70 p-5 hover:border-brand-primary transition duration-300">
                            <h3 class="text-lg font-bold text-brand-primary">Hoàng</h3>
                            <p class="text-sm font-semibold text-white mt-1">Quản Lý Giỏ Hàng & Thanh Toán</p>
                            <p class="mt-2 text-sm text-brand-muted">Xây dựng luồng giỏ hàng, cập nhật số lượng, thu thập thông tin giao hàng và chọn phương thức thanh toán.</p>
                        </div>

                        <!-- Thành viên 4 -->
                        <div class="rounded-xl border border-brand-card bg-brand-card/70 p-5 hover:border-brand-primary transition duration-300">
                            <h3 class="text-lg font-bold text-brand-primary">Thành</h3>
                            <p class="text-sm font-semibold text-white mt-1">Quản Lý Đơn Hàng & Thống Kê</p>
                            <p class="mt-2 text-sm text-brand-muted">Xử lý tạo đơn hàng bằng Transaction, trừ tồn kho, cập nhật trạng thái đơn và vẽ biểu đồ Dashboard.</p>
                        </div>

                        <!-- Thành viên 5 -->
                        <div class="rounded-xl border border-brand-card bg-brand-card/70 p-5 hover:border-brand-primary transition duration-300">
                            <h3 class="text-lg font-bold text-brand-primary">Hân</h3>
                            <p class="text-sm font-semibold text-white mt-1">Thiết Kế Giao Diện</p>
                            <p class="mt-2 text-sm text-brand-muted">Giao Diện Tài Khoản & Trang Chủ (Hỗ trợ xử lý profile, đồng bộ cookie và giao diện tĩnh/trang chủ)..</p>
                        </div>

                        <!-- Thành viên 6 -->
                        <div class="rounded-xl border border-brand-card bg-brand-card/70 p-5 hover:border-brand-primary transition duration-300">
                            <h3 class="text-lg font-bold text-brand-primary">Vy</h3>
                            <p class="text-sm font-semibold text-white mt-1">Thiết Kế Giao Diện</p>
                            <p class="mt-2 text-sm text-brand-muted">Đánh Giá Sản Phảng, Nhà Cung Cấp & Giao Diện Giỏ Hàng/Thanh Toán.</p>
                        </div>
                    </div>

                    <!-- Mục tiêu dự án -->
                    <div class="mt-8 rounded-xl border border-brand-card bg-brand-card/70 p-6">
                        <h3 class="text-lg font-semibold text-brand-primary">Mục tiêu dự án</h3>
                        <ul class="mt-3 space-y-2 text-brand-muted">
                            <li>• Xây dựng một hệ thống bán hàng nông sản trực tuyến dễ sử dụng</li>
                            <li>• Tăng trải nghiệm mua sắm và kết nối khách hàng với sản phẩm tươi sạch</li>
                            <li>• Tạo nền tảng mở rộng cho các tính năng bán hàng và quản lý sau này</li>
                        </ul>
                    </div>
                </section>

                <section class="mt-10 flex flex-wrap gap-4">
                    <a href="home" class="inline-block rounded-full bg-brand-primary px-6 py-3 font-semibold text-brand-dark hover:bg-green-500 transition">
                        Quay về trang chủ
                    </a>
                    <a href="products" class="inline-block rounded-full border border-brand-primary px-6 py-3 font-semibold text-brand-primary hover:bg-brand-primary hover:text-brand-dark transition">
                        Khám phá sản phẩm
                    </a>
                </section>
            </section>
        </main>
    </body>
</html>