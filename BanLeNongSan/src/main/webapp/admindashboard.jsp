<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Admin</title>
        <!-- Nhúng Bootstrap 5 và Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <!-- Nhúng Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

            /* Các thẻ Card vuông vức, có viền */
            .card-custom {
                background: #ffffff;
                border: 2px solid #212529;
                border-radius: 0; /* Bỏ góc bo */
                margin-bottom: 25px;
                height: 100%;
            }
            .card-header-custom {
                background-color: #212529;
                color: #ffffff;
                padding: 12px 20px;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
                border-bottom: 2px solid #212529;
            }

            /* Bảng dữ liệu tương phản cao */
            .table-custom {
                margin-bottom: 0;
            }
            .table-custom thead th {
                background-color: #f8f9fa;
                color: #212529;
                border-bottom: 2px solid #212529;
                text-transform: uppercase;
                font-size: 13px;
            }
            .table-custom tbody td {
                border-bottom: 1px solid #dee2e6;
                vertical-align: middle;
                font-weight: 500;
            }

            /* Cột xếp hạng */
            .rank-badge {
                display: inline-block;
                width: 28px;
                height: 28px;
                line-height: 28px;
                text-align: center;
                background-color: #212529;
                color: #fff;
                font-weight: bold;
            }
            .rank-1 {
                background-color: #ffc107;
                color: #000;
            }
            .rank-2 {
                background-color: #c0c0c0;
                color: #000;
            }
            .rank-3 {
                background-color: #cd7f32;
                color: #fff;
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
            <a href="${pageContext.request.contextPath}/dashboard" class="active"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-2"></i> Sản Phẩm</a>
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
                <h4 class="mb-0 fw-bold text-dark text-uppercase">Bảng Điều Khiển</h4>
                <div class="d-flex align-items-center">
                    <!-- Đọc tên từ Cookie fullname, nếu trống thì hiển thị 'Admin' -->
                    <c:set var="adminName" value="${not empty cookie.fullname.value ? fn:replace(cookie.fullname.value, '_', ' ') : 'Admin'}" />

                    <span class="fw-bold me-3 text-dark">Xin chào, ${adminName}!</span>

                    <!-- Tự động tạo ảnh đại diện (Avatar) dựa trên chữ cái đầu của tên -->
                    <img src="https://ui-avatars.com/api/?name=${adminName}&background=212529&color=fff&rounded=false" 
                         alt="${adminName}" width="45" style="border: 2px solid #212529;">
                </div>
            </div>

            <div class="row">
                <!-- BIỂU ĐỒ DOANH THU -->
                <div class="col-lg-8 mb-4">
                    <div class="card-custom d-flex flex-column">
                        <div class="card-header-custom">
                            <i class="bi bi-bar-chart-fill me-2"></i> BIỂU ĐỒ DOANH THU THEO THÁNG NĂM NAY
                        </div>
                        <div class="p-4 flex-grow-1">
                            <canvas id="revenueChart" style="max-height: 400px; width: 100%;"></canvas>
                        </div>
                    </div>
                </div>

                <!-- TOP SẢN PHẨM BÁN CHẠY -->
                <div class="col-lg-4 mb-4">
                    <div class="card-custom d-flex flex-column">
                        <div class="card-header-custom">
                            <i class="bi bi-trophy-fill me-2 text-warning"></i> TOP SẢN PHẨM BÁN CHẠY
                        </div>
                        <div class="table-responsive flex-grow-1">
                            <table class="table table-custom table-hover">
                                <thead>
                                    <tr>
                                        <th class="ps-3" style="width: 20%;">Hạng</th>
                                        <th>Sản Phẩm</th>
                                        <th class="text-end pe-3">Đã Bán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="prod" items="${topProducts}" varStatus="status">
                                        <tr>
                                            <td class="ps-3">
                                                <span class="rank-badge ${status.index == 0 ? 'rank-1' : (status.index == 1 ? 'rank-2' : (status.index == 2 ? 'rank-3' : ''))}">
                                                    ${status.index + 1}
                                                </span>
                                            </td>
                                            <td class="text-truncate" style="max-width: 150px;" title="${prod[0]}">
                                                ${prod[0]}
                                            </td>
                                            <td class="text-end pe-3 fw-bold text-success">
                                                ${prod[1]}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty topProducts}">
                                        <tr>
                                            <td colspan="3" class="text-center py-4 text-muted">Chưa có dữ liệu bán hàng.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- XỬ LÝ DỮ LIỆU TỪ SERVLET SANG JAVASCRIPT CHO BIỂU ĐỒ -->
        <script>
            // Mảng chứa nhãn (Tháng) và Dữ liệu (Doanh thu)
            const labels = [];
            const dataValues = [];

            <c:forEach var="rev" items="${revenueList}">
        labels.push('Tháng ${rev[0]}');
        dataValues.push(${rev[1]});
            </c:forEach>

            // Cấu hình Chart.js với phong cách khối hộp, viền đậm
            document.addEventListener("DOMContentLoaded", function () {
                const ctx = document.getElementById('revenueChart').getContext('2d');
                const revenueChart = new Chart(ctx, {
                    type: 'bar', // Dùng biểu đồ cột
                    data: {
                        labels: labels,
                        datasets: [{
                                label: 'Doanh thu (VNĐ)',
                                data: dataValues,
                                backgroundColor: '#212529', // Màu cột đen tuyền
                                borderColor: '#212529',
                                borderWidth: 2,
                                hoverBackgroundColor: '#0d6efd'
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false // Ẩn chú giải vì chỉ có 1 cột
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let value = context.raw || 0;
                                        return value.toLocaleString('vi-VN') + ' đ';
                                    }
                                },
                                backgroundColor: '#000',
                                titleFont: {size: 14, family: 'Segoe UI'},
                                bodyFont: {size: 14, family: 'Segoe UI', weight: 'bold'},
                                padding: 10,
                                cornerRadius: 0 // Bỏ góc bo của tooltip
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: '#e9ecef',
                                    drawBorder: true,
                                    borderColor: '#212529' // Viền trục Y đậm
                                },
                                ticks: {
                                    font: {weight: 'bold', family: 'Segoe UI'},
                                    color: '#212529',
                                    callback: function (value) {
                                        if (value >= 1000000) {
                                            return (value / 1000000) + 'Tr'; // Rút gọn nếu số tiền lớn
                                        } else if (value >= 1000) {
                                            return (value / 1000) + 'K';
                                        }
                                        return value;
                                    }
                                }
                            },
                            x: {
                                grid: {
                                    display: false,
                                    drawBorder: true,
                                    borderColor: '#212529' // Viền trục X đậm
                                },
                                ticks: {
                                    font: {weight: 'bold', family: 'Segoe UI'},
                                    color: '#212529'
                                }
                            }
                        }
                    }
                });
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>