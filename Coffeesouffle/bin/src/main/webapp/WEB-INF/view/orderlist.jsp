<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!-- Tomcat 10.x JSTL -->
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!-- Spring Form 表單標籤 -->
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags/form" %>

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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
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


 <!-- section1 區域 訂餐資料 -->
    <section id="sec1">
        <div class="container-xl">
            <div class="row">
            <!--      <h2 class="mb-4">訂餐內容</h2>
                <div class="form-group me-auto mb-3">
                    <input type="text" id="searchInput" class="form-control" placeholder="搜尋...">
                </div> -->
                <div id="list-wrapper" class="table-responsive">
                    <table id="orderTable" class="table table-striped table-bordered text-center table-hover">
                        <thead>
                            <tr>
                                <th>訂餐號碼 <img src="/img/icons/down.svg" alt=""></th>
                                <th>桌號 <img src="/img/icons/down.svg" alt=""></th>
                                <!--  
                             	<th>餐點內容 <img src="/img/icons/down.svg" alt=""></th>
                                <th>數量 <img src="/img/icons/down.svg" alt=""></th>
                                <th>金額 <img src="/img/icons/down.svg" alt=""></th>
                                -->
                                <th>訂餐時間 <img src="/img/icons/down.svg" alt=""></th>
                                <th>總金額 <img src="/img/icons/down.svg" alt=""></th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>

                            <!-- 這裡寫迴圈 -->

                            <c:forEach items="${ orderList }" var="order">

                                <tr class="list-item">
                                    <td>${ order.orderId }</td>
                                    <td>${ order.tableNumber }</td>
                                    <!--  
                                    <td>${ order.orderName }</td>
                                    <td>${ order.quantity }</td>
                                    <td>${ order.price }</td>
                                    -->
                                    <td><fmt:formatDate value="${ order.orderTime }" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td>${ order.totalPrice }</td>
           
                                    <td>
                                        <form action="${ pageContext.request.contextPath }/order_backend/${ order.orderId }" id="delete-form" method="POST">
                                            <a href="${ pageContext.request.contextPath }/order_backend/${ order.orderId }" class="btn btn-outline-success details"
                                                data-bs-toggle="modal" data-bs-target="#detailsForm" data-bs-whatever="@mdo" 
                                                data-id="${ order.orderId }" data-table-number="${ order.tableNumber }" data-total-price="${ order.totalPrice }">明細</a>     
                                            <!-- HttpMethod 隱藏欄位 -->
                                            <input name="_method" type="hidden" value="delete" />
                                            <input type="hidden" name="orderId" value="${ order.orderId }" />
                                            <button type="button" class="btn btn-outline-danger deleteButton" id="deleteButton">刪除</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
 
                            <!-- 這裡寫迴圈 -->

                        </tbody>
                    </table>
                    
                    <!-- 分頁 pagination-container -->
                    <div class="container-xl pagination my-3">
                        <div class="row">
                            <div id="pagination-container"></div>
                        </div>
                    </div>
                    <!-- 分頁 pagination-container -->
                    
                </div>
            </div>
        </div>
    </section>


	<!-- 明細表單 -->
    <div class="modal fade" id="detailsForm" tabindex="-1" data-bs-backdrop="static" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="exampleModalLabel"><i class=" "></i> 訂單明細</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    
					<!-- 資料放在js -->

                   
                </div>
            </div>
        </div>
    </div>


</body>
</html>