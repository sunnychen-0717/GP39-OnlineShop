<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Checkout - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

  <style>
    #map { height: 250px; width: 100%; border-radius: 12px; margin-top: 15px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); display: none; }
    .card-details { display: none; margin-top: 15px; padding: 15px; background: #f8f9fa; border-radius: 8px; }
    .hero-title { font-weight: 800; color: #1e293b; }
    .contact-error { font-size: 0.85rem; color: #dc3545; display: none; }
  </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-light bg-white shadow-sm mb-5">
  <div class="container">
    <a class="navbar-brand fw-bold" href="/customer/cart"><i class="bi bi-arrow-left"></i> Back to Cart</a>
  </div>
</nav>

<div class="container mb-5">
  <div class="row g-5">
    <div class="col-md-5 order-md-last">
      <h4 class="d-flex justify-content-between align-items-center mb-3">
        <span class="text-primary fw-bold">Order Summary</span>
      </h4>
      <ul class="list-group mb-3 shadow-sm rounded-3">
        <c:forEach var="item" items="${cartItems}">
          <li class="list-group-item d-flex justify-content-between lh-sm p-3">
            <div>
              <h6 class="my-0 fw-bold">${item.product.name}</h6>
              <small class="text-muted">Quantity: ${item.quantity}</small>
            </div>
            <span class="text-muted">HKD ${item.product.price * item.quantity}</span>
          </li>
        </c:forEach>
        <li class="list-group-item d-flex justify-content-between bg-light p-3">
          <strong class="fs-5">Total (HKD)</strong>
          <strong class="fs-5 text-success">HKD ${total}</strong>
        </li>
      </ul>
    </div>

    <div class="col-md-7">
      <h2 class="hero-title mb-4">Checkout Details</h2>
      <form action="/customer/cart/placeOrder" method="post" id="checkoutForm" class="needs-validation" novalidate>

        <div class="mb-4">
          <label for="receiverName" class="form-label fw-bold">Receiver Full Name</label>
          <input type="text" class="form-control" id="receiverName" name="receiverName" required placeholder="Enter recipient's name">
        </div>

        <div class="mb-4">
          <label class="form-label fw-bold">Contact Method (Phone or Email)</label>
          <div class="row g-2">
            <div class="col-md-6">
              <div class="input-group">
                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                <input type="tel" class="form-control contact-input" id="phone" placeholder="Phone Number" oninput="validateContact()">
              </div>
            </div>
            <div class="col-md-6">
              <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" class="form-control contact-input" id="email" placeholder="Email Address" oninput="validateContact()">
              </div>
            </div>
          </div>
          <div id="contactError" class="contact-error mt-2">
            <i class="bi bi-exclamation-circle"></i> Please provide at least one contact method.
          </div>
          <input type="hidden" id="contactMethod" name="contactMethod" required>
        </div>

        <div class="mb-4">
          <label for="address" class="form-label fw-bold">Shipping Address</label>
          <div class="input-group">
            <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
            <input type="text" class="form-control" id="address" name="address" required placeholder="Enter street address">
            <button class="btn btn-outline-primary" type="button" onclick="getCurrentLocation()">
              <i class="bi bi-geo-alt-fill"></i> Get GPS
            </button>
          </div>
          <div id="map"></div>
          <div id="locationStatus" class="form-text mt-2"></div>
        </div>

        <div class="mb-4">
          <label class="form-label fw-bold">Payment Method</label>
          <div class="d-flex gap-3">
            <div class="form-check border p-3 rounded w-50">
              <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="payCredit" value="CREDIT_CARD" required onchange="toggleCardDetails()">
              <label class="form-check-label" for="payCredit"><i class="bi bi-credit-card"></i> Credit Card</label>
            </div>
            <div class="form-check border p-3 rounded w-50">
              <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="payCOD" value="COD" onchange="toggleCardDetails()">
              <label class="form-check-label" for="payCOD"><i class="bi bi-truck"></i> Cash on Delivery</label>
            </div>
          </div>

          <div id="cardDetailsBlock" class="card-details shadow-sm">
            <div class="row g-3">
              <div class="col-12">
                <label class="form-label small">Card Number</label>
                <input type="text" class="form-control form-control-sm" placeholder="XXXX XXXX XXXX XXXX">
              </div>
              <div class="col-6">
                <label class="form-label small">Expiry Date</label>
                <input type="text" class="form-control form-control-sm" placeholder="MM/YY">
              </div>
              <div class="col-6">
                <label class="form-label small">CVV</label>
                <input type="password" class="form-control form-control-sm" placeholder="***">
              </div>
            </div>
          </div>
        </div>

        <div class="mb-5">
          <label for="shippingMethod" class="form-label fw-bold">Shipping Method</label>
          <select class="form-select" id="shippingMethod" name="shippingMethod" required>
            <option value="" disabled selected>Select Courier</option>
            <option value="SF_EXPRESS">SF Express (HK$ 30)</option>
            <option value="LOCAL_COURIER">Local Delivery (HK$ 50)</option>
            <option value="PICKUP">Self Pickup (Free)</option>
          </select>
        </div>

        <hr class="my-4">
        <button id="submitBtn" class="w-100 btn btn-dark btn-lg rounded-pill py-3 fw-bold" type="submit">Complete Order</button>
      </form>
    </div>
  </div>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
  // 1. 聯絡方式二選一校驗
  function validateContact() {
    const phone = document.getElementById('phone').value.trim();
    const email = document.getElementById('email').value.trim();
    const contactHidden = document.getElementById('contactMethod');
    const errorMsg = document.getElementById('contactError');
    const submitBtn = document.getElementById('submitBtn');

    if (phone || email) {
      // 整合聯絡資訊：優先順序 Phone > Email
      contactHidden.value = phone ? (email ? phone + " / " + email : phone) : email;
      errorMsg.style.display = 'none';
      submitBtn.disabled = false;
    } else {
      contactHidden.value = "";
      errorMsg.style.display = 'block';
      submitBtn.disabled = true;
    }
  }

  // 2. 支付方式切換
  function toggleCardDetails() {
    const block = document.getElementById('cardDetailsBlock');
    block.style.display = document.getElementById('payCredit').checked ? 'block' : 'none';
  }

  // 3. 地圖與 GPS 邏輯 (修正版)
  let map, marker;
  function getCurrentLocation() {
    const status = document.getElementById('locationStatus');
    const addressInput = document.getElementById('address');
    const mapDiv = document.getElementById('map');

    if (!navigator.geolocation) {
      status.innerText = "GPS not supported.";
      return;
    }

    status.innerHTML = "<div class='spinner-border spinner-border-sm text-primary'></div> Locating...";

    navigator.geolocation.getCurrentPosition((pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;
      mapDiv.style.display = 'block';

      if (!map) {
        map = L.map('map').setView([lat, lng], 16);
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        marker = L.marker([lat, lng]).addTo(map);
      } else {
        map.setView([lat, lng], 16);
        marker.setLatLng([lat, lng]);
      }

      fetch(`https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}`, {
        headers: { 'Accept-Language': 'zh-HK,en' }
      })
              .then(res => res.json())
              .then(data => {
                const resolvedAddress = data.display_name ||
                        (data.address ? (data.address.road || data.address.suburb) : null) ||
                        ("Lat: " + lat.toFixed(4) + ", Lng: " + lng.toFixed(4));

                addressInput.value = resolvedAddress;
                status.innerHTML = "<span class='text-success'><i class='bi bi-check-circle-fill'></i> Location synced!</span>";
                marker.bindPopup(resolvedAddress).openPopup();
              })
              .catch(err => {
                addressInput.value = lat.toFixed(6) + ", " + lng.toFixed(6);
                status.innerHTML = "Coordinates used (Address API busy).";
              });
    }, (err) => {
      status.innerText = "Error: " + err.message;
    }, { enableHighAccuracy: true, timeout: 5000 });
  }

  // 4. Bootstrap 表單驗證
  (function () {
    'use strict'
    var forms = document.querySelectorAll('.needs-validation')
    Array.prototype.slice.call(forms).forEach(function (form) {
      form.addEventListener('submit', function (event) {
        validateContact(); // 提交前最後檢查一次聯絡方式
        if (!form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false)
    })
  })();

  // 初始執行一次驗證
  window.onload = validateContact;
</script>
</body>
</html>