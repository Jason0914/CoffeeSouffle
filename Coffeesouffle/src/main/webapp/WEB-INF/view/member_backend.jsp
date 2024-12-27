<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags/form"%>

<%
// 檢查使用者是否已登入且是員工
if (session.getAttribute("member") == null || session.getAttribute("loginStatus") == null
		|| !(boolean) session.getAttribute("loginStatus")) {
	response.sendRedirect("/member");
	return;
}
%>

<!DOCTYPE html>
<html lang="zh-Hant-TW">
<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0">
<meta charset="UTF-8">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link rel="stylesheet" href="/css/style.css">
<link rel="stylesheet" href="/css/member_backend.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
<link rel="icon" href="/img/Logo/cooffee.ico" type="image/">
<title>Coffee Soufflé</title>
</head>

<body>
	<!-- Header -->
	<header>
		<div class="container-xl">
			<div class="row">
				<nav class="navbar navbar-expand-md navbar-light fixed-top">
					<div class="container-xxl p-0">
						<a class="navbar-brand d-flex align-items-center" href="/index">
							<img src="/img/Logo/coffee2.png" class="Logo" height="90" alt="">
							<h1 class="m-0 ms-3" id="h1">員工管理後臺</h1>
						</a>

						<button class="navbar-toggler" type="button"
							data-bs-toggle="collapse" data-bs-target="#navbarMenu">
							<span class="navbar-toggler-icon"></span>
						</button>

						<nav class="collapse navbar-collapse" id="navbarMenu">
							<div class="header-buttons">
								<a href="/index" class="header-btn">首頁</a> <a href="/Charts"
									class="header-btn">財務狀況</a> <a href="/order_backend"
									class="header-btn">訂單管理</a> <a href="/member_backend"
									class="header-btn">員工管理</a> <a href="/logout"
									class="header-btn">登出</a>
							</div>
						</nav>
					</div>
				</nav>
			</div>
		</div>
	</header>

	<!-- Main Content -->
	<section id="sec1">
		<div class="container-xl">
			<div class="row">
				<!-- 新增員工按鈕 -->
				<div class="col-12 mb-4">
					<button type="button" class="btn btn-primary"
						data-bs-toggle="modal" data-bs-target="#addEmployeeModal">
						<i class="fas fa-user-plus me-2"></i>新增員工
					</button>
				</div>

				<!-- 員工列表 -->
				<div id="list-wrapper" class="table-responsive">
					<table id="memberTable"
						class="table table-striped table-hover table-bordered text-center">
						<thead>
							<tr>
								<th>編號<img src="/img/icons/down.svg" alt=""></th>
								<th>帳號<img src="/img/icons/down.svg" alt=""></th>
								<th>姓名<img src="/img/icons/down.svg" alt=""></th>
								<th>性別<img src="/img/icons/down.svg" alt=""></th>
								<th>生日<img src="/img/icons/down.svg" alt=""></th>
								<th>信箱<img src="/img/icons/down.svg" alt=""></th>
								<th>手機號碼<img src="/img/icons/down.svg" alt=""></th>

							</tr>
						</thead>
						<tbody>
							<c:forEach items="${memberList}" var="member">
								<tr>
									<td>${member.memberId}</td>
									<td>${member.account}</td>
									<td>${member.name}</td>
									<td>${member.gender}</td>
									<td><fmt:formatDate value="${member.birthday}"
											pattern="yyyy-MM-dd" /></td>
									<td>${member.email}</td>
									<td>${member.phone}</td>
									<td>
										<!-- 修改按鈕 -->
										<button class="btn btn-outline-primary btn-sm" type="button"
											onclick="window.editMember(${member.memberId})">
											<i class="fas fa-edit"></i> 修改
										</button> <!-- 刪除按鈕 -->
										<button class="btn btn-outline-danger btn-sm" type="button"
											onclick="window.deleteMember(${member.memberId})">
											<i class="fas fa-trash-alt"></i> 刪除
										</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<!-- 在表格下方添加分頁控制區 -->
<div class="d-flex justify-content-center">
    <div id="pagination-container" class="mt-3 mb-3"></div>
