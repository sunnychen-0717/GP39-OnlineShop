<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Merchant Orders - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    .order-card { border-radius: 15px; overflow: hidden; transition: 0.3s; border: none; }
    .order-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
    .customer-info { background-color: #f8f9fa; border-radius: 10px; padding: 15px; border-left: 4px solid #0d6efd; }
    .product-img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; }
    .contact-text { color: #0d6efd; font-weight: 600; }
    .status-select { min-width: 140px; cursor: pointer; }
  </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-5 shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="/index">
      <i class="bi bi-shop me-2"></i>Merchant Dashboard
    </a>
    <a href="/index" class="btn btn-outline-light btn-sm rounded-pill px-3">Back</a>
  </div>
</nav>

<div class="container mb-5">
  <h2 class="fw-bold mb-4"><i class="bi bi-receipt-cutoff me-2 text-primary"></i>Sales Orders Management</h2>

  <c:choose>
    <c:when test="${not empty groupedOrders}">
      <c:forEach var="entry" items="${groupedOrders}">
        <c:set var="order" value="${entry.key}" />
        <c:set var="items" value="${entry.value}" />

        <div class="card order-card shadow-sm mb-4">
          <div class="card-header bg-white border-bottom p-3 d-flex justify-content-between align-items-center">
            <div>
              <span class="text-muted small">ORDER ID</span>
              <h5 class="mb-0 fw-bold text-primary">#${order.id}</h5>
            </div>

            <div class="text-end">
              <form action="${pageContext.request.contextPath}/merchant/order/updateStatus" method="post" class="d-flex align-items-center gap-2">
                <input type="hidden" name="orderId" value="${order.id}">
                <label class="small text-muted d-none d-md-block">Status:</label>
                <select name="newStatus" class="form-select form-select-sm status-select rounded-pill shadow-sm" onchange="this.form.submit()">
                  <option value="PAID" ${order.status == 'PAID' ? 'selected' : ''}>Order Received</option>
                  <option value="SHIPPING" ${order.status == 'SHIPPING' ? 'selected' : ''}>Shipped</option>
                  <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                  <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                </select>
              </form>
              <div class="small text-muted mt-2">
                <i class="bi bi-calendar3 me-1"></i>${order.orderDate}
              </div>
            </div>
          </div>

          <div class="card-body">
            <div class="row">
              <div class="col-md-4 mb-3">
                <div class="customer-info h-100">
                  <h6 class="fw-bold mb-3 text-dark"><i class="bi bi-person-badge me-2"></i>Customer Details</h6>
                  <p class="mb-2"><strong>Name:</strong> ${order.customer.username}</p>

                  <p class="mb-2">
                    <strong>Contact:</strong>
                    <span class="contact-text">
                      <i class="bi bi-chat-dots me-1"></i>
                      <c:out value="${not empty order.contactMethod ? order.contactMethod : 'No contact info'}" />
                    </span>
                  </p>

                  <p class="mb-2"><strong>Address:</strong> ${order.address}</p>
                  <p class="mb-0"><strong>Shipping:</strong> <span class="badge bg-secondary opacity-75">${order.shippingMethod}</span></p>
                </div>
              </div>

              <div class="col-md-8">
                <table class="table table-borderless align-middle">
                  <thead class="text-muted small text-uppercase">
                  <tr>
                    <th>Product Item</th>
                    <th class="text-center">Qty</th>
                    <th class="text-end">Price</th>
                    <th class="text-end">Subtotal</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:set var="merchantSubtotal" value="0" />
                  <c:forEach var="item" items="${items}">
                    <c:set var="merchantSubtotal" value="${merchantSubtotal + (item.priceAtPurchase * item.quantity)}" />
                    <tr>
                      <td>
                        <div class="d-flex align-items-center">
                          <img src="${item.product.imageUrl}" class="product-img me-3 shadow-sm" onerror="this.src='https://via.placeholder.com/60'">
                          <div class="fw-bold text-dark">${item.product.name}</div>
                        </div>
                      </td>
                      <td class="text-center">x${item.quantity}</td>
                      <td class="text-end">HK$${item.priceAtPurchase}</td>
                      <td class="text-end fw-bold text-dark">HK$${item.priceAtPurchase * item.quantity}</td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div class="card-footer bg-light p-3 d-flex justify-content-between align-items-center">
            <div class="text-muted small">
              <i class="bi bi-wallet2 me-1"></i>Payment: <strong>${order.paymentMethod}</strong>
            </div>
            <div class="text-end">
              <span class="me-2 text-muted">Your Earnings:</span>
              <span class="fs-4 fw-bold text-danger">HK$ ${merchantSubtotal}</span>
            </div>
          </div>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div class="text-center py-5 bg-white rounded-4 shadow-sm">
        <i class="bi bi-cart-x display-1 text-muted"></i>
        <h3 class="mt-3 text-muted">No orders found.</h3>
        <p class="text-muted">Once customers buy your products, they will appear here.</p>
        <a href="/index" class="btn btn-primary mt-3 px-4 rounded-pill">Return Dashboard</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<footer class="py-4 mt-auto">
  <div class="container text-center text-muted small">
    &copy; 2026 OnlineShop Merchant Portal
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>