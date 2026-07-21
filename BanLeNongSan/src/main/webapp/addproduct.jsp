<%-- 
    Document   : AddProduct
    Created on : Jul 19, 2026, 12:14:50 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm sản phẩm - Rau Thép</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: { extend: { colors: { brand: { dark: '#112518', card: '#183625', primary: '#4ade80', accent: '#f97316', text: '#e2e8f0', muted: '#94a3b8' }}}}
            }
        </script>
    </head>
    <body class="min-h-screen bg-brand-dark text-brand-text">
        <nav class="flex items-center justify-between px-10 py-4 bg-brand-dark text-brand-text border-b border-brand-card sticky top-0 z-50">
            <a href="home" class="flex items-center gap-2 text-xl font-bold text-brand-primary">
                <span>🌿</span> Rau Thép
            </a>
            <div class="flex gap-6 text-sm font-medium">
                <a href="home" class="hover:text-brand-primary transition">Trang chủ</a>
                <a href="products" class="hover:text-brand-primary transition">Cửa hàng</a>
            </div>
        </nav>
        <div class="max-w-5xl mx-auto px-6 py-12">
            <h1 class="text-3xl font-bold text-white mb-4">Thêm sản phẩm mới</h1>
            <p class="text-brand-muted">Trang quản trị đang được chuẩn bị cho chức năng này.</p>
        </div>
    </body>
</html>
