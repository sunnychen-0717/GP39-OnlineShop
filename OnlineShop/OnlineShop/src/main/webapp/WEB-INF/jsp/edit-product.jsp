<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Product - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-7">
      <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body p-5">
          <h2 class="fw-bold text-center mb-4">Edit Product</h2>
          <form action="/merchant/edit-product" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${product.id}">

            <div class="mb-3">
              <label class="form-label fw-bold">Product Name</label>
              <input type="text" name="name" class="form-control" value="${product.name}" required>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Price (HKD)</label>
                <input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required>
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Stock</label>
                <input type="number" name="stock" class="form-control" value="${product.stock}" min="0" required>
              </div>
            </div>

            <div class="mb-3 text-center">
              <label class="form-label d-block text-start fw-bold">Update Photo</label>
              <img src="${product.imageUrl}" class="mb-2 rounded shadow-sm" style="width: 120px; height: 120px; object-fit: cover;">
              <input type="file" name="file" class="form-control" accept="image/*">
              <small class="text-muted">Leave empty to keep current image.</small>
            </div>

            <div class="mb-4">
              <label class="form-label fw-bold">Description</label>
              <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
            </div>

            <div class="d-grid gap-2">
              <button type="submit" class="btn btn-success btn-lg fw-bold">Save Changes</button>
              <a href="/merchant/my-products" class="btn btn-light border">Back</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>