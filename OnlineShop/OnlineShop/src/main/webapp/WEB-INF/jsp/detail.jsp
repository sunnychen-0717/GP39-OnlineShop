<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${product.name} - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-light bg-white shadow-sm mb-5">
  <div class="container">
    <a class="navbar-brand fw-bold" href="/customer/browse"><i class="bi bi-arrow-left"></i> Back to Shop</a>
  </div>
</nav>

<div class="container">
  <div class="row bg-white p-4 shadow rounded">
    <div class="col-md-6 mb-4">
      <img src="${product.imageUrl}" class="img-fluid rounded shadow-sm w-100" onerror="this.src='https://via.placeholder.com/500'">
    </div>
    <div class="col-md-6 ps-md-5">
      <h1 class="fw-bold mb-3">${product.name}</h1>
      <h2 class="text-primary fw-bold mb-4">HK$ ${product.price}</h2>
      <p class="text-muted mb-4">${product.description}</p>
      <p class="mb-4">Stock: <span class="badge ${product.stock > 0 ? 'bg-success' : 'bg-danger'}">${product.stock}</span></p>

      <div class="d-grid gap-3 d-md-flex align-items-center">
        <input type="number" id="quantity" value="1" min="1" max="${product.stock}" class="form-control" style="width: 80px;">
        <button onclick="addDetailToCart(${product.id})" class="btn btn-primary btn-lg px-5 fw-bold" ${product.stock <= 0 ? 'disabled' : ''}>
          Add to Cart
        </button>

        <button id="favBtn" class="btn ${isFavourite ? 'btn-danger' : 'btn-outline-danger'} btn-lg px-4"
                onclick="toggleDetailFav(${product.id})">
          <i id="favIcon" class="bi ${isFavourite ? 'bi-heart-fill' : 'bi-heart'}"></i>
          <span id="favText">${isFavourite ? ' Remove' : ' Add to Favourite'}</span>
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  function toggleDetailFav(productId) {
    fetch('/customer/favourite/toggle/' + productId, { method: 'POST' })
            .then(res => res.text())
            .then(status => {
              const btn = document.getElementById('favBtn');
              const icon = document.getElementById('favIcon');
              const text = document.getElementById('favText');
              if (status === 'ADDED') {
                btn.classList.replace('btn-outline-danger', 'btn-danger');
                icon.classList.replace('bi-heart', 'bi-heart-fill');
                text.innerText = ' Remove';
              } else {
                btn.classList.replace('btn-danger', 'btn-outline-danger');
                icon.classList.replace('bi-heart-fill', 'bi-heart');
                text.innerText = ' Add to Favourite';
              }
            });
  }

  function addDetailToCart(productId) {
    const qty = document.getElementById('quantity').value;
    fetch('/customer/cart/add/' + productId + '?quantity=' + qty, { method: 'POST' })
            .then(res => res.text())
            .then(status => {
              if(status === 'SUCCESS') alert('Added ' + qty + ' item(s) to cart!');
            });
  }
</script>
</body>
</html>