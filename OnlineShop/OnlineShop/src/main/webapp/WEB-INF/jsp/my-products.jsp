<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Inventory - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold">Inventory Management</h2>
    <div>
      <a href="/index" class="btn btn-outline-secondary me-2">Dashboard</a>
      <a href="/merchant/add-product" class="btn btn-primary fw-bold">+ Add Product</a>
    </div>
  </div>

  <div class="card shadow-sm border-0">
    <table class="table table-hover align-middle mb-0">
      <thead class="table-dark">
      <tr>
        <th class="ps-4">Image</th>
        <th>Name</th>
        <th>Price</th>
        <th>Stock</th>
        <th class="text-center">Actions</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="p" items="${products}">
        <tr>
          <td class="ps-4"><img src="${p.imageUrl}" class="rounded" style="width: 60px; height: 60px; object-fit: cover;"></td>
          <td><strong>${p.name}</strong></td>
          <td class="text-primary fw-bold">$${p.price}</td>
          <td><span class="badge ${p.stock < 10 ? 'bg-danger' : 'bg-success'}">${p.stock}</span></td>
          <td class="text-center">
            <a href="/merchant/edit-product/${p.id}" class="btn btn-sm btn-outline-primary">Edit</a>
            <form action="/merchant/delete-product/${p.id}" method="post" style="display:inline;" onsubmit="return confirm('Delete this?')">
              <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
            </form>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>