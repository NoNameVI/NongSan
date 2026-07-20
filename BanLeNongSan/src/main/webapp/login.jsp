<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Nông Sản Việt</title>
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
    <body class="bg-brand-dark text-brand-text font-sans antialiased min-h-screen flex items-center justify-center px-4 relative overflow-hidden">

        <!-- Background Decor (Tạo điểm nhấn mờ phía sau) -->
        <div class="absolute top-[-10%] left-[-10%] w-96 h-96 bg-brand-primary/10 rounded-full blur-3xl"></div>
        <div class="absolute bottom-[-10%] right-[-10%] w-96 h-96 bg-brand-accent/10 rounded-full blur-3xl"></div>

        <div class="w-full max-w-md bg-brand-card/90 backdrop-blur-md border border-brand-dark p-8 md:p-10 rounded-2xl shadow-2xl relative z-10">

            <!-- Header -->
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-brand-dark border-2 border-brand-primary mb-4 text-3xl shadow-[0_0_15px_rgba(74,222,128,0.2)]">
                    🌿
                </div>
                <h1 class="text-3xl font-serif font-bold text-white mb-2">Đăng nhập</h1>
                <p class="text-brand-muted text-sm">Chào mừng bạn quay lại <strong class="text-brand-primary">Nông Sản Việt!</strong></p>
            </div>

            <!-- Bắt lỗi/Thông báo từ hệ thống -->
            <c:if test="${not empty err}">
                <div class="bg-red-500/10 border border-red-500/50 text-red-400 px-4 py-3 rounded-lg mb-6 text-sm font-medium text-center flex items-center justify-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${err}
                </div>
            </c:if>
            <c:if test="${not empty msg}">
                <div class="bg-brand-primary/10 border border-brand-primary/50 text-brand-primary px-4 py-3 rounded-lg mb-6 text-sm font-medium text-center flex items-center justify-center gap-2">
                    <i class="bi bi-check-circle-fill"></i> ${msg}
                </div>
            </c:if>

            <!-- Form Đăng nhập -->
            <form action="login" method="POST">

                <!-- Email -->
                <div class="mb-5">
                    <label for="email" class="block text-xs font-bold text-brand-muted mb-2 uppercase tracking-wider">Email</label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                            <i class="bi bi-envelope-fill"></i>
                        </div>
                        <input type="email" id="email" name="email" placeholder="email@example.com" required
                               class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-4 py-3.5 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                    </div>
                </div>

                <!-- Mật khẩu -->
                <div class="mb-6">
                    <label for="password" class="block text-xs font-bold text-brand-muted mb-2 uppercase tracking-wider">Mật khẩu</label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-brand-muted group-focus-within:text-brand-primary transition">
                            <i class="bi bi-lock-fill"></i>
                        </div>
                        <input type="password" id="password" name="pass" placeholder="••••••••" required
                               class="w-full bg-brand-dark border border-brand-muted/30 rounded-xl pl-11 pr-12 py-3.5 text-white placeholder-brand-muted/50 focus:outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition duration-300">
                        <!-- Nút hiển thị mật khẩu -->
                        <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-4 flex items-center text-brand-muted hover:text-white transition focus:outline-none">
                            <i class="bi bi-eye-fill text-lg"></i>
                        </button>
                    </div>
                </div>

                <!-- Nút Submit -->
                <button type="submit" class="w-full bg-brand-primary text-brand-dark py-3.5 rounded-xl font-bold text-lg hover:bg-green-500 transition duration-300 shadow-[0_0_15px_rgba(74,222,128,0.2)] hover:shadow-[0_0_25px_rgba(74,222,128,0.4)] hover:-translate-y-0.5 flex justify-center items-center gap-2">
                    <span>ĐĂNG NHẬP</span> <i class="bi bi-arrow-right-circle-fill"></i>
                </button>
            </form>

            <!-- Liên kết Đăng ký -->
            <div class="mt-8 text-center text-sm text-brand-muted border-t border-white/5 pt-6">
                Chưa có tài khoản?
                <a href="register" class="font-bold text-brand-primary hover:text-green-400 transition hover:underline ml-1">Đăng ký ngay</a>
            </div>

        </div>

        <!-- Script xử lý ẩn/hiện mật khẩu -->
        <script>
            const togglePassword = document.querySelector('#togglePassword');
            const password = document.querySelector('#password');
            const icon = togglePassword.querySelector('i');

            togglePassword.addEventListener('click', function (e) {
                // Đổi type của input
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);

                // Đổi icon
                if (type === 'password') {
                    icon.classList.remove('bi-eye-slash-fill');
                    icon.classList.add('bi-eye-fill');
                } else {
                    icon.classList.remove('bi-eye-fill');
                    icon.classList.add('bi-eye-slash-fill');
                }
            });
        </script>
    </body>
</html>
