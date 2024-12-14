<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="zh-Hant-TW">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/order.css">
    <!-- animate.style -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <!-- JQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- SimplePagination -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/simplePagination.js/1.6/jquery.simplePagination.min.js"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- 設定網頁 icon -->
    <link rel="icon" href="/img/Logo/cooffee.ico" type="image/">
    
    <title>訂單查詢</title>
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

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false"
                            aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <nav class="collapse navbar-collapse" id="navbarMenu">
                            <div class="header-buttons d-flex">
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

    <div class="container mt-3">
        <!-- 提示訊息 -->
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <strong>提示：</strong> 這裡只會顯示您在此裝置上的訂單記錄。
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>

        <h1>訂單查詢</h1>
        <div class="mb-4">
            <label for="tableNumber">選擇桌號：</label>
            <select id="tableNumber" class="form-select w-auto d-inline-block">
                <option value="">請選擇桌號</option>
                <option value="1">桌號 1</option>
                <option value="2">桌號 2</option>
                <option value="3">桌號 3</option>
                <option value="4">桌號 4</option>
                <option value="5">桌號 5</option>
            </select>
            <button class="btn btn-primary ms-2" onclick="fetchTableData()">查詢</button>
        </div>

        <!-- 訂單表格 -->
        <table id="orderTable" class="table table-striped">
            <thead>
                <tr>
                    <th>訂單時間</th>
                    <th>桌號</th>
                    <th>總金額</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>

        <!-- 分頁控制 -->
        <div id="pagination-container" class="mt-3"></div>

        <!-- 訂單明細模態框 -->
        <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="orderDetailsModalLabel">訂單明細</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>餐點名稱</th>
                                    <th>數量</th>
                                    <th>單價</th>
                                    <th>小計</th>
                                </tr>
                            </thead>
                            <tbody id="orderDetailsTableBody"></tbody>
                        </table>
                        <div class="text-end">
                            <strong>總金額：</strong><span id="detailTotalPrice"></span>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">關閉</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- footer 區域 頁尾 -->
    <footer>
        <div class="container-xl d-flex justify-content-between align-items-center">
            <!-- Logo 和版權文字 -->
            <div class="footer-logo-text d-flex align-items-center">
                <img src="/img/Logo/coffee2.png" class="footer-logo-img" alt="Coffee Soufflé Logo">
                <p class="mb-0 ms-2">© 2024 Coffee Soufflé. All rights reserved.</p>
            </div>
            
            <!-- 社群媒體圖標 -->
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

    <!-- JavaScript -->
    <script src="/js/order.js"></script>
</body>
</html>
