<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-Hant-TW">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="/css/member.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.1/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="icon" href="/img/Logo/cooffee.ico" type="image/">
    <title>員工登入 - Coffee Soufflé</title>
</head>

<body>
    <div class="left-section">
        <div>
            <h1>Coffee Soufflé</h1>
            <h3>品牌故事</h3>
            <p>在 Coffee Soufflé，我們相信每一刻都值得細細品味。懷著對濃郁芳香的咖啡和輕盈蓬鬆的舒芙蕾的熱愛，我們創立了這個品牌，致力於為顧客打造難忘的味覺體驗。</p>
        </div>
    </div>

    <section id="sec2">
        <div class="container-xl">
            <div class="row">
                <div class="col-12 member mb-5">
                    <!-- 登入表單 -->
                    <div class="login mx-auto animate__animated animate__zoomIn">
                        <form id="loginForm">
                            <fieldset>
                                <h2><i class=""></i>員工登入</h2>
                                <label for="account">帳號</label>
                                <div class="input-group mb-3">
                                    <div class="input-group-text icon">
                                        <i class="fa fa-user"></i>
                                    </div>
                                    <input type="text" class="form-control account" id="loginAccount" name="loginAccount" placeholder="請輸入帳號">
                                </div>
                                
                                <label for="password">密碼</label>
                                <div class="input-group mb-3">
                                    <div class="input-group-text icon">
                                        <i class="fa fa-lock"></i>
                                    </div>
                                    <div class="password-eye">
                                        <input type="password" class="form-control password login-password" id="loginPassword" name="loginPassword" placeholder="請輸入密碼">
                                        <div class="password-eye-append">
                                            <span class="passwordToggle" id="passwordToggle">
                                                <i class="fa fa-eye d-none"></i>
                                                <i class="fa fa-eye-slash"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- 驗證碼 -->
                                <div class="form-group">
                                    <div class="mb-2">
                                        <canvas id="mycanvas" width='150' height='40'></canvas>
                                        <a id="linkbt" class="">看不清換一張</a>
                                    </div>
                                    <div>
                                        <input id="myvad" class="form-control mb-3" type="text" name="vad" placeholder="請輸入驗證碼">
                                    </div>
                                </div>

                                <p><a href="#" id="toForget">忘記密碼？</a></p>
                                <button type="button" id="loginButton" class="btn btn-primary d-flex mx-auto">登入</button>
                            </fieldset>
                        </form>
                    </div>

                    <!-- 忘記密碼表單 -->
                    <div class="forget mx-auto d-none animate__animated animate__zoomIn">
                        <!-- 原有的忘記密碼表單內容保持不變 -->
                    </div>

                    <!-- Modal -->
                    <div class="modal fade" id="changePassword" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
                        <!-- 原有的修改密碼 Modal 內容保持不變 -->
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/member.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.1/dist/sweetalert2.all.min.js"></script>
</body>
</html>