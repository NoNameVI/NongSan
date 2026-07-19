<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ Hàng Của Bạn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bổ sung icon Bootstrap cho nút xóa -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    </head>
    <body style="background-color: #f6fcf8; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">

        <!-- NAVBAR -->
        <div class="container-fluid py-3 mb-4 shadow-sm" style="background-color: #175e22;">
            <div class="container d-flex flex-wrap justify-content-between align-items-center">

                <!-- BRAND / LOGO -->
                <a href="home" class="text-decoration-none text-white fw-bold fs-2 lh-1" style="font-family: Arial, sans-serif;">
                    <div>RAU</div>
                    <div>THÉP</div>
                </a>

                <!-- TÌM KIẾM & SLOGAN -->
                <div class="flex-grow-1 d-flex flex-column align-items-center mx-3 my-3 my-md-0">
                    <form action="product" method="GET" class="w-100" style="max-width: 450px;">
                        <input type="text" name="search" class="form-control border-0 rounded-0 py-2" placeholder="Tìm kiếm...." style="background-color: #d9d9d9;">
                    </form>
                    <div class="text-white mt-2" style="font-size: 14px;">Xanh không yếu, xanh để chiến đấu</div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="d-flex gap-2">
                    <!-- Đọc tên từ Cookie, nếu không có hiển thị 'TÀI KHOẢN'. Replace dấu '_' thành khoảng trắng do trước đó đã mã hóa trong Servlet -->
                    <a href="profile" class="btn text-white rounded-0 d-flex align-items-center px-3 text-uppercase" style="background-color: #1e3323; font-size: 12px; letter-spacing: 1px;">
                        <c:choose>
                            <c:when test="${not empty cookie.fullname.value}">
                                ${fn:replace(cookie.fullname.value, '_', ' ')}
                            </c:when>
                            <c:otherwise>
                                TÀI KHOẢN
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <a href="logout" class="btn text-white rounded-0 d-flex align-items-center px-3 fs-5" style="background-color: #000000;">logout</a>
                </div>

            </div>
        </div>

        <!-- MAIN CONTAINER -->
        <div class="container pb-5" style="max-width: 650px;">
            <!-- NÚT QUAY LẠI CỬA HÀNG -->
            <div class="mb-3">
                <a href="products" class="text-decoration-none fw-bold" style="color: #306c39;">&larr; Tiếp tục mua sắm</a>
            </div>

            <!-- TITLE -->
            <h2 class="fw-bold mb-3" style="color: #1e5c2b;">
                Giỏ hàng
                <c:if test="${not empty sessionScope.cartItems}">
                    <span class="fw-normal" style="color: #8da391; font-size: 16px;">
                        (${fn:length(sessionScope.cartItems)} sản phẩm)
                    </span>
                </c:if>
            </h2>

            <c:choose>
                <c:when test="${empty sessionScope.cartItems}">
                    <!-- GIỎ HÀNG TRỐNG -->
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center text-muted mb-4">
                        <p class="mb-3">Giỏ hàng của bạn đang trống.</p>
                        <a href="product" class="btn btn-outline-success fw-bold rounded-3 px-4 py-2" style="border-color: #306c39; color: #306c39;">Quay lại cửa hàng</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- DANH SÁCH SẢN PHẨM -->
                    <div class="card border-0 shadow-sm rounded-4 p-3 p-md-4 mb-4">
                        <c:set var="tongTienGiaoDich" value="0" />

                        <c:forEach items="${sessionScope.cartItems}" var="item" varStatus="loop">
                            <c:set var="thanhTienItem" value="${item.sanPham.donGia * item.soLuong}" />

                            <div class="d-flex align-items-center py-3 ${!loop.last ? 'border-bottom' : ''}">

                                <!-- Hình ảnh sản phẩm -->
                                <div class="bg-light rounded-3 d-flex justify-content-center align-items-center me-3" style="width: 55px; height: 55px; overflow: hidden;">
                                    <img src="${item.sanPham.hinhAnh}" alt="${item.sanPham.tenSP}" style="max-width: 100%; max-height: 100%; object-fit: cover;" onerror="this.style.display='none'">
                                </div>

                                <!-- Tên và Đơn giá -->
                                <div class="flex-grow-1">
                                    <div class="fw-semibold mb-1" style="color: #245b32;">${item.sanPham.tenSP}</div>
                                    <div class="text-secondary" style="font-size: 13px;">
                                        ${item.sanPham.donViTinh} &middot; <fmt:formatNumber value="${item.sanPham.donGia}" pattern="#,##0đ"/>
                                    </div>
                                </div>

                                <!-- Form tăng giảm số lượng -->
                                <div class="me-3 me-md-4">
                                    <form action="cart" method="POST" class="d-flex align-items-center border rounded-3 p-1 bg-white">
                                        <input type="hidden" name="action" value="update" />
                                        <input type="hidden" name="productId" value="${item.sanPham.maSP}" />

                                        <button type="submit" name="quantity" value="${item.soLuong - 1}" class="btn p-0 d-flex justify-content-center align-items-center text-secondary" style="width: 26px; height: 26px; background: none; border: none;">&minus;</button>

                                        <input type="text" value="${item.soLuong}" class="form-control form-control-sm border-0 text-center fw-bold p-0 bg-white" style="width: 28px; pointer-events: none;" readonly />

                                        <button type="submit" name="quantity" value="${item.soLuong + 1}" class="btn p-0 d-flex justify-content-center align-items-center text-secondary" style="width: 26px; height: 26px; background: none; border: none;">&plus;</button>
                                    </form>
                                </div>

                                <!-- Nút Xóa Sản Phẩm khỏi giỏ (Phục hồi lại) -->
                                <div class="me-3">
                                    <form action="cart" method="POST">
                                        <input type="hidden" name="action" value="remove" />
                                        <input type="hidden" name="productId" value="${item.sanPham.maSP}" />
                                        <button type="submit" class="btn p-0 text-danger fs-5" title="Xóa sản phẩm">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>

                                <!-- Tổng phụ từng dòng -->
                                <div class="fw-bold text-end" style="color: #245b32; width: 75px;">
                                    <fmt:formatNumber value="${thanhTienItem}" pattern="#,##0đ"/>
                                </div>
                            </div>

                            <c:set var="tongTienGiaoDich" value="${tongTienGiaoDich + thanhTienItem}" />
                        </c:forEach>
                    </div>

                    <!-- TÍNH TOÁN PHÍ SHIP VÀ FREESHIP -->
                    <c:set var="phiShip" value="20000" />
                    <c:set var="freeshipThreshold" value="150000" />
                    <c:if test="${tongTienGiaoDich >= freeshipThreshold}">
                        <c:set var="phiShip" value="0" />
                    </c:if>
                    <c:set var="tongCong" value="${tongTienGiaoDich + phiShip}" />

                    <!-- TỔNG KẾT ĐƠN HÀNG -->
                    <div class="card border-0 shadow-sm rounded-4 p-3 p-md-4 mb-4">
                        <div class="d-flex justify-content-between mb-2 text-secondary" style="font-size: 15px;">
                            <span>Tạm tính</span>
                            <span><fmt:formatNumber value="${tongTienGiaoDich}" pattern="#,##0đ"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 text-secondary" style="font-size: 15px;">
                            <span>Phí ship</span>
                            <span>
                                <c:choose>
                                    <c:when test="${phiShip == 0}">Miễn phí</c:when>
                                    <c:otherwise><fmt:formatNumber value="${phiShip}" pattern="#,##0đ"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <hr class="text-muted opacity-25 my-2" style="border-style: dashed;">

                        <div class="d-flex justify-content-between align-items-center mt-3 mb-4">
                            <span class="fs-5 fw-bold" style="color: #1e5c2b;">Tổng</span>
                            <span class="fs-5 fw-bold" style="color: #1e5c2b;"><fmt:formatNumber value="${tongCong}" pattern="#,##0đ"/></span>
                        </div>

                        <!-- Nút Đặt Hàng -->
                        <form action="checkout" method="GET">
                            <!-- Truyền tổng tiền sang trang checkout -->
                            <input type="hidden" name="tongTien" value="${tongCong}">
                            <button type="submit" class="btn w-100 py-3 fw-bold text-white rounded-3 shadow-sm" style="background-color: #306c39; font-size: 16px;">
                                Đặt hàng
                            </button>
                        </form>

                        <!-- Thông báo Freeship -->
                        <c:if test="${phiShip > 0}">
                            <div class="text-center mt-3" style="font-size: 13px; color: #8da391;">
                                Mua thêm <fmt:formatNumber value="${freeshipThreshold - tongTienGiaoDich}" pattern="#,##0đ"/> để miễn phí ship
                            </div>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>