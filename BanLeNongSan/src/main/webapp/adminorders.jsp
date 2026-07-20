<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng - Admin</title>
    <!-- Nhúng Bootstrap 5 và Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f4f6f9; color: #212529; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; overflow-x: hidden; }
        
        /* Sidebar */
        .sidebar { height: 100vh; background-color: #121518; padding-top: 20px; position: fixed; width: 250px; border-right: 2px solid #343a40; z-index: 1000; }
        .sidebar a { color: #d1d5db; text-decoration: none; padding: 15px 20px; display: block; font-weight: 600; border-bottom: 1px solid #2c3034; transition: all 0.2s ease-in-out; }
        .sidebar a:hover, .sidebar a.active { color: #ffffff; background-color: #0d6efd; border-left: 6px solid #ffc107; }
        
        /* Main Content */
        .main-content { margin-left: 250px; padding: 30px; }
        .admin-header { background: #ffffff; padding: 15px 25px; border: 2px solid #212529; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .card-custom { background: #ffffff; border: 2px solid #212529; border-radius: 0; margin-bottom: 25px; }
        .btn-custom { border-radius: 0; font-weight: bold; border-width: 2px; text-transform: uppercase; }
        .form-select-custom { border: 2px solid #6c757d; border-radius: 0; }
        .form-select-custom:focus { border-color: #212529; box-shadow: none; }

        /* Bảng */
        .table-custom { margin-bottom: 0; }
        .table-custom thead th { background-color: #212529; color: #ffffff; border: 1px solid #212529; text-transform: uppercase; font-size: 13px; }
        .table-custom tbody td { border: 1px solid #dee2e6; vertical-align: middle; }
        
        /* Badge Trạng thái */
        .badge { border-radius: 0; padding: 6px 10px; font-weight: 600; border: 1px solid transparent; }
        .status-cho-xac-nhan { background-color: #fff; color: #ffc107; border-color: #ffc107; }
        .status-da-giao { background-color: #fff; color: #198754; border-color: #198754; }
        .status-da-huy { background-color: #fff; color: #dc3545; border-color: #dc3545; }
        .status-dang-giao { background-color: #fff; color: #0dcaf0; border-color: #0dcaf0; }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <h4 class="text-white text-center mb-4 fw-bold tracking-wide">ADMIN PANEL</h4>
        <a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-2"></i> Sản Phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i> Người Dùng</a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="active"><i class="bi bi-cart-check me-2"></i> Đơn Hàng</a>
        <a href="${pageContext.request.contextPath}/logout" class="text-danger mt-4 border-top border-secondary"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <!-- HEADER -->
        <div class="admin-header">
            <h4 class="mb-0 fw-bold text-dark text-uppercase">Quản Lý Đơn Hàng</h4>
            <div class="d-flex align-items-center">
                <span class="fw-bold me-3 text-dark">Xin chào, Admin!</span>
                <img src="https://ui-avatars.com/api/?name=Admin&background=212529&color=fff&rounded=false" alt="Admin" width="45" style="border: 2px solid #212529;">
            </div>
        </div>

        <!-- THÔNG BÁO TỪ SESSION -->
        <c:if test="${not empty sessionScope.msg}">
            <div class="alert alert-success fw-bold" style="border: 2px solid #198754; border-radius: 0;">${sessionScope.msg}</div>
            <c:remove var="msg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.err}">
            <div class="alert alert-danger fw-bold" style="border: 2px solid #dc3545; border-radius: 0;">${sessionScope.err}</div>
            <c:remove var="err" scope="session"/>
        </c:if>

        <!-- BẢNG DỮ LIỆU ĐƠN HÀNG -->
        <div class="card-custom">
            <div class="table-responsive">
                <table class="table table-striped table-hover table-custom mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Mã ĐH</th>
                            <th>Khách Hàng</th>
                            <th>Ngày Đặt</th>
                            <th>Tổng Tiền</th>
                            <th>Địa Chỉ Giao</th>
                            <th>Trạng Thái</th>
                            <th class="text-end pe-4">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="dh" items="${orderList}">
                            <tr>
                                <td class="ps-4 fw-bold text-dark">#${dh.maDH}</td>
                                <td class="fw-semibold">${dh.maKhachHang.hoTen}</td>
                                <td><fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td class="fw-bold text-danger"><fmt:formatNumber value="${dh.tongTien}" pattern="#,##0"/> đ</td>
                                <td class="text-truncate" style="max-width: 200px;" title="${dh.diaChiGiao}">${dh.diaChiGiao}</td>
                                <td>
                                    <%-- SỬA LỖI: DB lưu TrangThai KHÔNG DẤU ('Da giao', 'Da huy', 'Dang giao',
                                         'Cho xac nhan'). So sánh với chuỗi có dấu trước đây không bao giờ khớp,
                                         khiến badge luôn rơi vào nhánh otherwise ("CHỜ XÁC NHẬN") dù đơn đã
                                         thực sự chuyển trạng thái khác trong DB. --%>
                                    <c:choose>
                                        <c:when test="${dh.trangThai == 'Da giao'}"><span class="badge status-da-giao">ĐÃ GIAO</span></c:when>
                                        <c:when test="${dh.trangThai == 'Da huy'}"><span class="badge status-da-huy">ĐÃ HỦY</span></c:when>
                                        <c:when test="${dh.trangThai == 'Dang giao'}"><span class="badge status-dang-giao">ĐANG GIAO</span></c:when>
                                        <c:otherwise><span class="badge status-cho-xac-nhan">CHỜ XÁC NHẬN</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-dark btn-custom" 
                                            onclick="openUpdateModal('${dh.maDH}', '${dh.trangThai}')" title="Cập nhật trạng thái">
                                        <i class="bi bi-pencil-square"></i> CẬP NHẬT
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orderList}">
                            <tr><td colspan="7" class="text-center text-muted fw-bold py-5 bg-light">KHÔNG TÌM THẤY ĐƠN HÀNG NÀO.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- MODAL CẬP NHẬT TRẠNG THÁI -->
    <div class="modal fade" id="updateStatusModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 0; border: 3px solid #212529;">
                <form action="${pageContext.request.contextPath}/admin/orders" method="POST">
                    <input type="hidden" name="orderId" id="u-orderId">
                    
                    <div class="modal-header bg-dark text-white" style="border-radius: 0; border-bottom: none;">
                        <h5 class="modal-title fw-bold text-uppercase">Cập Nhật Trạng Thái Đơn Hàng</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    
                    <div class="modal-body p-4 bg-light">
                        <p class="fs-5 mb-3">Đang thao tác trên đơn hàng: <strong class="text-danger" id="display-orderId"></strong></p>
                        <label class="fw-bold mb-2">Chọn trạng thái mới:</label>
                        <%-- SỬA LỖI: value phải KHÔNG DẤU khớp với CK_DonHang_TrangThai trong DB.
                             Trước đây gửi value có dấu -> UPDATE bị vi phạm CHECK constraint
                             -> updateOrderStatus() luôn thất bại (trả về false). --%>
                        <select class="form-select form-select-custom" name="status" id="u-status">
                            <option value="Cho xac nhan">Chờ xác nhận</option>
                            <option value="Dang giao">Đang giao</option>
                            <option value="Da giao">Đã giao</option>
                            <option value="Da huy">Đã hủy</option>
                        </select>
                        <div class="mt-3 text-muted small">
                            <i class="bi bi-info-circle-fill text-primary"></i> 
                            Lưu ý: Nếu chuyển trạng thái sang "Đã hủy", hệ thống sẽ tự động hoàn lại số lượng tồn kho cho sản phẩm.
                        </div>
                    </div>
                    
                    <div class="modal-footer bg-white" style="border-top: 2px solid #dee2e6;">
                        <button type="button" class="btn btn-outline-dark btn-custom" data-bs-dismiss="modal">HỦY BỎ</button>
                        <button type="submit" class="btn btn-dark btn-custom">LƯU THAY ĐỔI</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openUpdateModal(orderId, currentStatus) {
            document.getElementById('u-orderId').value = orderId;
            document.getElementById('display-orderId').innerText = "#" + orderId;
            document.getElementById('u-status').value = currentStatus;
            
            var modal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
            modal.show();
        }
    </script>
</body>
</html>