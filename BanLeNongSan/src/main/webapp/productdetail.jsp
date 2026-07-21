<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${product.tenSP} - Rau Thép</title>
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
    <body class="bg-brand-dark text-brand-text font-sans antialiased min-h-screen">

        <!-- NAVBAR -->
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
                        <a href="profile" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">👤 ${fn:replace(cookie.fullname.value, '_', ' ')}</a>
                        <a href="logout" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1" title="Đăng xuất">🚪 Thoát</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="text-sm font-bold bg-brand-card px-4 py-2 rounded border border-brand-dark hover:border-brand-primary transition flex items-center gap-1">👤 Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>

        <!-- BREADCRUMB -->
        <div class="max-w-7xl mx-auto px-8 py-6 text-sm text-brand-muted">
            <a href="home" class="hover:text-brand-primary">Trang chủ</a> >
            <a href="products" class="hover:text-brand-primary">Cửa hàng</a> >
            <span class="text-brand-text">${product.tenSP}</span>
        </div>

        <!-- MAIN PRODUCT SECTION -->
        <main class="max-w-7xl mx-auto px-8 pb-16">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-12">

                <!-- Cột trái: Hình ảnh sản phẩm -->
                <div class="space-y-4">
                    <!-- Ảnh chính -->
                    <div class="aspect-square bg-brand-card rounded-2xl overflow-hidden border border-white/5 relative group">
                        <img src=".${product.hinhAnh}" alt="${product.tenSP}" class="w-full h-full object-cover transition duration-500 group-hover:scale-105">
                        <div class="absolute top-4 left-4 bg-brand-dark/60 backdrop-blur-md px-3 py-1 rounded-full text-xs font-bold text-brand-primary border border-brand-primary/30">
                            ✨ Hữu cơ 100%
                        </div>
                    </div>

                    <!-- Danh sách ảnh phụ -->
                    <c:if test="${not empty listImages}">
                        <div class="flex gap-4 overflow-x-auto pb-2 scrollbar-hide">
                            <img src=".${product.hinhAnh}" class="w-24 h-24 rounded-xl object-cover border-2 border-brand-primary cursor-pointer hover:opacity-80 transition">
                            <c:forEach items="${listImages}" var="img">
                                <img src=".${img.duongDan}" class="w-24 h-24 rounded-xl object-cover border border-brand-card cursor-pointer hover:border-brand-primary transition">
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- Cột phải: Thông tin & Thêm vào giỏ hàng -->
                <div class="flex flex-col justify-center">
                    <h1 class="text-4xl font-bold text-white mb-2">${product.tenSP}</h1>

                    <div class="flex items-center gap-4 mb-6">
                        <div class="text-brand-accent text-3xl font-bold">${product.donGia} ₫</div>
                        <div class="text-sm px-2 py-1 bg-white/5 rounded text-brand-muted">
                            Kho: <span class="text-brand-text font-semibold">${product.soLuongTon}</span>
                        </div>
                    </div>

                    <!-- Thông tin chi tiết sản phẩm -->
                    <div class="flex flex-col gap-5 mt-6 mb-8">
                        <!-- Mô tả -->
                        <div class="border-l-4 border-brand-primary pl-4">
                            <p class="text-brand-text leading-relaxed">
                                ${product.moTa}
                            </p>
                        </div>
                        <!-- Nhà cung cấp -->
                        <div class="border-l-4 border-brand-primary pl-4">
                            <p class="text-brand-muted leading-relaxed">
                                <span class="font-semibold text-white">Nhà cung cấp:</span> ${product.maNCC.tenNCC}
                            </p>
                        </div>

                        <!-- Ngày nhập -->
                        <div class="border-l-4 border-brand-accent pl-4">
                            <p class="text-brand-muted leading-relaxed">
                                <span class="font-semibold text-white">Ngày nhập:</span> ${product.ngayNhap.date}/${product.ngayNhap.month + 1}/${product.ngayNhap.year + 1900}
                            </p>
                        </div>

                        <!-- Phân loại -->
                        <div class="border-l-4 border-brand-accent pl-4">
                            <p class="text-brand-muted leading-relaxed">
                                <span class="font-semibold text-white">Phân loại:</span> ${product.maDanhMuc.tenDanhMuc}
                            </p>
                        </div>

                        <!-- Bạn có thể copy pattern này để thêm các thuộc tính khác (Ví dụ: Xuất xứ, Trọng lượng...) -->
                    </div>


                    <!-- FORM THÊM VÀO GIỎ HÀNG -->
                    <form action="cart" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.maSP}">

                        <div class="flex items-end gap-4 mb-6">
                            <div>
                                <label class="block text-xs font-bold text-brand-muted mb-2 uppercase tracking-wider">Số lượng</label>
                                <div class="flex items-center bg-brand-card border border-brand-card rounded-xl overflow-hidden">
                                    <button type="button" class="px-4 py-3 text-brand-muted hover:text-white hover:bg-white/5 transition" onclick="decreaseQty()">-</button>
                                    <input type="number" id="qtyInput" name="quantity" value="1" min="1" max="${product.soLuongTon}" class="w-16 bg-transparent text-center font-bold text-white outline-none appearance-none">
                                    <button type="button" class="px-4 py-3 text-brand-muted hover:text-white hover:bg-white/5 transition" onclick="increaseQty()">+</button>
                                </div>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <button type="submit" class="flex-1 bg-brand-primary text-brand-dark py-4 rounded-xl font-bold text-lg flex items-center justify-center gap-2 hover:bg-green-500 hover:-translate-y-1 transition duration-300 shadow-[0_0_15px_rgba(74,222,128,0.2)]">
                                🛒 Thêm vào giỏ
                            </button>
                            <button type="submit" name="action" value="buyNow" class="flex-1 bg-brand-accent text-white py-4 rounded-xl font-bold text-lg hover:bg-orange-600 hover:-translate-y-1 transition duration-300 shadow-[0_0_15px_rgba(249,115,22,0.2)]">
                                💳 Mua ngay
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <!-- PHẦN ĐÁNH GIÁ (REVIEWS) -->
        <section class="border-t border-brand-card bg-brand-dark/50 pt-12 pb-20">
            <div class="max-w-7xl mx-auto px-8">
                <h2 class="text-2xl font-bold text-white mb-8 border-l-4 border-brand-accent pl-4">Đánh giá từ khách hàng</h2>

                <c:choose>
                    <c:when test="${not empty listReviews}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach items="${listReviews}" var="review">
                                <div class="bg-brand-card p-6 rounded-xl border border-white/5 hover:-translate-y-1 transition duration-300">
                                    <div class="flex items-center justify-between mb-4">
                                        <div class="font-bold text-white flex items-center gap-2">
                                            ${review.maKhachHang.hoTen}
                                        </div>
                                        <div class="text-brand-accent text-sm">
                                            <!-- Vẽ số sao tương ứng với review.soSao -->
                                            <c:forEach begin="1" end="${review.soSao}">⭐</c:forEach>
                                            </div>
                                        </div>
                                        <p class="text-brand-muted text-sm line-clamp-3">
                                            "${review.noiDung}"
                                    </p>
                                    <div class="text-xs text-brand-muted/50 mt-4 text-right">
                                        ${review.ngayDanhGia}
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12 bg-brand-card rounded-xl border border-dashed border-brand-muted/30">
                            <p class="text-4xl mb-2">🌱</p>
                            <p class="text-brand-muted">Chưa có đánh giá nào cho sản phẩm này.</p>
                            <p class="text-sm text-brand-primary mt-2">Hãy là người đầu tiên thưởng thức và đánh giá nhé!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- Script nhỏ điều khiển số lượng -->
        <script>
            function increaseQty() {
                let input = document.getElementById('qtyInput');
                let max = parseInt(input.getAttribute('max'));
                let currentVal = parseInt(input.value);
                if (currentVal < max) {
                    input.value = currentVal + 1;
                }
            }
            function decreaseQty() {
                let input = document.getElementById('qtyInput');
                let currentVal = parseInt(input.value);
                if (currentVal > 1) {
                    input.value = currentVal - 1;
                }
            }
        </script>
    </body>
</html>
