<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký tài khoản - Rau Thép</title>
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
        <!-- Nhúng Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <!-- Nhúng Tailwind CSS -->
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
    <body class="bg-brand-dark text-brand-text font-sans antialiased min-h-screen relative overflow-hidden">
        <!-- NAVBAR -->
        <nav class="flex items-center justify-between px-10 py-4 bg-brand-dark text-brand-text border-b border-brand-card sticky top-0 z-50">
            <!-- Cột trái: Logo + Links -->
            <div class="flex items-center gap-8">
                <a href="home" class="flex items-center gap-2 text-xl font-bold text-brand-primary cursor-pointer">
                    <span>🌿</span> Rau Thép
                </a>
                <div class="hidden xl:flex gap-6 text-sm font-medium">
                    <a href="home" class="hover:brand-primary transition">Trang chủ</a>
                    <a href="products" class="hover:text-brand-primary transition">Cửa hàng</a>
                    <a href="aboutus.jsp" class="hover:text-brand-primary transition">Về chúng tôi</a>
                </div>
            </div>
        </nav>

        <div class="min-h-[calc(100vh-80px)] flex items-center justify-center px-4 py-8 relative">

            <!-- Background Decor -->
            <div class="absolute top-[-10%] left-[-10%] w-96 h-96 bg-brand-primary/10 rounded-full blur-3xl"></div>
            <div class="absolute bottom-[-10%] right-[-10%] w-96 h-96 bg-brand-accent/10 rounded-full blur-3xl"></div>

            <!-- Mở rộng max-w-md thành max-w-3xl để form trải ngang[cite: 13] -->
            <div class="w-full max-w-3xl bg-brand-card/90 backdrop-blur-md border border-brand-dark p-8 md:p-10 rounded-2xl shadow-2xl relative z-10 my-auto">

                <!-- Header -->
                <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-14 h-14 rounded-full bg-brand-dark border-2 border-brand-primary mb-3 text-2xl shadow-[0_0_15px_rgba(74,222,128,0.2)]">
                        🌱
                    </div>
                    <h1 class="text-3xl font-bold text-white mb-2">Đăng ký</h1>
                    <p class="text-brand-muted text-sm">Tạo tài khoản mới để trải nghiệm dịch vụ.</p>
                </div>

                <!-- Bắt lỗi từ hệ thống -->
                <c:if test="${not empty err}">
                    <div class="bg-red-500/10 border border-red-500/50 text-red-400 px-4 py-3 rounded-lg mb-6 text-sm font-medium text-center flex items-center justify-center gap-2">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${err}
                    </div>
                </c:if>

                <!-- Form Đăng ký -->
                <form action="register" method="POST">

                    <!-- Sử dụng Grid chia 2 cột cho màn hình md trở lên[cite: 13] -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">

                        <!-- Họ và tên -->
                        <div>
                            <label for="hoten" class="block text-[11px] font-bold text-brand-muted mb-1.5 uppercase tracking-wider">Họ và tên</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <input type="text" id="hoten" name="hoTen" placeholder="Nhập họ và tên" required
                                       class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-4 py-3 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                            </div>
                        </div>

                        <!-- Email -->
                        <div>
                            <label for="email" class="block text-[11px] font-bold text-brand-muted mb-1.5 uppercase tracking-wider">Email</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                                    <i class="bi bi-envelope-fill"></i>
                                </div>
                                <input type="email" id="email" name="email" placeholder="email@example.com" required
                                       class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-4 py-3 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                            </div>
                        </div>

                        <!-- Số điện thoại -->
                        <div>
                            <label for="sdt" class="block text-[11px] font-bold text-brand-muted mb-1.5 uppercase tracking-wider">Số điện thoại</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                                    <i class="bi bi-telephone-fill"></i>
                                </div>
                                <input type="tel" id="sdt" name="sdt" placeholder="Nhập số điện thoại" required pattern="[0-9]{10,11}"
                                       class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-4 py-3 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                            </div>
                        </div>

                        <!-- Địa chỉ -->
                        <div>
                            <label for="diachi" class="block text-[11px] font-bold text-brand-muted mb-1.5 uppercase tracking-wider">Địa chỉ</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                                    <i class="bi bi-geo-alt-fill"></i>
                                </div>
                                <input type="text" id="diachi" name="diaChi" placeholder="Nhập địa chỉ" required
                                       class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-4 py-3 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                            </div>
                        </div>

                        <!-- Mật khẩu -->
                        <div>
                            <label for="password" class="block text-[11px] font-bold text-brand-muted mb-1.5 uppercase tracking-wider">Mật khẩu</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                                    <i class="bi bi-lock-fill"></i>
                                </div>
                                <input type="password" id="password" name="pass" placeholder="••••••••" required
                                       class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-12 py-3 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                                <button type="button" data-target="#password" class="toggle-password absolute inset-y-0 right-0 pr-4 flex items-center text-brand-muted hover:text-white transition focus:outline-none">
                                    <i class="bi bi-eye-fill text-lg"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Nhập lại mật khẩu -->
                        <div>
                            <label for="repassword" class="block text-[11px] font-bold text-brand-muted mb-1.5 uppercase tracking-wider">Nhập lại mật khẩu</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                                    <i class="bi bi-lock-fill"></i>
                                </div>
                                <input type="password" id="repassword" name="repass" placeholder="••••••••" required
                                       class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-12 py-3 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                                <button type="button" data-target="#repassword" class="toggle-password absolute inset-y-0 right-0 pr-4 flex items-center text-brand-muted hover:text-white transition focus:outline-none">
                                    <i class="bi bi-eye-fill text-lg"></i>
                                </button>
                            </div>
                        </div>

                    </div>

                    <!-- Nút Submit -->
                    <div class="mt-8">
                        <button type="submit" class="w-full bg-brand-primary text-brand-dark py-3.5 rounded-xl font-bold text-lg hover:bg-green-500 transition duration-300 shadow-[0_0_15px_rgba(74,222,128,0.2)] hover:shadow-[0_0_25px_rgba(74,222,128,0.4)] hover:-translate-y-0.5 flex justify-center items-center gap-2">
                            <span>ĐĂNG KÝ</span> <i class="bi bi-person-plus-fill"></i>
                        </button>
                    </div>
                </form>

                <!-- Liên kết Đăng nhập -->
                <div class="mt-6 text-center text-sm text-brand-muted border-t border-white/5 pt-5">
                    Đã có tài khoản?
                    <a href="login.jsp" class="font-bold text-brand-primary hover:text-green-400 transition hover:underline ml-1">Đăng nhập</a>
                </div>

            </div>
        </div>

        <!-- Script xử lý ẩn/hiện mật khẩu cho cả 2 trường -->
        <script>
            document.querySelectorAll('.toggle-password').forEach(button => {
                button.addEventListener('click', function () {
                    const targetId = this.getAttribute('data-target');
                    const inputField = document.querySelector(targetId);
                    const icon = this.querySelector('i');

                    // Đổi type của input
                    const type = inputField.getAttribute('type') === 'password' ? 'text' : 'password';
                    inputField.setAttribute('type', type);

                    // Đổi icon
                    if (type === 'password') {
                        icon.classList.remove('bi-eye-slash-fill');
                        icon.classList.add('bi-eye-fill');
                    } else {
                        icon.classList.remove('bi-eye-fill');
                        icon.classList.add('bi-eye-slash-fill');
                    }
                });
            });
        </script>
    </body>
</html>