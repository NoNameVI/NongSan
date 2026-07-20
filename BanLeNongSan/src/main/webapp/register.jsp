<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký tài khoản</title>
        <!-- Nhúng Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Nhúng Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        
        <style>
            body {
                background-color: #f5f8f4; /* Màu nền xanh nhạt đồng bộ */
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .login-container {
                max-width: 450px;
                width: 100%;
                padding: 20px;
                margin: auto;
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
                margin-bottom: 0.25rem;
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
    <body class="min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">

        <div class="login-container">
            <!-- Header -->
            <div class="mb-4 text-center">
                <h1 class="fw-bold text-main-green mb-2">Đăng ký</h1>
                <p class="text-secondary" style="font-size: 15px;">Tạo tài khoản mới để trải nghiệm dịch vụ.</p>
            </div>

            <!-- Bắt lỗi từ hệ thống -->
            <c:if test="${not empty err}">
                <div class="alert alert-warning rounded-3" role="alert">${err}</div>
            </c:if>

            <!-- Form Đăng ký -->
            <form action="register" method="POST">
                
                <!-- Họ và tên -->
                <div class="mb-3">
                    <label for="hoten" class="form-label">Họ và tên</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                        <input type="text" class="form-control" id="hoten" name="hoTen" placeholder="Nhập họ và tên" required>
                    </div>
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="email@example.com" required>
                    </div>
                </div>
                
                <!-- Số điện thoại -->
                <div class="mb-3">
                    <label for="sdt" class="form-label">Số điện thoại</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-telephone-fill"></i></span>
                        <input type="tel" class="form-control" id="sdt" name="sdt" placeholder="Nhập số điện thoại" required pattern="[0-9]{10,11}">
                    </div>
                </div>
                
                <!-- Địa chỉ -->
                <div class="mb-3">
                    <label for="diachi" class="form-label">Địa chỉ</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-geo-alt-fill"></i></span>
                        <input type="text" class="form-control" id="diachi" name="diaChi" placeholder="Nhập địa chỉ" required>
                    </div>
                </div>

                <!-- Mật khẩu -->
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <input type="password" class="form-control" id="password" name="pass" placeholder="••••••••" required>
                        <button class="btn border-0 text-secondary shadow-none toggle-password" type="button" data-target="#password">
                            <i class="bi bi-eye-fill"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Nhập lại mật khẩu -->
                <div class="mb-4">
                    <label for="repassword" class="form-label">Nhập lại mật khẩu</label>
                    <div class="input-group custom-input-group p-1">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <input type="password" class="form-control" id="repassword" name="repass" placeholder="••••••••" required>
                        <button class="btn border-0 text-secondary shadow-none toggle-password" type="button" data-target="#repassword">
                            <i class="bi bi-eye-fill"></i>
                        </button>
                    </div>
                </div>

                <!-- Nút Submit -->
                <button type="submit" class="btn bg-main-green text-white w-100 py-2 fw-bold rounded-3 mb-4" style="font-size: 16px;">
                    ĐĂNG KÝ
                </button>
            </form>

            <!-- Liên kết Đăng nhập -->
            <div class="text-center" style="font-size: 15px;">
                <span class="text-secondary">Đã có tài khoản?</span> 
                <a href="login.jsp" class="fw-bold text-main-green text-decoration-none">Đăng nhập</a>
            </div>
            
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
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
