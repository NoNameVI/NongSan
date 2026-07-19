<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HỒ SƠ CÁ NHÂN</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6">
                    <div class="card shadow-sm border-0 rounded-3">
                        <div class="card-header bg-primary text-white text-center py-3">
                            <h4 class="mb-0 fw-bold">HỒ SƠ CÁ NHÂN</h4>
                        </div>
                        <div class="card-body p-4">
                            
                            <!-- Hiển thị thông báo trạng thái cập nhật -->
                            <c:if test="${not empty msg}">
                                <div class="alert alert-success rounded-pill text-center" role="alert">${msg}</div>
                            </c:if>
                            <c:if test="${not empty err}">
                                <div class="alert alert-danger rounded-pill text-center" role="alert">${err}</div>
                            </c:if>

                            <form action="profile" method="POST">
                                <div class="mb-3">
                                    <label for="email" class="form-label fw-bold">Email (Tài khoản)</label>
                                    <input type="email" class="form-control bg-light" id="email" value="${user.email}" readonly>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="hoTen" class="form-label fw-bold">Họ và tên</label>
                                    <input type="text" class="form-control" id="hoTen" name="hoTen" value="${user.hoTen}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="sdt" class="form-label fw-bold">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="sdt" name="sdt" value="${user.sdt}" pattern="[0-9]{10,11}" required>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="diaChi" class="form-label fw-bold">Địa chỉ</label>
                                    <textarea class="form-control" id="diaChi" name="diaChi" rows="2" required>${user.diaChi}</textarea>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary fw-bold py-2">LƯU THAY ĐỔI</button>
                                    <a href="home" class="btn btn-outline-secondary py-2">QUAY LẠI TRANG CHỦ</a>
                                </div>
                            </form>
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
