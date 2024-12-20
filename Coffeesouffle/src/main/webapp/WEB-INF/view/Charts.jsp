<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=3.0">
    
    <!-- CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/Charts.css">

    <!-- Icon -->
    <link rel="icon" href="${pageContext.request.contextPath}/img/Logo/cooffee.ico" type="image/">
    
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
                            <img src="${pageContext.request.contextPath}/img/Logo/coffee2.png" class="Logo" height="90" alt="Logo">
                            <h1 class="m-0 ms-3" id="h1">財務狀況後臺</h1>
                        </a>

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <nav class="collapse navbar-collapse" id="navbarMenu">
                            <div class="header-buttons">
                                <a href="/index" class="header-btn">首頁</a>
                                <a href="/Charts" class="header-btn">財務狀況</a>
                                <a href="/order_backend" class="header-btn">訂單管理</a>
                                <a href="/member_backend" class="header-btn">員工管理</a>
                                <a href="/logout" class="header-btn">登出</a>
                            </div>
                        </nav>
                    </div>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main>
        <div class="dashboard-container">
            <!-- 銷售排行圖表 -->
            <div class="chart-box">
                <h2>銷售排名</h2>
                <canvas id="salesRankingChart"></canvas>
            </div>

            <!-- 營業計量表 -->
            <div class="table-container">
                <h2>營業計量表</h2>
                <table>
                    <thead>
                        <tr>
                            <th>項目</th>
                            <th>金額</th>
                            <th>輸入金額</th>
                        </tr>
                    </thead>
                    <tbody id="table-body">
                        <tr>
                            <td>營業收入</td>
                            <td id="income-amount">0</td>
                            <td>
                                <input type="number" id="income-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>原物料成本</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>房租</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>水電瓦斯</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>薪資</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>勞健保</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>電信費</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>稅（每月）</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>雜項支出</td>
                            <td class="expense-amount">0</td>
                            <td>
                                <input type="number" class="expense-input" value="0" oninput="updateAll()">
                            </td>
                        </tr>
                        <tr>
                            <td>淨利</td>
                            <td id="net-profit">0</td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
                
                <div class="month-selector">
                    <label for="month-select">選擇月份：</label>
                    <select id="month-select">
                        <option value="1">一月</option>
                        <option value="2">二月</option>
                        <option value="3">三月</option>
                        <option value="4">四月</option>
                        <option value="5">五月</option>
                        <option value="6">六月</option>
                        <option value="7">七月</option>
                        <option value="8">八月</option>
                        <option value="9">九月</option>
                        <option value="10">十月</option>
                        <option value="11">十一月</option>
                        <option value="12">十二月</option>
                    </select>
                    <button onclick="saveData()" class="save-btn">保存到資料庫</button>
                </div>
            </div>
<div class="report-container">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>財務狀況統整</h2>
        <button onclick="clearFinancialData()" class="btn btn-danger">清空所有財務數據</button>
    </div>
    <div id="reportContent"></div>
