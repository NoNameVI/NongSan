<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Sản Phẩm - Admin</title>
        <!-- Nhúng Bootstrap 5 và Icons -->
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
                z-index: 1000;
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
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }

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
                text-transform: uppercase;
            }
            .form-control-custom, .form-select-custom {
                border: 2px solid #6c757d;
                border-radius: 0;
            }
            .form-control-custom:focus, .form-select-custom:focus {
                border-color: #212529;
                box-shadow: none;
            }

            /* Bảng dữ liệu tương phản cao */
            .table-custom {
                margin-bottom: 0;
            }
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
            .badge {
                border-radius: 0;
                padding: 6px 10px;
                font-weight: 600;
                border: 1px solid transparent;
            }
            .badge-active {
                background-color: #fff;
                color: #198754;
                border-color: #198754;
            }
            .badge-locked {
                background-color: #fff;
                color: #dc3545;
                border-color: #dc3545;
            }

            /* Hình ảnh sản phẩm trong bảng */
            .product-img-sm {
                width: 50px;
                height: 50px;
                object-fit: cover;
                border: 2px solid #dee2e6;
            }
        </style>
    </head>
    <body>
        <nav style="background-color:#112518; border-bottom:1px solid #183625; position:sticky; top:0; z-index:1030;">
            <div style="display:flex; justify-content:space-between; align-items:center; padding:12px 24px;">
                <a href="${pageContext.request.contextPath}/home" style="font-weight:bold; color:#4ade80; text-decoration:none; font-size:1.1rem;">🌿 Rau Thép</a>
                <div style="display:flex; gap:16px; align-items:center;">
                    <a href="${pageContext.request.contextPath}/home" style="color:#e2e8f0; text-decoration:none;">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/products" style="color:#e2e8f0; text-decoration:none;">Cửa hàng</a>
                    <a href="${pageContext.request.contextPath}/logout" style="color:#f87171; text-decoration:none;">Đăng xuất</a>
                </div>
            </div>
        </nav>

        <!-- SIDEBAR CHUNG CHO ADMIN -->
        <div class="sidebar">
            <h4 class="text-white text-center mb-4 fw-bold tracking-wide">ADMIN PANEL</h4>
            <a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="active"><i class="bi bi-box-seam me-2"></i> Sản Phẩm</a>
            <c:if test="${sessionScope.user.maVaiTro.maVaiTro == 3}">
                <a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i> Người Dùng</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-cart-check me-2"></i> Đơn Hàng</a>
            <a href="${pageContext.request.contextPath}/logout" class="text-danger mt-4 border-top border-secondary"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <!-- HEADER -->
            <div class="admin-header">
                <h4 class="mb-0 fw-bold text-dark text-uppercase">Quản Lý Sản Phẩm</h4>
                <div class="d-flex align-items-center">
                    <!-- Đọc tên từ Cookie fullname, nếu trống thì hiển thị 'Admin' -->
                    <c:set var="adminName" value="${not empty cookie.fullname.value ? fn:replace(cookie.fullname.value, '_', ' ') : 'Admin'}" />

                    <span class="fw-bold me-3 text-dark">Xin chào, ${adminName}!</span>

                    <!-- Tự động tạo ảnh đại diện (Avatar) dựa trên chữ cái đầu của tên -->
                    <img src="https://ui-avatars.com/api/?name=${adminName}&background=212529&color=fff&rounded=false"
                         alt="${adminName}" width="45" style="border: 2px solid #212529;">
                </div>
            </div>

            <!-- BẮT LỖI / THÔNG BÁO -->
            <c:if test="${not empty msg}">
                <div class="alert alert-success fw-bold" style="border: 2px solid #198754; border-radius: 0;">${msg}</div>
            </c:if>
            <c:if test="${not empty err}">
                <div class="alert alert-danger fw-bold" style="border: 2px solid #dc3545; border-radius: 0;">${err}</div>
            </c:if>

            <!-- THANH CÔNG CỤ: TÌM KIẾM & THÊM MỚI -->
            <div class="card-custom p-3 d-flex justify-content-between align-items-center">
                <form action="${pageContext.request.contextPath}/admin/products" method="GET" class="d-flex w-50">
                    <input type="text" name="search" class="form-control form-control-custom me-2" placeholder="Tìm kiếm tên sản phẩm..." value="${searchQuery}">
                    <button type="submit" class="btn btn-dark btn-custom px-4"><i class="bi bi-search"></i> TÌM</button>
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-danger btn-custom ms-2">HỦY</a>
                    </c:if>
                </form>

                <button class="btn btn-success btn-custom px-4" data-bs-toggle="modal" data-bs-target="#productModal" onclick="openAddModal()">
                    <i class="bi bi-plus-lg"></i> THÊM SẢN PHẨM
                </button>
            </div>

            <!-- BẢNG DỮ LIỆU SẢN PHẨM -->
            <div class="card-custom">
                <div class="table-responsive">
                    <table class="table table-striped table-hover table-custom mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Hình Ảnh</th>
                                <th>Tên Sản Phẩm</th>
                                <th>Danh Mục</th>
                                <th>Đơn Giá</th>
                                <th>Kho</th>
                                <th>Trạng Thái</th>
                                <th class="text-end pe-4">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${listProducts}">
                                <tr>
                                    <td class="ps-4 fw-bold text-dark">#${p.maSP}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/${p.hinhAnh}" class="product-img-sm" onerror="this.src='https://placehold.co/50x50?text=No+Image'">
                                    </td>
                                    <td class="fw-semibold text-truncate" style="max-width: 200px;" title="${p.tenSP}">${p.tenSP}</td>
                                    <td><span class="badge bg-dark text-white border border-dark">${p.maDanhMuc.tenDanhMuc}</span></td>
                                    <td class="fw-bold text-danger"><fmt:formatNumber value="${p.donGia}" pattern="#,##0"/> đ</td>
                                    <td>${p.soLuongTon} ${p.donViTinh}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.trangThai == 'Con hang'}">
                                                <span class="badge badge-active">CÒN HÀNG</span>
                                            </c:when>
                                            <c:when test="${p.trangThai == 'Het hang'}">
                                                <span class="badge bg-warning text-dark border-warning">HẾT HÀNG</span>
                                            </c:when>
                                            <c:when test="${p.trangThai == 'Ngung ban'}">
                                                <span class="badge badge-locked">NGỪNG BÁN</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary text-white border-secondary">${p.trangThai}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <!-- Nút Sửa -->
                                        <button type="button" class="btn btn-sm btn-outline-primary btn-custom me-1"
                                                onclick="openEditModal(${p.maSP}, '${p.tenSP}', ${p.maDanhMuc.maDanhMuc}, ${p.maNCC.maNCC}, '${p.donGia}', ${p.soLuongTon}, '${p.donViTinh}', '${p.trangThai}', '${p.hinhAnh}', '${p.moTa}')" title="Sửa sản phẩm">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>

                                        <!-- Nút Đổi Trạng Thái -->
                                        <c:set var="isLocked" value="${p.trangThai == 'Ngung ban' || p.trangThai == 'Het hang'}" />
                                        <button type="button" class="btn btn-sm btn-custom ${isLocked ? 'btn-success' : 'btn-danger'}"
                                                onclick="confirmToggleStatus(${p.maSP}, '${p.tenSP}', '${p.trangThai}')" title="${isLocked ? 'Mở bán lại' : 'Ngừng bán'}">
                                            <i class="bi ${isLocked ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listProducts}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted fw-bold py-5 bg-light">KHÔNG TÌM THẤY SẢN PHẨM NÀO.</td>
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

        <!-- ================== KHU VỰC MODAL (POPUP) ================== -->

        <!-- Modal Thêm/Sửa Sản Phẩm -->
        <div class="modal fade" id="productModal" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content" style="border-radius: 0; border: 3px solid #212529;">
                    <form action="${pageContext.request.contextPath}/admin/products" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="action" id="form-action" value="add">
                        <input type="hidden" name="maSP" id="f-maSP">

                        <div class="modal-header bg-dark text-white" style="border-radius: 0; border-bottom: none;">
                            <h5 class="modal-title fw-bold text-uppercase" id="modal-title">Thêm Sản Phẩm Mới</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body p-4 bg-light">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="fw-bold mb-1">Tên Sản Phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control form-control-custom" name="tenSP" id="f-tenSP" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="fw-bold mb-1">Danh Mục <span class="text-danger">*</span></label>
                                    <select class="form-select form-select-custom" name="maDanhMuc" id="f-maDanhMuc" required>
                                        <c:forEach var="cat" items="${listCategories}">
                                            <option value="${cat.maDanhMuc}">${cat.tenDanhMuc}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="fw-bold mb-1">Nhà Cung Cấp <span class="text-danger">*</span></label>
                                    <select class="form-select form-select-custom" name="maNhaCungCap" id="f-maNhaCungCap" required>
                                        <c:forEach var="ncc" items="${listSuppliers}">
                                            <option value="${ncc.maNCC}">${ncc.tenNCC}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label class="fw-bold mb-1">Đơn Giá (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control form-control-custom" name="donGia" id="f-donGia" required min="0" step="1000">
                                </div>
                                <div class="col-md-4">
                                    <label class="fw-bold mb-1">Số Lượng Tồn <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control form-control-custom" name="soLuongTon" id="f-soLuongTon" required min="0">
                                </div>
                                <div class="col-md-4">
                                    <label class="fw-bold mb-1">Đơn Vị Tính <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control form-control-custom" name="donViTinh" id="f-donViTinh" placeholder="Kg, Hộp, Túi..." required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="fw-bold mb-1">Mô Tả Sản Phẩm</label>
                                <textarea class="form-control form-control-custom" name="moTa" id="f-moTa" rows="3"></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="fw-bold mb-1">Hình Ảnh Sản Phẩm (File)</label>
                                <input type="file" class="form-control form-control-custom" name="hinhAnhFile" id="f-hinhAnhFile" accept="image/*">
                                <small class="text-muted">Để trống nếu không muốn thay đổi ảnh (khi cập nhật).</small>
                            </div>

                            <div class="mb-2" id="div-trangThai" style="display: none;">
                                <label class="fw-bold mb-1">Trạng Thái</label>
                                <select class="form-select form-select-custom" name="trangThai" id="f-trangThai">
                                    <option value="Con hang">Còn hàng</option>
                                    <option value="Het hang">Hết hàng</option>
                                    <option value="Ngung ban">Ngừng bán</option>
                                </select>
                            </div>
                        </div>

                        <div class="modal-footer bg-white" style="border-top: 2px solid #dee2e6;">
                            <button type="button" class="btn btn-outline-dark btn-custom" data-bs-dismiss="modal">HỦY</button>
                            <button type="submit" class="btn btn-dark btn-custom" id="btn-save">LƯU SẢN PHẨM</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Xác Nhận Cập Nhật Trạng Thái (Ngừng Bán / Mở Bán) -->
        <div class="modal fade" id="toggleStatusModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius: 0; border: 3px solid #dc3545;">
                    <form action="${pageContext.request.contextPath}/admin/products" method="POST">
                        <input type="hidden" name="action" value="toggleStatus">
                        <input type="hidden" name="maSP" id="toggle-maSP">
                        <input type="hidden" name="currentStatus" id="toggle-currentStatus">

                        <div class="modal-header bg-danger text-white" style="border-radius: 0;">
                            <h5 class="modal-title fw-bold text-uppercase"><i class="bi bi-exclamation-triangle-fill me-2"></i> Cảnh Báo</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4 text-center fs-5">
                            Bạn có chắc chắn muốn <strong id="action-text" class="text-danger"></strong> sản phẩm <br><strong id="toggle-tensp" class="fs-4 text-dark"></strong>?
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
                                                    // Mở modal Thêm Sản Phẩm
                                                    function openAddModal() {
                                                        document.getElementById('form-action').value = 'add';
                                                        document.getElementById('modal-title').innerText = 'THÊM SẢN PHẨM MỚI';
                                                        document.getElementById('btn-save').innerText = 'THÊM SẢN PHẨM';

                                                        // Reset form
                                                        document.getElementById('f-maSP').value = '';
                                                        document.getElementById('f-tenSP').value = '';
                                                        document.getElementById('f-maDanhMuc').selectedIndex = 0;
                                                        document.getElementById('f-maNhaCungCap').selectedIndex = 0;
                                                        document.getElementById('f-donGia').value = '';
                                                        document.getElementById('f-soLuongTon').value = '';
                                                        document.getElementById('f-donViTinh').value = '';
                                                        document.getElementById('f-moTa').value = '';
                                                        document.getElementById('f-hinhAnhFile').required = true; // Yêu cầu ảnh khi thêm mới
                                                        document.getElementById('div-trangThai').style.display = 'none'; // Ẩn chọn trạng thái khi thêm
                                                    }

                                                    // Mở modal Sửa Sản Phẩm
                                                    function openEditModal(id, name, catId, supplierId, price, stock, unit, status, image, desc) {
                                                        document.getElementById('form-action').value = 'update';
                                                        document.getElementById('modal-title').innerText = 'CẬP NHẬT SẢN PHẨM';
                                                        document.getElementById('btn-save').innerText = 'LƯU THAY ĐỔI';

                                                        // Fill data
                                                        document.getElementById('f-maSP').value = id;
                                                        document.getElementById('f-tenSP').value = name;
                                                        document.getElementById('f-maDanhMuc').value = catId;
                                                        document.getElementById('f-maNhaCungCap').value = supplierId;
                                                        document.getElementById('f-donGia').value = price;
                                                        document.getElementById('f-soLuongTon').value = stock;
                                                        document.getElementById('f-donViTinh').value = unit;
                                                        document.getElementById('f-moTa').value = desc || '';
                                                        document.getElementById('f-hinhAnhFile').required = false; // Không bắt buộc cập nhật ảnh

                                                        document.getElementById('div-trangThai').style.display = 'block';
                                                        document.getElementById('f-trangThai').value = status;

                                                        var modal = new bootstrap.Modal(document.getElementById('productModal'));
                                                        modal.show();
                                                    }

                                                    // Xử lý Modal Xác nhận Đổi trạng thái
                                                    // Xử lý Modal Xác nhận Đổi trạng thái
                                                    function confirmToggleStatus(maSP, tenSP, currentStatus) {
                                                        document.getElementById('toggle-maSP').value = maSP;
                                                        document.getElementById('toggle-currentStatus').value = currentStatus;
                                                        document.getElementById('toggle-tensp').innerText = tenSP;

                                                        // Đổi chữ cảnh báo
                                                        let actionText = (currentStatus === 'Ngung ban' || currentStatus === 'Het hang') ? 'MỞ BÁN' : 'NGỪNG BÁN';
                                                        document.getElementById('action-text').innerText = actionText;

                                                        // Đổi màu Modal
                                                        let btnConfirm = document.getElementById('btn-confirm-action');
                                                        if (currentStatus === 'Ngung ban' || currentStatus === 'Het hang') {
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