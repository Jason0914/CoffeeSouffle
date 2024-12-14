<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="zh-Hant-TW">
  <head>
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0"
    />
    <meta charset="UTF-8" />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css"
    />
    <link rel="stylesheet" href="/css/style.css" />
    <!-- 設定網頁 icon -->
    <link rel="icon" href="/img/Logo/cooffee.ico" type="image/" />
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
                <img
                  src="/img/Logo/coffee2.png"
                  class="Logo"
                  height="90"
                  alt=""
                />
                <h1 class="m-0 ms-3" id="h1">Coffee Soufflé</h1>
              </a>

              <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarMenu"
                aria-controls="navbarMenu"
                aria-expanded="false"
                aria-label="Toggle navigation"
              >
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
    <section class="products">
      <div class="product-row">
        <!-- 第一項產品 -->
        <div class="product">
          <div class="product-info">
            <h2>Matcha Soufflé</h2>
            <p>香濃日式抹茶醬覆蓋，搭配糯米丸子，讓人彷彿置身京都茶園。</p>
            <a href="/order" class="btn btn-outline-primary">了解詳情</a>
          </div>
          <div class="product-image">
            <img src="/img/carousel/Matcha soufflé.jpg" alt="" />
          </div>
        </div>

        <!-- 第二項產品 -->
        <div class="product">
          <div class="product-image">
            <img src="/img/menu/drinks/焦糖瑪奇朵.jpg" alt="Matcha Soufflé" />
          </div>
          <div class="product-info">
            <h2>Caramel Macchiato</h2>
            <p>
              濃郁奶香覆蓋焦糖醬，濕潤奶泡與咖啡的完美融合，甜而不膩，為心情增添一抹溫暖。
            </p>
            <a href="/order" class="btn btn-outline-primary">了解詳情</a>
          </div>
        </div>

        <!-- 第三項產品 -->
        <div class="product">
          <div class="product-info">
            <h2>Ice Coffee</h2>
            <p>
              純粹的咖啡風味與冰塊交融，清爽不膩口，是咖啡愛好者的經典選擇。
            </p>
            <a href="/order" class="btn btn-outline-primary">了解詳情</a>
          </div>
          <div class="product-image">
            <img src="/img/menu/drinks/美式冰咖啡.jpg" alt="Fruits Soufflé" />
          </div>
        </div>

        <!-- 第四項產品 -->
        <div class="product">
          <div class="product-image">
            <img src="/img/carousel/newchange2.png" alt="" />
          </div>
          <div class="product-info">
            <h2>Original Soufflé</h2>
            <p>經典的原味舒芙蕾，撒上細緻糖粉，搭配濃郁的鮮奶油，柔軟香甜。</p>
            <a href="/order" class="btn btn-outline-primary">了解詳情</a>
          </div>
        </div>
      </div>
    </section>
    <!-- footer 區域 頁尾 -->
    <footer>
      <div
        class="container-xl d-flex justify-content-between align-items-center"
      >
        <!-- Logo 和版權文字 -->
        <div class="footer-logo-text d-flex align-items-center">
          <img
            src="/img/Logo/coffee2.png"
            class="footer-logo-img"
            alt="Coffee Soufflé Logo"
          />
          <p class="mb-0 ms-2">© 2024 Coffee Soufflé. All rights reserved.</p>
        </div>
        <div>
          <img
            class="footer-logo-img-Line"
            alt="Line"
            src="img/Logo/LINElogo .png"
          />
          <img class="footer-logo-img-FB" alt="FB" src="img/Logo/FBlogo.png" />
          <img class="footer-logo-img-IG" alt="IG" src="img/Logo/IGlogo.png" />
        </div>

        <!-- 夥伴登入按鈕 -->
        <a href="/member" class="footer-btn">
          <div>夥伴登入</div>
          <span>Employee</span>
        </a>
      </div>
    </footer>

    <!-- bootstrap5 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
