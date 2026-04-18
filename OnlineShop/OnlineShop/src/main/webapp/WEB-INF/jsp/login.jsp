<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .login-container { margin-top: 100px; }
        .card { border: none; border-radius: 12px; }
        .btn-primary { background-color: #2563eb; border: none; padding: 10px; }
        .btn-primary:hover { background-color: #1d4ed8; }
    </style>
</head>
<body>

<div class="container login-container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card shadow-lg">
                <div class="card-body p-5">
                    <h2 class="text-center fw-bold mb-4">OnlineShop</h2>
                    <p class="text-center text-muted mb-4">Welcome back! Please login.</p>

                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger p-2 text-center" style="font-size: 0.9rem;">
                            Invalid username or password.
                        </div>
                    </c:if>

                    <c:if test="${param.logout != null}">
                        <div class="alert alert-info p-2 text-center" style="font-size: 0.9rem;">
                            You have been logged out.
                        </div>
                    </c:if>

                    <form action="/login" method="post">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" placeholder="Enter username" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary fw-bold">Login</button>
                        </div>
                    </form>

                    <div class="text-center mt-4">
                        <span class="text-muted">Don't have an account?</span>
                        <a href="/register" class="text-decoration-none ms-1">Register Now</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>