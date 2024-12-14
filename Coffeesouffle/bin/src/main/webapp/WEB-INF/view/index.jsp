<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-Hant-TW">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <!-- 設定網頁 icon -->
    <link rel="icon" href="/img/Logo/cooffee.ico" type="image/">
    <!-- JQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- js -->
    <script src="/js/script.js"></script>
	
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
                            <img src="/img/Logo/coffee_souffle_slide.gif" class="Logo" height="90" alt="">
                            <h1 class="m-0 ms-3" id="h1">Coffee Soufflé</h1>
                        </a>
                        <p class="hello">歡迎回來</p> <!-- member.name -->

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false"
                            aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <nav class="collapse navbar-collapse" id="navbarMenu">

                            <ul class="navbar-nav ms-auto mb-2 mb-md-0 ps-2 ps-md-0">
<!--                               <li class="nav-item ">  -->
<!--                                     <a class="nav-link" id="nav-link" href="/menu">  -->
<!--                                     <img class="me-2" src="/img/coffee-print.png" alt="">菜單</a>   -->
<!--                                  </li>    -->
<!--                                  <li class="nav-item"> -->
<!--                                     <a class="nav-link" id="nav-link" href="/news"> -->
<!--                                     <img class="me-2" src="/img/coffee-print.png" alt="">活動</a> -->
<!--                                 </li>  -->
                                <li class="nav-item">
                                    <a class="nav-link" id="nav-link" href="/order">
                                    <img class="me-2" src="/img/coffee-print.png" alt="">訂餐</a>
                                </li>
                              
                                <li class="nav-item">
                                    <a class="nav-link" id="nav-link" href="/order_backend">
                                    <img class="me-2" src="/img/coffee-print.png" alt="">訂餐紀錄</a>
                                </li>
                            </ul>

                        </nav>

                    </div>
                </nav>

            </div>
        </div>
    </header>
<section id="sec1">
    <div class="container-xl">
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <div class="col">
                <div class="card h-100">
                    <img src="/img/carousel/Original soufflé.jpg" class="card-img-top" alt=" ">
                    <div class="card-body">
                        <h5 class="card-title">Original soufflé</h5>
                        <p class="card-text">經典的原味舒芙蕾，撒上細緻糖粉，搭配濃郁的鮮奶油，呈現最純粹的口感，帶來無與倫比的柔軟與香甜。</p>
                        <a href="/order" class="btn btn-outline-primary">Read More</a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100">
                    <img src="/img/carousel/Matcha soufflé.jpg" class="card-img-top" alt=" ">
                    <div class="card-body">
                        <h5 class="card-title">Matcha soufflé</h5>
                        <p class="card-text">選用香濃日式抹茶醬覆蓋在舒芙蕾上，搭配糯米丸子與蜜柑餡料，口感層次豐富，讓人彷彿置身京都茶園。</p>
                        <a href="/order" class="btn btn-outline-primary">Read More</a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100">
                    <img src="/img/carousel/Fruits soufflé.jpg" class="card-img-top" alt=" ">
                    <div class="card-body">
                        <h5 class="card-title">Fruits soufflé</h5>
                        <p class="card-text">嚴選新鮮草莓、香蕉與藍莓，搭配輕盈的舒芙蕾，佐以濃郁奶油與糖霜，清爽與甜美的結合帶來初戀般的滋味。</p>
                        <a href="/order" class="btn btn-outline-primary">Read More</a>
                    </div>
                </div>
            </div>
             <div class="col">
                <div class="card h-100">
                    <img src="/img/carousel/Citrus Soufflé.jpg" class="card-img-top" alt=" ">
                    <div class="card-body">
                        <h5 class="card-title">Citrus Soufflé</h5>
                        <p class="card-text">嚴選金黃飽滿的茂谷柑，搭配馬斯卡彭鮮奶油、卡士達、優格冰淇淋，淋上蜂蜜達到完美的平衡</p>
                        <a href="/order" class="btn btn-outline-primary">Read More</a>
                    </div>
                </div>
            </div>
               <div class="col">
                <div class="card h-100">
                    <img src="/img/carousel/Mango soufflé.jpg" class="card-img-top" alt=" ">
                    <div class="card-body">
                        <h5 class="card-title">Mango soufflé</h5>
                        <p class="card-text">採用當季金黃熟芒果，鋪滿在鬆軟的舒芙蕾上，搭配濃滑的冰淇淋與鮮奶油，為味蕾注入滿滿的熱帶風情。</p>
                        <a href="/order" class="btn btn-outline-primary">Read More</a>
                    </div>
                </div>
            </div>
              <div class="col">
                <div class="card h-100">
                    <img src="/img/carousel/Nut soufflé.jpg" class="card-img-top" alt=" ">
                    <div class="card-body">
                        <h5 class="card-title">Nut soufflé</h5>
                        <p class="card-text">搭配手工焦糖堅果與濃郁奶油冰淇淋，輕盈的舒芙蕾透著溫暖的焦糖香氣，每一口都是秋日的幸福感。</p>
                        <a href="/order" class="btn btn-outline-primary">Read More</a>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</section>


<!-- <section id="sec3"> -->
<!--     <div class="container-xl"> -->
<!--         <div class="row"> -->
<!--             <div class="col-12"> -->
<!--                 <div class="card-group"> -->
<%--                     <c:forEach items="${newsList}" var="news"> --%>
<!--                         <div class="card"> -->
<%--                             <img src="/img/news/${news.newsImage}" class="card-img-top" alt="${news.newsTitle}"> --%>
<!--                             <div class="card-body"> -->
<%--                                 <h5 class="card-title">${news.newsTitle}</h5> --%>
<%--                                 <p class="card-text">${news.content}</p> --%>
<!--                                 <a href="/news" class="btn btn-outline-primary">Read More</a> -->
<!--                             </div> -->
<!--                         </div> -->
<%--                     </c:forEach> --%>
<!--                 </div> -->
<!--             </div> -->
<!--         </div> -->
<!--     </div> -->

    <!-- footer 區域 頁尾 -->
    <footer>

        <div class="container-xl text-center">
            <div class="row">

                <div class="col-6 col-md-2 pt-1 d-flex flex-column">
                    <h3 class="title" id="title">首頁</h3>
                    <a href="/index">Home</a>
                </div>
<!--                 <div class="col-6 col-md-2 pt-1 d-flex flex-column"> -->
<!--                     <h3 class="title">菜單</h3> -->
<!--                     <a href="/menu">Menu</a> -->
<!--                 </div> -->
              <!--    <div class="col-6 col-md-2 pt-1 d-flex flex-column">
                    <h3 class="title">活動</h3>
                    <a href="/news">News</a>
                </div> -->
                <div class="col-6 col-md-2 pt-1 d-flex flex-column">
                    <h3 class="title">訂餐</h3>
                    <a href="/order">Order</a>
                </div>
               
                <div class="col-6 col-md-2 pt-1 d-flex flex-column">
                    <h3 class="title">夥伴登入</h3>
                    <a href="/member">Member</a>
                </div>

                <div class="col-12 d-flex align-items-center">
                    <img src="/img/Logo/coffee_souffle_slide.gif" class="img-fluid me-3" alt="...">
                    <p class="mb-0">Coffe Souffle</p>
                </div>
            </div>
        </div>

    </footer>
     <h2>掃描 QR Code 進入網站</h2>
    <img id="qrcode" alt="QR Code" />

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const qrCodeImg = document.getElementById("qrcode");
            qrCodeImg.src = "http://localhost:8080/generateQRCode";  // 指向後端生成 QR Code 的路徑
        });
    </script>
	<!-- bootstrap5 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>