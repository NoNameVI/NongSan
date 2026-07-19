<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* Khung Sidebar & Main Content */
        body { background-color: #f8f9fa; overflow-x: hidden; }
        .sidebar { height: 100vh; background-color: #343a40; padding-top: 20px; position: fixed; width: 250px; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 15px 20px; display: block; font-weight: 500; }
        .sidebar a:hover, .sidebar a.active { color: #fff; background-color: #495057; border-left: 4px solid #0d6efd; }
        .main-content { margin-left: 250px; padding: 20px; }
        .admin-header { background: #fff; padding: 15px 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
    </style>
</head>
<body>

    <!-- SIDEBAR CHUNG CHO ADMIN -->
    <div class="sidebar shadow">
        <h4 class="text-white text-center mb-4 fw-bold">ADMIN PANEL</h4>
        <a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-2"></i> Sản Phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="bi bi-people me-2"></i> Người Dùng</a>
        <a href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-cart-check me-2"></i> Đơn Hàng</a>
        <hr class="text-secondary mx-3">
        <a href="${pageContext.request.contextPath}/logout" class="text-danger"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <!-- HEADER -->
        <div class="admin-header">
            <h4 class="mb-0 fw-bold text-secondary">QUẢN LÝ NGƯỜI DÚNG</h4>
            <div class="d-flex align-items-center">
                <span class="fw-bold me-3">Xin chào, Admin!</span>
                <img src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" alt="Admin" class="rounded-circle" width="40">
            </div>
        </div>

        <!-- THANH CÔNG CỤ: TÌM KIẾM -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body d-flex justify-content-between align-items-center">
                <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="d-flex w-50">
                    <input type="text" name="search" class="form-control me-2" placeholder="Tìm kiếm theo tên, email..." value="${searchQuery}">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm</button>
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary ms-2">Hủy</a>
                    </c:if>
                </form>
            </div>
        </div>

        <!-- BẢNG DỮ LIỆU NGƯỜI DÙNG -->
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Họ và Tên</th>
                            <th>Email</th>
                            <th>Vai Trò</th>
                            <th>Trạng Thái</th>
                            <th class="text-end pe-4">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${listUsers}">
                            <tr>
                                <td class="ps-4 fw-bold">#${u.maND}</td>
                                <td>${u.hoTen}</td>
                                <td>${u.email}</td>
                                <td>
                                    <!-- Vai trò: 1 thường là Khách hàng, 2 là Admin (tuỳ DB của bạn) -->
                                    <span class="badge bg-secondary">${u.maVaiTro.tenVaiTro}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.trangThai == 'Hoat dong'}">
                                            <span class="badge bg-success">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-4">
                                    <!-- Nút Xem chi tiết -->
                                    <button type="button" class="btn btn-sm btn-info text-white" onclick="viewDetails('${u.hoTen}', '${u.email}', '${u.sdt}', '${u.diaChi}', '${u.ngayTao}')">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    
                                    <!-- Nút Khóa / Mở Khóa -->
                                    <button type="button" class="btn btn-sm ${u.trangThai == 'Khoa' ? 'btn-success' : 'btn-warning'}" 
                                            onclick="confirmToggleStatus(${u.maND}, '${u.hoTen}', '${u.trangThai}')">
                                        <i class="bi ${u.trangThai == 'Khoa' ? 'bi-unlock' : 'bi-lock'}"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty listUsers}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">Không tìm thấy người dùng nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- PHÂN TRANG -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&search=${searchQuery}">Trước</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&search=${searchQuery}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&search=${searchQuery}">Sau</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- ================== KHU VỰC MODAL (POPUP) ================== -->

    <!-- Modal Xem Chi Tiết Người Dùng -->
    <div class="modal fade" id="viewUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title fw-bold">Chi Tiết Người Dùng</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Họ và tên:</strong> <span id="v-hoten"></span></p>
                    <p><strong>Email:</strong> <span id="v-email"></span></p>
                    <p><strong>Số điện thoại:</strong> <span id="v-sdt"></span></p>
                    <p><strong>Địa chỉ:</strong> <span id="v-diachi"></span></p>
                    <p><strong>Ngày tham gia:</strong> <span id="v-ngaytao"></span></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Xác Nhận Khóa/Mở Khóa -->
    <div class="modal fade" id="toggleStatusModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                    <input type="hidden" name="action" value="toggleStatus">
                    <input type="hidden" name="maND" id="toggle-maND">
                    <input type="hidden" name="currentStatus" id="toggle-currentStatus">
                    
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-danger">Xác Nhận Hành Động</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn <strong id="action-text"></strong> tài khoản của <strong id="toggle-hoten"></strong> không?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger" id="btn-confirm-action">Xác nhận</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý dữ liệu đẩy vào Modal Xem Chi Tiết
        function viewDetails(hoten, email, sdt, diachi, ngaytao) {
            document.getElementById('v-hoten').innerText = hoten;
            document.getElementById('v-email').innerText = email;
            document.getElementById('v-sdt').innerText = sdt || 'Chưa cập nhật';
            document.getElementById('v-diachi').innerText = diachi || 'Chưa cập nhật';
            document.getElementById('v-ngaytao').innerText = ngaytao;
            
            var modal = new bootstrap.Modal(document.getElementById('viewUserModal'));
            modal.show();
        }

        // Xử lý dữ liệu đẩy vào Modal Khóa/Mở khóa
        function confirmToggleStatus(maND, hoten, currentStatus) {
            document.getElementById('toggle-maND').value = maND;
            document.getElementById('toggle-currentStatus').value = currentStatus;
            document.getElementById('toggle-hoten').innerText = hoten;
            
            let actionText = currentStatus === 'Khoa' ? 'MỞ KHÓA' : 'KHÓA';
            document.getElementById('action-text').innerText = actionText;
            
            let btnConfirm = document.getElementById('btn-confirm-action');
            if(currentStatus === 'Khoa') {
                btnConfirm.className = "btn btn-success";
            } else {
                btnConfirm.className = "btn btn-warning text-dark fw-bold";
            }

            var modal = new bootstrap.Modal(document.getElementById('toggleStatusModal'));
            modal.show();
        }
    </script>
</body>
</html>