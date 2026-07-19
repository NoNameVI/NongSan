<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>REGISTER</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body class="login-page">
        <div class="container-fluid min-vh-100 d-flex align-items-center justify-content-center px-3 py-4">
            <div class="row w-100 justify-content-center">
                <div class="col-12 col-xl-10">
                    <div class="login-shell">
                        <div class="login-hero">
                            <h1></h1>
                        </div>

                        <div class="login-panel">
                            <div class="text-center mb-4">
                                <h2 class="fw-bold mb-2">ĐĂNG KÝ</h2>
                                <p class="text-muted mb-0">Tạo tài khoản mới</p>
                            </div>

                            <form action="register" method="POST">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="hoten" name="hoTen" placeholder="Họ và tên" required>
                                    <label for="hoten">Họ và tên</label>
                                </div>
                                
                                <div class="form-floating mb-3">
                                    <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                                    <label for="email">Email</label>
                                </div>
                                
                                <div class="form-floating mb-3">
                                    <input type="tel" class="form-control" id="sdt" name="sdt" placeholder="Số điện thoại" required pattern="[0-9]{10,11}">
                                    <label for="sdt">Số điện thoại</label>
                                </div>
                                
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="diachi" name="diaChi" placeholder="Địa chỉ" required>
                                    <label for="diachi">Địa chỉ</label>
                                </div>

                                <div class="form-floating mb-3">
                                    <input type="password" class="form-control" id="password" name="pass" placeholder="Mật khẩu" required>
                                    <label for="password">Mật khẩu</label>
                                </div>
                                
                                <div class="form-floating mb-4">
                                    <input type="password" class="form-control" id="repassword" name="repass" placeholder="Nhập lại mật khẩu" required>
                                    <label for="repassword">Nhập lại mật khẩu</label>
                                </div>

                                <c:if test="${not empty err}">
                                    <div class="alert alert-warning rounded-pill" role="alert">${err}</div>
                                </c:if>

                                <button class="btn btn-primary w-100 py-2 fw-bold rounded-pill login-submit" type="submit">
                                    ĐĂNG KÝ
                                </button>
                            </form>

                            <div class="text-center mt-4 small">
                                <span class="text-muted">Đã có tài khoản?</span> 
                                <a href="login.jsp" class="fw-bold text-primary text-decoration-none">Đăng nhập</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>