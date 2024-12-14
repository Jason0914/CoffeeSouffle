<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<!-- Tomcat 10.x JSTL -->
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!-- Spring Form 表單標籤 -->
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="zh-Hant-TW">

<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0">
<meta charset="UTF-8">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="/css/style.css">
<link rel="stylesheet" href="/css/order.css">
<!-- animate.style -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- SimplePagination -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/simplePagination.js/1.6/jquery.simplePagination.min.js"></script>
<!-- js -->
<script src="/js/order.js"></script>
<!-- sweetalert2 -->
<link
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.1/dist/sweetalert2.min.css"
	rel="stylesheet">

<!-- 設定網頁 icon -->
<link rel="icon" href="/img/Logo/cooffee.ico" type="image/">

<title>Coffee Soufflé</title>
</head>

<body>
	<!-- header 區域 頁首-->
	<header>
		<div class="container-xl">
			<div class="row">

				<nav class="navbar navbar-expand-md navbar-light fixed-top">
					<div class="container-xxl p-0">

						<a class="navbar-brand d-flex align-items-center" href="./index">
							<img src="/img/Logo/coffee2.png" class="Logo" height="90" alt="">
							<h1 class="m-0 ms-3" id="h1">Coffee Soufflé</h1>
						</a>

						<p class="hello"></p>

						<button class="navbar-toggler" type="button"
							data-bs-toggle="collapse" data-bs-target="#navbarMenu"
							aria-controls="navbarMenu" aria-expanded="false"
							aria-label="Toggle navigation">
							<span class="navbar-toggler-icon"></span>
						</button>
						<nav class="collapse navbar-collapse" id="navbarMenu">
							<div class="header-buttons ms-auto">
							<a href="/index" class="header-btn">首頁</a>   
								<a href="/order" class="header-btn">訂餐</a> 
								<a href="/cart" class="header-btn">購物車</a> 
								<a href="/table" class="header-btn">訂餐紀錄</a>
							</div>
						</nav>


					</div>
				</nav>

			</div>
		</div>
	</header>

	
<main>	
<section>
    <div class="container">
    			
<!--         桌號選擇 -->
        <div class="d-flex align-items-center mb-4">
            <label for="tableNumber" class="me-3 fw-bold">請選擇桌號：</label>
            <select id="tableNumber" name="tableNumber" class="form-select w-25 me-auto" required>
                <option selected disabled>請選擇桌號</option>
                <option value="1">1號桌</option>
                <option value="2">2號桌</option>
                <option value="3">3號桌</option>
                <option value="4">4號桌</option>
                <option value="5">5號桌</option>
            </select>
        </div>

<!--         購物車表單 -->
        <form id="createOrder" action="${pageContext.request.contextPath}/order_backend/" method="post" enctype="multipart/form-data">
            <fieldset>
<!--                 HttpMethod 隱藏欄位 -->
                <input name="_method" type="hidden" value="${_method}" />

<!--                 購物車項目 -->
                <table class="table w-100 cart-table">
                    <thead>
                        <tr>
                            <th class="text-center">餐點名稱</th>
                            <th class="text-center">單價</th>
                            <th class="text-center">數量</th>
                            <th class="text-center">小計</th>
                            <th class="text-center"></th>
                        </tr>
                    </thead>
                    <tbody id="cart-items">
<!--                         購物車項目將由 JavaScript 動態生成 -->
                    </tbody>
                </table>

               
                <div class="d-flex justify-content-between align-items-center mt-4">
                    <h2 id="total-amount" class="fw-bold">總金額：$0</h2>
                    <button type="submit" class="btn btn-outline-success" id="submit-order">送 出</button>
                </div>
            </fieldset>
        </form>
    </div>
</section>
</main>
	   <!-- footer 區域 頁尾 -->
   <footer>
    <div class="container-xl d-flex justify-content-between align-items-center">
        <!-- Logo 和版權文字 -->
        <div class="footer-logo-text d-flex align-items-center">
            <img src="/img/Logo/coffee2.png" class="footer-logo-img" alt="Coffee Soufflé Logo">
            <p class="mb-0 ms-2">© 2024 Coffee Soufflé. All rights reserved.</p>
        </div>
        
       	<div>
			
			<img class="footer-logo-img-Line" alt="Line" src="img/Logo/LINElogo .png">
			<img class="footer-logo-img-FB" alt="FB" src="img/Logo/FBlogo.png">
			<img class="footer-logo-img-IG" alt="IG" src="img/Logo/IGlogo.png">
			
			</div>
        
        

        <!-- 夥伴登入按鈕 -->
        <a href="/member" class="footer-btn">
            <div>夥伴登入</div>
            <span>Employee</span>
        </a>
    </div>
</footer>
	<!-- bootstrap5 -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- sweetalert2 -->
	<script
		src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.1/dist/sweetalert2.all.min.js"></script>
</body>
</html>