<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Admin</title>
    <!-- Nhúng Bootstrap 5 và Icons[cite: 16] -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* Thiết kế độ tương phản cao, viền rõ nét, không bo tròn */
        body { 
            background-color: #f4f6f9; 
            color: #212529; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            overflow-x: hidden; 
        }
        
        /* Sidebar dứt khoát, tương phản mạnh */
        .sidebar { 
            height: 100vh; 
            background-color: #121518; /* Đen tuyền */
            padding-top: 20px; 
            position: fixed; 
            width: 250px; 
            border-right: 2px solid #343a40; 
        }
        .sidebar a { 
            color: #d1d5db; 
            text-decoration: none; 
            padding: 15px 20px; 
            display: block; 
            font-weight: 600; 
            border-bottom: 1px solid #2c3034;
            transition: all 0.2s ease-in-out;
        }
        .sidebar a:hover, .sidebar a.active { 
            color: #ffffff; 
            background-color: #0d6efd; 
            border-left: 6px solid #ffc107; /* Viền vàng nhấn mạnh */
        }
        
        /* Main Content & Layout */
        .main-content { margin-left: 250px; padding: 30px; }
        
        .admin-header { 
            background: #ffffff; 
            padding: 15px 25px; 
            border: 2px solid #212529; /* Viền đen rõ ràng */
            margin-bottom: 25px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }

        /* Các thẻ Card và Button vuông vức, có viền */
        .card-custom { 
            background: #ffffff;
            border: 2px solid #212529; 
            border-radius: 0; /* Bỏ góc bo */
            margin-bottom: 25px;
        }
        .btn-custom { 
            border-radius: 0; 
            font-weight: bold; 
            border-width: 2px; 
        }
        .form-control-custom { 
            border: 2px solid #6c757d; 
            border-radius: 0; 
        }
        .form-control-custom:focus { 
            border-color: #212529; 
            box-shadow: none; 
        }

        /* Bảng dữ liệu tương phản cao */
        .table-custom { margin-bottom: 0; }
        .table-custom thead th { 
            background-color: #212529; 
            color: #ffffff; 
            border: 1px solid #212529;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        .table-custom tbody td { 
            border: 1px solid #dee2e6; 
            vertical-align: middle;
        }
        
        /* Badge vuông */
        .badge { border-radius: 0; padding: 6px 10px; font-weight: 600; border: 1px solid transparent; }
        .badge-active { background-color: #fff; color: #198754; border-color: #198754; }
        .badge-locked { background-color: #fff; color: #dc3545; border-color: #dc3545; }
    </style>
</head>
<body>

    <!-- SIDEBAR CHUNG CHO ADMIN[cite: 16] -->
    <div class="sidebar">
        <h4 class="text-white text-center mb-4 fw-bold tracking-wide">ADMIN PANEL</h4>
        <a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-2"></i> Sản Phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="bi bi-people me-2"></i> Người Dùng</a>
        <a href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-cart-check me-2"></i> Đơn Hàng</a>
        <a href="${pageContext.request.contextPath}/logout" class="text-danger mt-4 border-top border-secondary"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
    </div>

    <!-- MAIN CONTENT[cite: 16] -->
    <div class="main-content">
        <!-- HEADER[cite: 16] -->
        <div class="admin-header">
            <h4 class="mb-0 fw-bold text-dark text-uppercase">Quản Lý Người Dùng</h4>
            <div class="d-flex align-items-center">
                <span class="fw-bold me-3 text-dark">Xin chào, Admin!</span>
                <img src="https://ui-avatars.com/api/?name=Admin&background=212529&color=fff&rounded=false" alt="Admin" width="45" style="border: 2px solid #212529;">
            </div>
        </div>

        <!-- THANH CÔNG CỤ: TÌM KIẾM[cite: 16] -->
        <div class="card-custom p-3">
            <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="d-flex w-50">
                <input type="text" name="search" class="form-control form-control-custom me-2" placeholder="Tìm kiếm theo tên, email..." value="${searchQuery}">
                <button type="submit" class="btn btn-dark btn-custom px-4"><i class="bi bi-search"></i> TÌM</button>
                <c:if test="${not empty searchQuery}">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-danger btn-custom ms-2">HỦY</a>
                </c:if>
            </form>
        </div>

        <!-- BẢNG DỮ LIỆU NGƯỜI DÙNG[cite: 16] -->
        <div class="card-custom">
            <div class="table-responsive">
                <table class="table table-striped table-hover table-custom mb-0">
                    <thead>
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
                                <td class="ps-4 fw-bold text-dark">#${u.maND}</td>
                                <td class="fw-semibold">${u.hoTen}</td>
                                <td>${u.email}</td>
                                <td>
                                    <!-- Vai trò: 1 thường là Khách hàng, 2 là Admin[cite: 16] -->
                                    <span class="badge bg-dark text-white border border-dark">${u.maVaiTro.tenVaiTro}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.trangThai == 'Hoat dong'}">
                                            <span class="badge badge-active">HOẠT ĐỘNG</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-locked">ĐÃ KHÓA</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-4">
                                    <!-- Nút Xem chi tiết[cite: 16] -->
                                    <button type="button" class="btn btn-sm btn-outline-dark btn-custom me-1" onclick="viewDetails('${u.hoTen}', '${u.email}', '${u.sdt}', '${u.diaChi}', '${u.ngayTao}')" title="Xem chi tiết">
                                        <i class="bi bi-eye-fill"></i>
                                    </button>
                                    
                                    <!-- Nút Khóa / Mở Khóa[cite: 16] -->
                                    <button type="button" class="btn btn-sm btn-custom ${u.trangThai == 'Khoa' ? 'btn-success' : 'btn-danger'}" 
                                            onclick="confirmToggleStatus(${u.maND}, '${u.hoTen}', '${u.trangThai}')" title="${u.trangThai == 'Khoa' ? 'Mở khóa' : 'Khóa'}">
                                        <i class="bi ${u.trangThai == 'Khoa' ? 'bi-unlock-fill' : 'bi-lock-fill'}"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty listUsers}">
                            <tr>
                                <td colspan="6" class="text-center text-muted fw-bold py-5 bg-light">KHÔNG TÌM THẤY DỮ LIỆU.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- PHÂN TRANG[cite: 16] -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link text-dark fw-bold" href="?page=${currentPage - 1}&search=${searchQuery}" style="border-radius: 0; border: 2px solid #dee2e6;">TRƯỚC</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link fw-bold ${currentPage == i ? 'bg-dark text-white border-dark' : 'text-dark'}" href="?page=${i}&search=${searchQuery}" style="border-radius: 0; border: 2px solid ${currentPage == i ? '#212529' : '#dee2e6'};">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link text-dark fw-bold" href="?page=${currentPage + 1}&search=${searchQuery}" style="border-radius: 0; border: 2px solid #dee2e6;">SAU</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- ================== KHU VỰC MODAL (POPUP)[cite: 16] ================== -->

    <!-- Modal Xem Chi Tiết Người Dùng[cite: 16] -->
    <div class="modal fade" id="viewUserModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 0; border: 3px solid #212529;">
                <div class="modal-header bg-dark text-white" style="border-radius: 0; border-bottom: none;">
                    <h5 class="modal-title fw-bold text-uppercase">Chi Tiết Người Dùng</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <table class="table table-bordered mb-0">
                        <tr><th class="bg-light w-40">Họ và tên</th><td id="v-hoten" class="fw-bold"></td></tr>
                        <tr><th class="bg-light">Email</th><td id="v-email"></td></tr>
                        <tr><th class="bg-light">Số điện thoại</th><td id="v-sdt"></td></tr>
                        <tr><th class="bg-light">Địa chỉ</th><td id="v-diachi"></td></tr>
                        <tr><th class="bg-light">Ngày tham gia</th><td id="v-ngaytao"></td></tr>
                    </table>
                </div>
                <div class="modal-footer bg-light" style="border-top: 2px solid #dee2e6;">
                    <button type="button" class="btn btn-dark btn-custom" data-bs-dismiss="modal">ĐÓNG</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Xác Nhận Khóa/Mở Khóa[cite: 16] -->
    <div class="modal fade" id="toggleStatusModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 0; border: 3px solid #dc3545;">
                <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                    <input type="hidden" name="action" value="toggleStatus">
                    <input type="hidden" name="maND" id="toggle-maND">
                    <input type="hidden" name="currentStatus" id="toggle-currentStatus">
                    
                    <div class="modal-header bg-danger text-white" style="border-radius: 0;">
                        <h5 class="modal-title fw-bold text-uppercase"><i class="bi bi-exclamation-triangle-fill me-2"></i> Cảnh Báo</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4 text-center fs-5">
                        Bạn có chắc chắn muốn <strong id="action-text" class="text-danger"></strong> tài khoản của <br><strong id="toggle-hoten" class="fs-4 text-dark"></strong>?
                    </div>
                    <div class="modal-footer bg-light" style="border-top: 2px solid #dee2e6;">
                        <button type="button" class="btn btn-outline-dark btn-custom" data-bs-dismiss="modal">HỦY BỎ</button>
                        <button type="submit" class="btn btn-danger btn-custom" id="btn-confirm-action">XÁC NHẬN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý dữ liệu đẩy vào Modal Xem Chi Tiết[cite: 16]
        function viewDetails(hoten, email, sdt, diachi, ngaytao) {
            document.getElementById('v-hoten').innerText = hoten;
            document.getElementById('v-email').innerText = email;
            document.getElementById('v-sdt').innerText = sdt || 'Chưa cập nhật';
            document.getElementById('v-diachi').innerText = diachi || 'Chưa cập nhật';
            document.getElementById('v-ngaytao').innerText = ngaytao;
            
            var modal = new bootstrap.Modal(document.getElementById('viewUserModal'));
            modal.show();
        }

        // Xử lý dữ liệu đẩy vào Modal Khóa/Mở khóa[cite: 16]
        function confirmToggleStatus(maND, hoten, currentStatus) {
            document.getElementById('toggle-maND').value = maND;
            document.getElementById('toggle-currentStatus').value = currentStatus;
            document.getElementById('toggle-hoten').innerText = hoten;
            
            let actionText = currentStatus === 'Khoa' ? 'MỞ KHÓA' : 'KHÓA';
            document.getElementById('action-text').innerText = actionText;
            
            let btnConfirm = document.getElementById('btn-confirm-action');
            if(currentStatus === 'Khoa') {
                btnConfirm.className = "btn btn-success btn-custom";
                document.querySelector('#toggleStatusModal .modal-content').style.borderColor = '#198754';
                document.querySelector('#toggleStatusModal .modal-header').className = 'modal-header bg-success text-white';
            } else {
                btnConfirm.className = "btn btn-danger btn-custom";
                document.querySelector('#toggleStatusModal .modal-content').style.borderColor = '#dc3545';
                document.querySelector('#toggleStatusModal .modal-header').className = 'modal-header bg-danger text-white';
            }

            var modal = new bootstrap.Modal(document.getElementById('toggleStatusModal'));
            modal.show();
        }
    </script>
</body>
</html>