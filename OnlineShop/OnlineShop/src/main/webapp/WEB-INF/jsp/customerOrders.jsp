<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .order-card { border-radius: 15px; border: none; transition: 0.3s; }
        .order-card:hover { box-shadow: 0 10px 25px rgba(0,0,0,0.08); }
        .status-timeline { position: relative; padding: 20px 0; }
        .progress { height: 8px; border-radius: 5px; background-color: #e9ecef; }
        .product-thumb { width: 70px; height: 70px; object-fit: cover; border-radius: 10px; }
        .hero-section { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px 0; border-radius: 0 0 30px 30px; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/customer/index"><i class="bi bi-bag-heart-fill me-2"></i>OnlineShop</a>
        <div class="ms-auto">
            <a href="/customer/index" class="btn btn-outline-light btn-sm rounded-pill px-3">Continue Shopping</a>
        </div>
    </div>
</nav>

<div class="hero-section mb-5 text-center">
    <div class="container">
        <h1 class="fw-bold">My Orders</h1>
        <p class="opacity-75">Track your purchases and delivery status</p>
    </div>
</div>

<div class="container mb-5">
    <c:choose>
        <c:when test="${not empty orders}">
            <c:forEach var="order" items="${orders}">
                <div class="card order-card shadow-sm mb-4">
                    <div class="card-header bg-white p-3 d-flex justify-content-between align-items-center border-bottom-0">
                        <div>
                            <span class="text-muted small">Order Date: ${order.orderDate}</span>
                            <h5 class="mb-0 fw-bold">Order #${order.id}</h5>
                        </div>
                        <div class="text-end">
                            <c:choose>
                                <c:when test="${order.status == 'PAID'}">
                                    <span class="badge bg-primary rounded-pill px-3 py-2"><i class="bi bi-box-seam me-1"></i> Order Received</span>
                                </c:when>
                                <c:when test="${order.status == 'SHIPPING'}">
                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-2"><i class="bi bi-truck me-1"></i> Shipping</span>
                                </c:when>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <span class="badge bg-success rounded-pill px-3 py-2"><i class="bi bi-house-check me-1"></i> Delivered</span>
                                </c:when>
                                <c:when test="${order.status == 'CANCELLED'}">
                                    <span class="badge bg-danger rounded-pill px-3 py-2">Cancelled</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary rounded-pill px-3 py-2">${order.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="card-body py-0">
                        <div class="status-timeline px-3">
                            <c:set var="progressWidth" value="0" />
                            <c:if test="${order.status == 'PAID'}"><c:set var="progressWidth" value="33" /></c:if>
                            <c:if test="${order.status == 'SHIPPING'}"><c:set var="progressWidth" value="66" /></c:if>
                            <c:if test="${order.status == 'DELIVERED'}"><c:set var="progressWidth" value="100" /></c:if>

                            <div class="progress">
                                <div class="progress-bar progress-bar-striped progress-bar-animated ${order.status == 'DELIVERED' ? 'bg-success' : 'bg-primary'}"
                                     role="progressbar" style="width: ${progressWidth}%"></div>
                            </div>
                            <div class="d-flex justify-content-between mt-2 small fw-bold text-muted">
                                <span class="${order.status == 'PAID' || order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'text-primary' : ''}">Confirmed</span>
                                <span class="${order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'text-primary' : ''}">In Transit</span>
                                <span class="${order.status == 'DELIVERED' ? 'text-success' : ''}">Arrived</span>
                            </div>
                        </div>

                        <hr class="my-3 opacity-25">

                        <div class="p-3">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <p class="mb-2 text-muted small"><i class="bi bi-geo-alt-fill me-1"></i> Delivery to: <strong>${order.address}</strong></p>
                                    <p class="mb-0 text-muted small"><i class="bi bi-telephone-fill me-1"></i> Contact: <strong>${order.contactMethod}</strong></p>
                                </div>
                                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                                    <span class="text-muted me-2">Total Amount:</span>
                                    <span class="fs-4 fw-bold text-dark">HKD ${order.totalAmount}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer bg-white p-3 border-top-0">
                        <div class="d-grid d-md-flex justify-content-md-end gap-2">
                            <button class="btn btn-light btn-sm rounded-pill px-4 border">Order Details</button>
                            <c:if test="${order.status == 'DELIVERED'}">
                                <button class="btn btn-dark btn-sm rounded-pill px-4">Buy Again</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <i class="bi bi-bag-x display-1 text-muted"></i>
                <h3 class="mt-4 fw-bold text-secondary">You haven't placed any orders yet.</h3>
                <p class="text-muted">Explore our shop and find something you love!</p>
                <a href="/customer/index" class="btn btn-primary btn-lg rounded-pill px-5 mt-3 shadow">Start Shopping</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer class="text-center py-4 text-muted small">
    &copy; 2026 OnlineShop Inc. All rights reserved.
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>