<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!-- Tomcat 10.x JSTL -->
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!-- Spring Form 表單標籤 -->
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="zh-Hant-TW">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/order_backend.css">
    <!-- animate.style -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <!-- JQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- SimplePagination -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/simplePagination.js/1.6/jquery.simplePagination.min.js"></script>
    <!-- js -->
    <script src="/js/script.js"></script>
    <script src="/js/order_backend.js"></script>
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
                            <h1 class="m-0 ms-3" id="h1">訂單管理後臺</h1>
                        </a>

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#navbarMenu" aria-controls="navbarMenu" 
                                aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <nav class="collapse navbar-collapse" id="navbarMenu">
                            <div class="header-buttons">
                                <a class="header-btn" href="/index">首頁</a>
                                <a href="/Charts" class="header-btn">財務狀況</a>
                                <a class="header-btn" href="/order_backend">訂單管理</a>
                                <a class="header-btn" href="/member_backend">員工管理</a>
                                <a class="header-btn" href="/logout">登出</a>
                            </div>
                        </nav>
                    </div>
                </nav>
            </div>
        </div>
    </header>

    <!-- section1 區域 訂餐資料 -->
    <section id="sec1">
        <div class="container-xl">
            <div class="row">
                <div id="list-wrapper" class="table-responsive">
                    <table id="orderTable" class="table table-striped table-bordered text-center table-hover">
                        <thead>
                            <tr>
                                <th>訂餐號碼 <img src="/img/icons/down.svg" alt=""></th>
                                <th>桌號 <img src="/img/icons/down.svg" alt=""></th>
                                <th>訂餐時間 <img src="/img/icons/down.svg" alt=""></th>
                                <th>總金額 <img src="/img/icons/down.svg" alt=""></th>
                            
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderList}" var="order">
                                <tr class="list-item">
                                    <td>${order.orderId}</td>
                                    <td>${order.tableNumber}</td>
                                    <td class="order-time" data-time="${order.orderTime}">
                                        ${order.orderTime}
                                    </td>
                                    <td>${order.totalPrice}</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/order_backend/${order.orderId}"
                                              id="delete-form" method="POST">
                                            <a href="${pageContext.request.contextPath}/order_backend/${order.orderId}"
                                               class="btn btn-outline-success details"
                                               data-bs-toggle="modal"
                                               data-bs-target="#detailsForm"
                                               data-bs-whatever="@mdo"
                                               data-id="${order.orderId}"
                                               data-table-number="${order.tableNumber}"
                                               data-total-price="${order.totalPrice}">明細</a>
                                            <!-- HttpMethod 隱藏欄位 -->
                                            <input name="_method" type="hidden" value="delete"/>
                                            <input type="hidden" name="orderId" value="${order.orderId}"/>
<!--                                             <button type="button" class="btn btn-outline-danger deleteButton" id="deleteButton">刪除</button> -->
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- 分頁 pagination-container -->
<div class="d-flex justify-content-center">
    <div id="pagination-container" class="mt-3 mb-3"></div>
</div>
                </div>
            </div>
        </div>
    </section>

    <!-- 明細表單 -->
    <div class="modal fade" id="detailsForm" tabindex="-1" data-bs-backdrop="static" 
         aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="exampleModalLabel">
                        <i class=""></i> 訂單明細
                    </h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- 資料放在js -->
                </div>
            </div>
        </div>
    </div>

    <!-- 圖表區域 -->
    <section id="sec2" class="mb-5">
        <div class="container-xl">
            <div class="row justify-content-center">
                <%@ include file="order_charts.jspf"%>
                <div class="col-12 col-md-6">
                    <div id="top_five_chart" style="width: 700px; height: 500px;"></div>
                </div>
                <div class="col-12 col-md-6">
                    <div id="bottom_five_chart" style="width: 700px; height: 500px;"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- footer 區域 頁尾 -->
    <footer>
        <div class="container-xl d-flex justify-content-between align-items-center">
            <div class="footer-logo-text d-flex align-items-center">
                <img src="/img/Logo/coffee2.png" class="footer-logo-img" alt="Coffee Soufflé Logo">
                <p class="mb-0 ms-2">© 2024 Coffee Soufflé. All rights reserved.</p>
            </div>
            <div>
                <img class="footer-logo-img-Line" alt="Line" src="img/Logo/LINElogo .png">
                <img class="footer-logo-img-FB" alt="FB" src="img/Logo/FBlogo.png">
                <img class="footer-logo-img-IG" alt="IG" src="img/Logo/IGlogo.png">
            </div>
        </div>
    </footer>

    <!-- bootstrap5 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- sweetalert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.1/dist/sweetalert2.all.min.js"></script>

 <script>
document.addEventListener('DOMContentLoaded', function() {
    const timeElements = document.querySelectorAll('.order-time');
    timeElements.forEach(element => {
        const timestamp = element.getAttribute('data-time');
        // 創建一個新的 Date 對象並調整時區
        const date = new Date(timestamp);
        // 加入 8 小時以調整為台灣時區
        const taiwanTime = new Date(date.getTime() + (8 * 60 * 60 * 1000));
        element.textContent = taiwanTime.toLocaleString("zh-TW", { 
            timeZone: 'Asia/Taipei',
            hour12: false,
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
    });
});
</script>
</body>
</html>