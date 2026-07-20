<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử đơn hàng - Nông Sản Việt</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = { theme: { extend: { colors: { brand: {
                dark: '#112518', card: '#183625', primary: '#4ade80',
                accent: '#f97316', text: '#e2e8f0', muted: '#94a3b8'
            }}}}};
        </script>
    </head>
    <body class="min-h-screen bg-brand-dark font-sans text-brand-text">
        <nav class="flex items-center justify-between border-b border-brand-card bg-brand-dark px-6 py-4 md:px-10">
            <a href="home" class="text-xl font-bold text-brand-primary">🌿 Nông Sản Việt</a>
            <div class="flex gap-4 text-sm font-medium">
                <a href="products" class="hover:text-brand-primary">Cửa hàng</a>
                <a href="cart" class="hover:text-brand-primary">Giỏ hàng</a>
            </div>
        </nav>

        <main class="mx-auto max-w-6xl px-4 py-10 md:px-6">
            <div class="mb-8 flex flex-wrap items-end justify-between gap-4">
                <div>
                    <p class="mb-2 text-sm font-semibold uppercase tracking-widest text-brand-primary">Tài khoản của bạn</p>
                    <h1 class="text-3xl font-bold text-white">Lịch sử đơn hàng</h1>
                </div>
                <a href="products" class="rounded-lg bg-brand-primary px-5 py-3 font-bold text-brand-dark transition hover:bg-green-400">Tiếp tục mua sắm</a>
            </div>

            <c:if test="${not empty msg}">
                <div class="mb-6 rounded-lg border border-green-400/40 bg-green-400/10 px-4 py-3 text-green-300">✓ ${msg}</div>
            </c:if>
            <c:if test="${not empty err}">
                <div class="mb-6 rounded-lg border border-red-400/40 bg-red-400/10 px-4 py-3 text-red-300">⚠ ${err}</div>
            </c:if>

            <c:choose>
                <c:when test="${empty orderHistory}">
                    <section class="rounded-xl border border-brand-card bg-brand-card p-12 text-center shadow-xl">
                        <div class="mb-4 text-5xl">📦</div>
                        <h2 class="text-xl font-bold text-white">Bạn chưa có đơn hàng nào</h2>
                        <p class="mt-2 text-brand-muted">Hãy khám phá các sản phẩm nông sản tươi ngon của chúng tôi.</p>
                    </section>
                </c:when>
                <c:otherwise>
                    <section class="overflow-hidden rounded-xl border border-brand-card bg-brand-card shadow-xl">
                        <div class="overflow-x-auto">
                            <table class="min-w-full text-left text-sm">
                                <thead class="bg-brand-dark text-brand-muted">
                                    <tr>
                                        <th class="px-5 py-4 font-semibold">Mã đơn</th>
                                        <th class="px-5 py-4 font-semibold">Ngày đặt</th>
                                        <th class="px-5 py-4 font-semibold">Địa chỉ giao</th>
                                        <th class="px-5 py-4 font-semibold">Tổng tiền</th>
                                        <th class="px-5 py-4 font-semibold">Trạng thái</th>
                                        <th class="px-5 py-4 text-right font-semibold">Chi tiết</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-brand-dark">
                                    <c:forEach items="${orderHistory}" var="order">
                                        <tr class="transition hover:bg-brand-dark/50">
                                            <td class="px-5 py-4 font-bold text-white">#${order.maDH}</td>
                                            <td class="whitespace-nowrap px-5 py-4"><fmt:formatDate value="${order.ngayDat}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td class="max-w-xs px-5 py-4 text-brand-muted">${order.diaChiGiao}</td>
                                            <td class="whitespace-nowrap px-5 py-4 font-bold text-brand-primary"><fmt:formatNumber value="${order.tongTien}" pattern="#,##0 đ"/></td>
                                            <td class="px-5 py-4">
                                                <span class="rounded-full bg-amber-400/15 px-3 py-1 text-xs font-bold text-amber-300">${order.trangThai}</span>
                                            </td>
                                            <td class="px-5 py-4 text-right"><a href="orderhistory?action=detail&id=${order.maDH}" class="font-bold text-brand-primary hover:underline">Xem đơn</a></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty selectedOrder}">
                <section class="mt-8 overflow-hidden rounded-xl border border-brand-primary/40 bg-brand-card shadow-xl">
                    <div class="flex flex-wrap items-center justify-between gap-3 border-b border-brand-dark px-6 py-5">
                        <div>
                            <h2 class="text-xl font-bold text-white">Chi tiết đơn #${selectedOrder.maDH}</h2>
                            <p class="mt-1 text-sm text-brand-muted">${selectedOrder.diaChiGiao}</p>
                        </div>
                        <a href="orderhistory" class="text-sm font-bold text-brand-primary hover:underline">Đóng chi tiết</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full text-sm">
                            <thead class="bg-brand-dark text-left text-brand-muted">
                                <tr><th class="px-6 py-4">Sản phẩm</th><th class="px-6 py-4">Đơn giá</th><th class="px-6 py-4">Số lượng</th><th class="px-6 py-4 text-right">Thành tiền</th></tr>
                            </thead>
                            <tbody class="divide-y divide-brand-dark">
                                <c:forEach items="${orderDetails}" var="detail">
                                    <tr>
                                        <td class="px-6 py-4 font-semibold text-white">${detail.sanPham.tenSP}</td>
                                        <td class="px-6 py-4"><fmt:formatNumber value="${detail.donGia}" pattern="#,##0 đ"/></td>
                                        <td class="px-6 py-4">${detail.soLuong}</td>
                                        <td class="px-6 py-4 text-right font-bold text-brand-primary"><fmt:formatNumber value="${detail.thanhTien}" pattern="#,##0 đ"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot class="bg-brand-dark"><tr><td colspan="3" class="px-6 py-4 text-right font-bold text-white">Tổng thanh toán</td><td class="px-6 py-4 text-right text-lg font-bold text-brand-primary"><fmt:formatNumber value="${selectedOrder.tongTien}" pattern="#,##0 đ"/></td></tr></tfoot>
                        </table>
                    </div>
                </section>
            </c:if>
        </main>
    </body>
</html>
