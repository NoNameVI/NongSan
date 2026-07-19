<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thanh Toán Đơn Hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: #f6fcf8; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">

        <!-- NAVBAR -->
        <div class="container-fluid py-3 mb-4 shadow-sm" style="background-color: #175e22;">
            <div class="container">
                <a href="cart" class="text-decoration-none text-white fw-bold fs-5">
                    &larr; Quay lại giỏ hàng
                </a>
            </div>
        </div>

        <div class="container pb-5" style="max-width: 800px;">
            <h2 class="fw-bold mb-4" style="color: #1e5c2b;">Thông Tin Thanh Toán</h2>

            <!-- Bắt lỗi nếu chuyển từ Servlet sang -->
            <c:if test="${not empty err}">
                <div class="alert alert-danger">${err}</div>
            </c:if>

            <div class="row">
                <!-- Cột thông tin khách hàng -->
                <div class="col-md-7 mb-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4">
                        <h5 class="fw-bold mb-3">Địa chỉ giao hàng</h5>

                        <form action="checkout" method="POST">
                            <!-- Điền sẵn SĐT từ Database -->
                            <div class="mb-3">
                                <label for="phone" class="form-label fw-semibold">Số điện thoại liên hệ <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${user.sdt}" required placeholder="Nhập số điện thoại">
                            </div>

                            <!-- Điền sẵn Địa chỉ từ Database -->
                            <div class="mb-4">
                                <label for="address" class="form-label fw-semibold">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="address" name="address" rows="3" 
                                          required placeholder="Số nhà, Tên đường, Phường/Xã, Quận/Huyện...">${user.diaChi}</textarea>
                            </div>

                            <!-- Các phần còn lại giữ nguyên... -->
                            <button type="submit" class="btn w-100 py-3 fw-bold text-white rounded-3 shadow-sm" style="background-color: #306c39; font-size: 16px;">
                                XÁC NHẬN ĐẶT HÀNG
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Cột tóm tắt đơn hàng -->
                <div class="col-md-5">
                    <div class="card border-0 shadow-sm rounded-4 p-4" style="background-color: #eaf1ec;">
                        <h5 class="fw-bold mb-3">Tóm tắt đơn hàng</h5>

                        <c:forEach items="${cartItems}" var="item">
                            <div class="d-flex justify-content-between align-items-center mb-2" style="font-size: 14px;">
                                <span class="text-truncate me-2" style="max-width: 65%;">${item.sanPham.tenSP} (x${item.soLuong})</span>
                                <span class="fw-semibold"><fmt:formatNumber value="${item.sanPham.donGia * item.soLuong}" pattern="#,##0đ"/></span>
                            </div>
                        </c:forEach>

                        <hr class="text-muted opacity-25 my-3" style="border-style: dashed;">

                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fs-5 fw-bold" style="color: #1e5c2b;">Cần thanh toán</span>
                            <!-- Nếu bạn đã tính tổng tiền ở CartServlet và truyền qua -->
                            <span class="fs-5 fw-bold text-danger">
                                <fmt:formatNumber value="${not empty tongTien ? tongTien : 0}" pattern="#,##0đ"/>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>