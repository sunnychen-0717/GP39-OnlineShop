<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Marketplace - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body { background-color: #f8f9fa; }
    .product-card { border: none; border-radius: 15px; transition: 0.3s; height: 100%; }
    .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
    .img-container { position: relative; height: 200px; overflow: hidden; border-radius: 15px 15px 0 0; }
    .product-img { width: 100%; height: 100%; object-fit: cover; }
    .fav-btn { position: absolute; top: 10px; right: 10px; background: white; border: none; border-radius: 50%; width: 35px; height: 35px; color: #dc3545; z-index: 5; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .search-section { background: white; padding: 25px; border-radius: 15px; margin-bottom: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow">
  <div class="container">
    <a class="navbar-brand fw-bold" href="/customer/index">OnlineShop</a>
    <div class="navbar-nav ms-auto">
      <a class="nav-link" href="/customer/index">Home</a>
      <a class="nav-link fw-bold text-info" href="/customer/cart">
        <i class="bi bi-cart-fill"></i> My Cart
      </a>
    </div>
  </div>
</nav>

<div class="container">
  <div class="search-section">
    <form action="/customer/browse" method="get" class="row g-2">
      <div class="col-md-10">
        <div class="input-group">
          <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
          <input type="text" name="search" class="form-control border-start-0"
                 placeholder="Search products..." value="${searchKeyword}">
        </div>
      </div>
      <div class="col-md-2">
        <button type="submit" class="btn btn-primary w-100 fw-bold">Search</button>
      </div>
    </form>
  </div>

  <div class="row g-4">
    <c:forEach var="p" items="${products}">
      <div class="col-lg-3 col-md-4 col-sm-6">
        <div class="card product-card shadow-sm">
          <div class="img-container">
            <c:set var="isFav" value="false" />
            <c:forEach var="favId" items="${favProductIds}">
              <c:if test="${favId == p.id}"><c:set var="isFav" value="true" /></c:if>
            </c:forEach>
            <button class="fav-btn" onclick="toggleFav(this, ${p.id})">
              <i class="bi ${isFav ? 'bi-heart-fill' : 'bi-heart'}"></i>
            </button>

            <a href="/customer/detail/${p.id}">
              <img src="${p.imageUrl}" class="product-img" onerror="this.src='https://via.placeholder.com/200'">
            </a>
          </div>
          <div class="card-body d-flex flex-column">
            <h6 class="fw-bold text-truncate">${p.name}</h6>
            <p class="text-primary fw-bold mb-3">HK$ ${p.price}</p>
            <button onclick="addToCart(${p.id})" class="btn btn-outline-primary btn-sm mt-auto fw-bold"
              ${p.stock <= 0 ? 'disabled' : ''}>
              <i class="bi bi-cart-plus"></i> Add to Cart
            </button>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script>
  function toggleFav(btn, productId) {
    fetch('/customer/favourite/toggle/' + productId, { method: 'POST' })
            .then(res => res.text())
            .then(status => {
              const icon = btn.querySelector('i');
              icon.classList.toggle('bi-heart');
              icon.classList.toggle('bi-heart-fill');
            });
  }

  function addToCart(productId) {
    fetch('/customer/cart/add/' + productId, { method: 'POST' })
            .then(res => res.text())
            .then(status => {
              if(status === 'SUCCESS') alert('Added to cart!');
            });
  }
</script>
</body>
</html>