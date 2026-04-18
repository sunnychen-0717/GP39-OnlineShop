<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Cart - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container">
    <a class="navbar-brand fw-bold" href="/customer/index">OnlineShop</a>
  </div>
</nav>

<div class="container">
  <h2 class="fw-bold mb-4"><i class="bi bi-cart"></i> Shopping Cart</h2>

  <div class="row">
    <div class="col-md-8">
      <c:forEach var="item" items="${cartItems}">
        <div class="card mb-3 shadow-sm border-0">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-md-2 col-4">
                <img src="${item.product.imageUrl}" class="img-fluid rounded shadow-sm" onerror="this.src='https://via.placeholder.com/100'">
              </div>
              <div class="col-md-5 col-8">
                <h5 class="fw-bold mb-1">${item.product.name}</h5>
                <p class="text-primary mb-0">HK$ ${item.product.price}</p>
              </div>
              <div class="col-md-2 col-6">
                <span class="badge bg-light text-dark border p-2">Qty: ${item.quantity}</span>
              </div>
              <div class="col-md-3 col-6 text-end">
                <p class="fw-bold mb-2">Total: HK$ ${item.product.price * item.quantity}</p>
                <form action="/customer/cart/remove/${item.id}" method="post">
                  <button class="btn btn-sm btn-outline-danger">
                    <i class="bi bi-trash"></i> Remove
                  </button>
                </form>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>

      <c:if test="${empty cartItems}">
        <div class="text-center py-5 bg-white rounded shadow-sm">
          <i class="bi bi-cart-x display-1 text-muted"></i>
          <p class="mt-3 text-muted">Your cart is empty.</p>
          <a href="/customer/browse" class="btn btn-primary px-4">Go Shopping</a>
        </div>
      </c:if>
    </div>

    <div class="col-md-4">
      <div class="card shadow-sm border-0 p-4 sticky-top" style="top: 20px;">
        <h4 class="fw-bold mb-4">Order Summary</h4>
        <div class="d-flex justify-content-between mb-2">
          <span class="text-muted">Subtotal:</span>
          <span>HK$ ${total}</span>
        </div>
        <div class="d-flex justify-content-between mb-4">
          <span class="text-muted">Shipping:</span>
          <span class="text-success">FREE</span>
        </div>
        <hr>
        <div class="d-flex justify-content-between mb-4">
          <span class="fw-bold h5">Total:</span>
          <span class="fw-bold text-primary h4">HK$ ${total}</span>
        </div>

        <a href="/customer/cart/checkout" class="btn btn-success btn-lg w-100 fw-bold ${empty cartItems ? 'disabled' : ''}">
          Proceed to Checkout <i class="bi bi-arrow-right"></i>
        </a>
      </div>
    </div>
  </div>
</div>

</body>
</html>