</div>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <div class="container-xl d-flex justify-content-between align-items-center">
            <div class="footer-logo-text d-flex align-items-center">
                <img src="${pageContext.request.contextPath}/img/Logo/coffee2.png" class="footer-logo-img" alt="Logo">
                <p class="mb-0 ms-2">© 2024 Coffee Soufflé. All rights reserved.</p>
            </div>
            
            <div>
                <img class="footer-logo-img-Line" alt="Line" src="${pageContext.request.contextPath}/img/Logo/LINElogo .png">
                <img class="footer-logo-img-FB" alt="FB" src="${pageContext.request.contextPath}/img/Logo/FBlogo.png">
                <img class="footer-logo-img-IG" alt="IG" src="${pageContext.request.contextPath}/img/Logo/IGlogo.png">
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.1/dist/sweetalert2.all.min.js"></script>
    
    <script>
    async function clearFinancialData() {
        try {
            const response = await fetch('/api/analysis/clear-financial-data', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            if (result.error) {
                Swal.fire({
                    icon: 'error',
                    title: '清空失敗',
                    text: result.error
                });
            } else {
                Swal.fire({
                    icon: 'success',
                    title: '清空成功',
                    text: result.message
                }).then(() => {
                    // 重新加載數據
                    fetchAndDisplayReport();
                    // 重置所有輸入框
                    document.querySelectorAll('input[type="number"]').forEach(input => {
                        input.value = '0';
                    });
                    updateAll();
                });
            }
        } catch (error) {
            console.error("清空失敗：", error);
            Swal.fire({
                icon: 'error',
                title: '清空失敗',
                text: error.message || '請檢查控制台日誌'
            });
        }
    }

    // 确保月份选择器正确初始化
    document.addEventListener('DOMContentLoaded', function() {
        const deleteMonthSelect = document.getElementById('delete-month-select');
        if (deleteMonthSelect) {
            console.log('Month selector found:', deleteMonthSelect.value); // 添加日誌
        } else {
            console.error('Month selector not found!'); // 添加錯誤日誌
        }
    });


        async function fetchAndDisplayReport() {
            try {
                const response = await fetch("/api/analysis/ai-report");
                const result = await response.json();

                if (result.error) {
                    document.getElementById("reportContent").innerHTML = `<p>${result.error}</p>`;
                } else {
                    document.getElementById("reportContent").innerHTML = result.report.replace(/\n/g, "<br>");
                }
            } catch (error) {
                console.error("無法載入報告：", error);
                document.getElementById("reportContent").innerHTML = "<p>無法載入報告，請稍後再試。</p>";
            }
        }

        function updateAll() {
            const incomeInput = document.getElementById("income-input");
            const incomeAmount = document.getElementById("income-amount");
            const expenseInputs = document.querySelectorAll(".expense-input");
            const expenseAmounts = document.querySelectorAll(".expense-amount");

            // 更新營業收入金額
            const income = parseFloat(incomeInput.value) || 0;
            incomeAmount.textContent = income;

            // 計算支出金額
            let totalExpenses = 0;
            expenseInputs.forEach((input, index) => {
                const amount = parseFloat(input.value) || 0;
                totalExpenses += amount;
                expenseAmounts[index].textContent = amount;
            });

            // 計算淨利
            const netProfit = income - totalExpenses;
            document.getElementById("net-profit").textContent = netProfit;
        }

        async function saveData() {
            const month = document.getElementById('month-select').value;
            const income = parseFloat(document.getElementById("income-input").value) || 0;
            const expenseInputs = document.querySelectorAll(".expense-input");
            const expenseItems = document.querySelectorAll(".expense-amount");

            const data = [];
            data.push({ itemName: "營業收入", amount: income });

            let totalExpenses = 0;
            expenseInputs.forEach((input, index) => {
                const itemName = input.closest('tr').cells[0].textContent;
                const amount = parseFloat(input.value) || 0;
                totalExpenses += amount;
                data.push({ itemName, amount });
            });

            const netProfit = income - totalExpenses;
            data.push({ itemName: "淨利", amount: netProfit });

            try {
                const response = await fetch("/api/analysis/save-financial-data", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ month, data }),
                });
                const result = await response.json();
                
                Swal.fire({
                    icon: result.error ? 'error' : 'success',
                    title: result.error ? '保存失敗' : '保存成功',
                    text: result.message
                }).then(() => {
                    if (!result.error) {
                        fetchAndDisplayReport();
                    }
                });
            } catch (error) {
                console.error("保存失敗：", error);
                Swal.fire({
                    icon: 'error',
                    title: '保存失敗',
                    text: '請檢查控制台日誌'
                });
            }
        }
        async function fetchSalesData() {
            try {
                console.log('開始獲取銷售數據');
                const rankingResponse = await fetch("/api/analysis/sales-ranking");
                if (!rankingResponse.ok) {
                    throw new Error(`HTTP error! status: ${rankingResponse.status}`);
                }
                const salesRanking = await rankingResponse.json();
                console.log('銷售數據:', salesRanking);

                if (salesRanking && salesRanking.length > 0) {
                    const rankingLabels = salesRanking.map((item) => item.product_name);
                    const rankingValues = salesRanking.map((item) => item.total_sales);
                    
                    const ctx = document.getElementById("salesRankingChart").getContext('2d');
                    new Chart(ctx, {
                        type: "bar",
                        data: {
                            labels: rankingLabels,
                            datasets: [{
                                label: "銷售額 (元)",
                                data: rankingValues,
                                backgroundColor: "rgba(75, 192, 192, 0.6)",
                                borderColor: "rgba(75, 192, 192, 1)",
                                borderWidth: 1,
                            }],
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    title: { display: true, text: "銷售額 (元)" }
                                }
                            },
                            plugins: {
                                legend: {
                                    display: true,
                                    position: 'top'
                                }
                            }
                        }
                    });
                } else {
                    console.log('沒有銷售數據');
                }
            } catch (error) {
                console.error("無法取得數據：", error);
            }
        }

        // 頁面載入時初始化
        document.addEventListener("DOMContentLoaded", () => {
            fetchSalesData();
            fetchAndDisplayReport();
            updateAll();
        });
    </script>
</body>
</html>