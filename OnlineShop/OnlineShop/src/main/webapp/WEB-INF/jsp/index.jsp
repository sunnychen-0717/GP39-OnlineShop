<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 【核心修復】自動重定向邏輯
    if (request.getAttribute("favs") == null && request.getRemoteUser() != null) {
        if (request.isUserInRole("ROLE_CUSTOMER") || request.isUserInRole("CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/customer/index");
            return;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .hero-section { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: white; border-radius: 24px; padding: 60px 20px; }
        .feature-card { border: none; border-radius: 18px; transition: 0.3s all ease; overflow: hidden; }
        .feature-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        .nav-logo { font-weight: 800; font-size: 1.6rem; letter-spacing: -1px; text-decoration: none; color: white !important; }
        .role-badge { font-size: 0.8rem; padding: 5px 12px; border-radius: 50px; text-transform: uppercase; letter-spacing: 1px; }
        .order-shortcut { border-radius: 15px; background: #f8fafc; border: 1px dashed #cbd5e1; transition: 0.2s; }
        .order-shortcut:hover { background: #f1f5f9; border-color: #94a3b8; }
    </style>
</head>
<body class="bg-light d-flex flex-column min-vh-100">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm sticky-top">
    <div class="container">
        <a class="navbar-brand nav-logo" href="${pageContext.request.contextPath}/customer/index">
            <i class="bi bi-bag-heart-fill me-2 text-info"></i>OnlineShop
        </a>

        <div class="ms-auto d-flex align-items-center">
            <sec:authorize access="hasAnyRole('CUSTOMER', 'ROLE_CUSTOMER')">
                <a href="${pageContext.request.contextPath}/customer/cart" class="btn btn-outline-info me-3 position-relative rounded-pill">
                    <i class="bi bi-cart3"></i>
                    <c:if test="${cartCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">${cartCount}</span>
                    </c:if>
                </a>
            </sec:authorize>

            <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-light me-2 rounded-pill px-3">
                <i class="bi bi-person-circle me-1"></i> Profile
            </a>

            <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                <button type="submit" class="btn btn-danger rounded-pill px-4">Logout</button>
            </form>
        </div>
    </div>
</nav>

<div class="container my-5">
    <div class="hero-section shadow-lg mb-5 text-center">
        <h1 class="display-3 fw-bold mb-3">Hello, <sec:authentication property="name"/>!</h1>
        <div class="d-flex justify-content-center align-items-center gap-2">
            <sec:authorize access="hasAnyRole('CUSTOMER', 'ROLE_CUSTOMER')">
                <span class="role-badge bg-info text-dark fw-bold shadow-sm">Buyer Account</span>
            </sec:authorize>
            <sec:authorize access="hasRole('MERCHANT')">
                <span class="role-badge bg-warning text-dark fw-bold shadow-sm">Merchant Partner</span>
            </sec:authorize>
        </div>
        <p class="mt-4 opacity-75 fs-5">Everything you need to manage your shopping and business in one place.</p>
    </div>

    <div class="row g-4">
        <sec:authorize access="hasAnyRole('CUSTOMER', 'ROLE_CUSTOMER')">
            <div class="col-12">
                <div class="card feature-card border-0 shadow-sm p-5 text-center bg-white mb-4">
                    <div class="card-body">
                        <i class="bi bi-shop display-1 text-primary mb-4"></i>
                        <h2 class="fw-bold">Your Shopping Hub</h2>
                        <p class="text-muted mb-4 fs-5">Check your order progress or discover something new today.</p>
                        <div class="d-flex justify-content-center gap-3">
                            <a href="${pageContext.request.contextPath}/customer/browse" class="btn btn-primary btn-lg px-5 py-3 rounded-pill shadow">
                                <i class="bi bi-search me-2"></i>Browse Products
                            </a>
                            <a href="${pageContext.request.contextPath}/customer/orders" class="btn btn-outline-dark btn-lg px-5 py-3 rounded-pill shadow-sm">
                                <i class="bi bi-receipt me-2"></i>My Orders
                            </a>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-8">
                        <div class="card border-0 shadow-sm p-4 bg-white h-100">
                            <h5 class="fw-bold mb-4 text-danger"><i class="bi bi-heart-fill me-2"></i>My Wishlist</h5>
                            <div class="row g-3">
                                <c:forEach var="f" items="${favs}">
                                    <div class="col-lg-3 col-md-4 col-6 text-center">
                                        <a href="${pageContext.request.contextPath}/customer/detail/${f.product.id}" class="text-decoration-none text-dark">
                                            <img src="${f.product.imageUrl}" class="img-fluid rounded-3 shadow-sm mb-2"
                                                 style="height: 120px; width: 100%; object-fit: cover;"
                                                 onerror="this.src='https://via.placeholder.com/150'">
                                            <p class="small fw-bold text-truncate">${f.product.name}</p>
                                        </a>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty favs}">
                                    <div class="col-12 text-center py-4 text-muted bg-light rounded-3">
                                        <p class="small mb-0">Your wishlist is empty.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm p-4 bg-white h-100 text-center">
                            <h5 class="fw-bold mb-4 text-primary"><i class="bi bi-truck me-2"></i>Order Tracking</h5>
                            <div class="p-4 order-shortcut">
                                <i class="bi bi-clock-history display-4 text-muted"></i>
                                <p class="mt-3 text-muted">Want to see where your packages are?</p>
                                <a href="${pageContext.request.contextPath}/customer/orders" class="btn btn-sm btn-primary rounded-pill px-4">
                                    Check Status
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </sec:authorize>

        <sec:authorize access="hasRole('MERCHANT')">
            <div class="col-md-4">
                <div class="card feature-card h-100 shadow-sm border-0 bg-white">
                    <div class="card-body p-4 text-center">
                        <div class="bg-primary bg-opacity-10 p-4 rounded-circle d-inline-block mb-3">
                            <i class="bi bi-plus-lg fs-1 text-primary"></i>
                        </div>
                        <h4 class="fw-bold">New Listing</h4>
                        <p class="text-muted small">Upload new product photos and set prices for the market.</p>
                        <a href="${pageContext.request.contextPath}/merchant/add-product" class="btn btn-primary w-100 mt-2 py-2 rounded-pill">
                            Add Product
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card feature-card h-100 shadow-sm border-0 bg-white">
                    <div class="card-body p-4 text-center">
                        <div class="bg-success bg-opacity-10 p-4 rounded-circle d-inline-block mb-3">
                            <i class="bi bi-box-seam fs-1 text-success"></i>
                        </div>
                        <h4 class="fw-bold">My Inventory</h4>
                        <p class="text-muted small">Update stock levels, edit descriptions, or remove products.</p>
                        <a href="${pageContext.request.contextPath}/merchant/my-products" class="btn btn-success w-100 mt-2 py-2 rounded-pill">
                            Manage Store
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card feature-card h-100 shadow-sm border-0 bg-white">
                    <div class="card-body p-4 text-center">
                        <div class="bg-info bg-opacity-10 p-4 rounded-circle d-inline-block mb-3">
                            <i class="bi bi-graph-up-arrow fs-1 text-info"></i>
                        </div>
                        <h4 class="fw-bold">Sales & Orders</h4>
                        <p class="text-muted small">Track your revenue and see which products are trending.</p>
                        <a href="${pageContext.request.contextPath}/merchant/orders" class="btn btn-info w-100 mt-2 py-2 rounded-pill text-white">
                            View Orders
                        </a>
                    </div>
                </div>
            </div>
        </sec:authorize>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>