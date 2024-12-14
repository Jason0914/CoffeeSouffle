<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>掃描 QR Code 進入網站</title>
</head>
<body>
    <h2>掃描 QR Code 進入網站</h2>
    <img id="qrcode" alt="QR Code" />

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const qrCodeImg = document.getElementById("qrcode");
            qrCodeImg.src = "http://localhost:8080/generateQRCode";  // 指向後端生成 QR Code 的路徑
        });
    </script>
</body>
</html>
