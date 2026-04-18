<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Profile - OnlineShop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <c:if test="${param.success == 'updated'}">
        <div class="alert alert-success">Profile updated successfully!</div>
      </c:if>

      <div class="card shadow">
        <div class="card-body p-4">
          <h3 class="fw-bold mb-4">My Profile</h3>
          <form action="/profile/update" method="post">

            <div class="mb-3">
              <label class="form-label text-muted">Username (Cannot be changed)</label>
              <input type="text" class="form-control bg-light" value="${user.username}" readonly>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">First Name</label>
                <input type="text" name="firstName" class="form-control" value="${user.firstName}" required>
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label">Last Name</label>
                <input type="text" name="lastName" class="form-control" value="${user.lastName}" required>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Email Address</label>
              <input type="email" name="email" class="form-control" value="${user.email}" required>
            </div>

            <hr>
            <div class="mb-4">
              <label class="form-label fw-bold text-danger">New Password</label>
              <input type="password" name="newPassword" class="form-control" placeholder="Leave blank to keep current password">
            </div>

            <div class="d-grid gap-2">
              <button type="submit" class="btn btn-primary btn-lg">Save Changes</button>
              <a href="/index" class="btn btn-outline-secondary">Back to Dashboard</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>