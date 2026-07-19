<%-- 
    Document   : login
    Created on : Jul 3, 2026, 2:40:00 PM
    Author     : asus
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LOGIN </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body class="login-page">
        <div class="container-fluid min-vh-100 d-flex align-items-center justify-content-center px-3 py-4">
            <div class="row w-100 justify-content-center">
                <div class="col-12 col-xl-10">
                    <div class="login-shell">
                        <div class="login-hero">
                            <h1></h1>
                        </div>

                        <div class="login-panel">
                            <div class="text-center mb-4">
                                <div class="brand-mark">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 0c-.69 0-1.843.265-2.928.56-1.11.3-2.229.655-2.887.87a1.54 1.54 0 0 0-1.044 1.262c-.596 4.477.787 7.795 2.465 9.99a11.777 11.777 0 0 0 2.517 2.453c.386.273.744.482 1.048.625.28.132.581.24.829.24s.548-.108.829-.24a7.159 7.159 0 0 0 1.048-.625 11.775 11.775 0 0 0 2.517-2.453c1.678-2.195 3.061-5.513 2.465-9.99a1.541 1.541 0 0 0-1.044-1.263 62.467 62.467 0 0 0-2.887-.87C9.843.266 8.69 0 8 0zm0 5a1.5 1.5 0 0 1 .5 2.915l.385 1.99a.5.5 0 0 1-.491.595h-.788a.5.5 0 0 1-.49-.595l.384-1.99A1.5 1.5 0 0 1 8 5z"/>
                                    </svg>
                                </div>
                                <h2 class="fw-bold mb-2">LOGIN</h2>
                                <p class="text-muted mb-0">Welcome!</p>
                            </div>

                            <form action="login" method="POST">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="username" name="email" placeholder="account" required>
                                    <label for="username">Email</label>
                                </div>

                                <div class="form-floating mb-4">
                                    <input type="password" class="form-control" id="password" name="pass" placeholder="password" required>
                                    <label for="password">Password</label>
                                </div>

                                <c:if test="${not empty err}">
                                    <div class="alert alert-warning rounded-pill" role="alert">${err}</div>
                                </c:if>

                                <button class="btn btn-primary w-100 py-2 fw-bold rounded-pill login-submit" type="submit">
                                    LOGIN
                                </button>
                            </form>

                            <div class="text-center mt-4 small text-muted">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
