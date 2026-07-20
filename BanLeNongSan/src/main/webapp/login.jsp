<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập</title>
        <!-- Nhúng Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Nhúng Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        
        <style>
            body {
                background-color: #f5f8f4; /* Màu nền xanh nhạt theo ảnh */
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .login-container {
                max-width: 450px;
                width: 100%;
                padding: 20px;
            }
            .text-main-green {
                color: #385635; /* Màu xanh đậm chữ và nút */
            }
            .bg-main-green {
                background-color: #40603d;
            }
            .bg-main-green:hover {
                background-color: #314a2f;
            }
            .form-label {
                font-weight: 600;
                color: #385635;
                font-size: 14px;
            }
            .custom-input-group {
                border: 1px solid #c3d4c0;
                border-radius: 10px;
                background-color: #ffffff;
                overflow: hidden;
            }
            .custom-input-group:focus-within {
                border-color: #40603d;
                box-shadow: 0 0 0 0.2rem rgba(64, 96, 61, 0.25);
            }
            .custom-input-group .input-group-text {
                background-color: transparent;
                border: none;
                color: #5c7759;
            }
            .custom-input-group .form-control {
                border: none;
                box-shadow: none;
                padding-left: 0;
            }
            .custom-input-group .form-control::placeholder {
                color: #aebfab;
            }
        </style>
    </head>
    <body class="min-vh-100 d-flex flex-column align-items-center justify-content-center">

        <div class="login-container">
            <!-- Header -->
            <div class="mb-4">
                <h1 class="fw-bold text-main-green mb-2">Đăng nhập</h1>
                <p class="text-secondary" style="font-size: 15px;">Chào mừng bạn quay lại! Vui lòng đăng nhập để tiếp tục.</p>
            </div>

            <!-- Bắt lỗi/Thông báo từ hệ thống[cite: 25] -->
            <c:if test="${not empty err}">
                <div class="alert alert-danger rounded-3" role="alert">${err}</div>
            </c:if>
            <c:if test="${not empty msg}">
                <div class="alert alert-success rounded-3" role="alert">${msg}</div>
            </c:if>

            <!-- Form Đăng nhập[cite: 25] -->
            <form action="login" method="POST">
                
                <!-- Email -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="email@example.com" required>
                    </div>
                </div>

                <!-- Mật khẩu -->
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <input type="password" class="form-control" id="password" name="pass" placeholder="••••••••" required>
                        <!-- Nút hiển thị mật khẩu -->
                        <button class="btn border-0 text-secondary shadow-none" type="button" id="togglePassword">
                            <i class="bi bi-eye-fill"></i>
                        </button>
                    </div>
                </div>

                <!-- Ghi nhớ đăng nhập -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember" style="border-color: #aebfab;">
                        <label class="form-check-label text-secondary" for="remember" style="font-size: 14px;">
                            Ghi nhớ đăng nhập
                        </label>
                    </div>
                    <!-- Đã bỏ Quên mật khẩu theo yêu cầu -->
                </div>

                <!-- Nút Submit[cite: 25] -->
                <button type="submit" class="btn bg-main-green text-white w-100 py-2 fw-bold rounded-3 mb-4" style="font-size: 16px;">
                    Đăng nhập
                </button>
            </form>

            <!-- Liên kết Đăng ký[cite: 25] -->
            <div class="text-center" style="font-size: 15px;">
                <span class="text-secondary">Chưa có tài khoản?</span> 
                <a href="register" class="fw-bold text-main-green text-decoration-none">Đăng ký ngay</a>
            </div>
            
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
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
