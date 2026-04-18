<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>List New Product - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f4f7f6; }
    .card { border-radius: 15px; border: none; }
    .preview-img { max-width: 200px; max-height: 200px; display: none; border-radius: 8px; margin-top: 10px; border: 1px solid #ddd; }
  </style>
</head>
<body>
<div class="container mt-5 mb-5">
  <div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
      <div class="card shadow-lg">
        <div class="card-body p-5">
          <h2 class="fw-bold text-center mb-4">List a New Product</h2>

          <form action="/merchant/add-product" method="post" enctype="multipart/form-data">
            <div class="mb-3">
              <label class="form-label fw-bold">Product Name</label>
              <input type="text" name="name" class="form-control" placeholder="e.g. Sony Headphones" required>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Price (HKD)</label>
                <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Stock Quantity</label>
                <input type="number" name="stock" class="form-control" placeholder="0" min="0" required>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">Product Photo</label>
              <input type="file" name="file" id="imageInput" class="form-control" accept="image/*" required>
              <img id="preview" src="#" alt="Preview" class="preview-img">
            </div>

            <div class="mb-4">
              <label class="form-label fw-bold">Description</label>
              <textarea name="description" class="form-control" rows="4"></textarea>
            </div>

            <div class="d-grid gap-2">
              <button type="submit" class="btn btn-primary btn-lg fw-bold">Publish Now</button>
              <a href="/merchant/my-products" class="btn btn-light border text-secondary">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  imageInput.onchange = evt => {
    const [file] = imageInput.files;
    if (file) { preview.src = URL.createObjectURL(file); preview.style.display = 'block'; }
  }
</script>
</body>
</html>