</div>
				</div>
			</div>
		</div>
	</section>

	<!-- 新增員工 Modal -->
	<div class="modal fade" id="addEmployeeModal" tabindex="-1"
		aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="addEmployeeModalLabel">新增員工</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="createEmployee"
						action="${pageContext.request.contextPath}/member_backend/"
						method="post">
						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="account">帳號<span class="text-danger">*</span></label>
									<input type="text" class="form-control" id="account"
										name="account" required>
									<div class="invalid-feedback">帳號已存在</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
									<label for="password">密碼<span class="text-danger">*</span></label>
									<input type="password" class="form-control" id="password"
										name="password" required>
								</div>
							</div>
						</div>

						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="name">姓名<span class="text-danger">*</span></label>
									<input type="text" class="form-control" id="name" name="name"
										required>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
									<label>性別<span class="text-danger">*</span></label>
									<div>
										<div class="form-check form-check-inline">
											<input class="form-check-input" type="radio" name="gender"
												id="male" value="男生" checked> <label
												class="form-check-label" for="male">男生</label>
										</div>
										<div class="form-check form-check-inline">
											<input class="form-check-input" type="radio" name="gender"
												id="female" value="女生"> <label
												class="form-check-label" for="female">女生</label>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="birthday">生日<span class="text-danger">*</span></label>
									<input type="date" class="form-control" id="birthday"
										name="birthday" required>
								</div>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="phone">手機號碼<span class="text-danger">*</span></label>
									<input type="tel" class="form-control" id="phone" name="phone"
										pattern="09\d{8}" required>
									<div class="invalid-feedback">手機號碼已存在</div>
								</div>
							</div>
						</div>

						<div class="row mb-3">
							<div class="col-12">
								<div class="form-group">
									<label for="email">電子郵件<span class="text-danger">*</span></label>
									<input type="email" class="form-control" id="email"
										name="email" required>
									<div class="invalid-feedback">電子郵件已存在</div>
								</div>
							</div>
						</div>

						<input type="hidden" name="isMember" value="1">

						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">取消</button>
							<button type="submit" class="btn btn-primary">新增</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改員工 Modal -->
	<div class="modal fade" id="updateEmployeeModal" tabindex="-1"
		aria-labelledby="updateEmployeeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="updateEmployeeModalLabel">修改員工資料</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="updateEmployeeForm" method="POST">
						<input type="hidden" id="updateMemberId" name="memberId">
						<input name="_method" type="hidden" value="PUT">

						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="updateAccount">帳號</label> <input type="text"
										class="form-control" id="updateAccount" name="account"
										readonly>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
									<label for="updatePassword">密碼<span class="text-danger">*</span></label>
									<input type="password" class="form-control" id="updatePassword"
										name="password" required>
								</div>
							</div>
						</div>

						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="updateName">姓名<span class="text-danger">*</span></label>
									<input type="text" class="form-control" id="updateName"
										name="name" required>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
									<label>性別<span class="text-danger">*</span></label>
									<div>
										<div class="form-check form-check-inline">
											<input class="form-check-input" type="radio" name="gender"
												id="updateMale" value="男生"> <label
												class="form-check-label" for="updateMale">男生</label>
										</div>
										<div class="form-check form-check-inline">
											<input class="form-check-input" type="radio" name="gender"
												id="updateFemale" value="女生"> <label
												class="form-check-label" for="updateFemale">女生</label>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="updateBirthday">生日<span class="text-danger">*</span></label>
									<input type="date" class="form-control" id="updateBirthday"
										name="birthday" required>
								</div>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-6">
								<div class="form-group">
									<label for="updatePhone">手機號碼<span class="text-danger">*</span></label>
									<input type="tel" class="form-control" id="updatePhone"
										name="phone" pattern="09\d{8}" required>
								</div>
							</div>
						</div>

						<div class="row mb-3">
							<div class="col-12">
								<div class="form-group">
									<label for="updateEmail">電子郵件<span class="text-danger">*</span></label>
									<input type="email" class="form-control" id="updateEmail"
										name="email" required>
								</div>
							</div>
						</div>

						<input type="hidden" name="isMember" value="1">

						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">取消</button>
							<button type="submit" class="btn btn-primary">儲存修改</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<footer>
		<div
			class="container-xl d-flex justify-content-between align-items-center">
			<!-- Logo 和版權文字 -->
			<div class="footer-logo-text d-flex align-items-center">
				<img src="/img/Logo/coffee2.png" class="footer-logo-img"
					alt="Coffee Soufflé Logo">
				<p class="mb-0 ms-2">© 2024 Coffee Soufflé. All rights reserved.</p>
			</div>
			<div>
				<img class="footer-logo-img-Line" alt="Line"
					src="img/Logo/LINElogo .png"> <img class="footer-logo-img-FB"
					alt="FB" src="img/Logo/FBlogo.png"> <img
					class="footer-logo-img-IG" alt="IG" src="img/Logo/IGlogo.png">
			</div>
		</div>
	</footer>
	<!-- Scripts -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/simplePagination.js/1.6/jquery.simplePagination.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.1/dist/sweetalert2.all.min.js"></script>
	<script src="/js/member_backend.js"></script>
</body>
</html>