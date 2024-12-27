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
    <div>
        <button onclick="clearFinancialData()" class="btn btn-danger me-2">清空所有財務數據</button>
        <button onclick="exportToPDF()" class="btn btn-primary">匯出 PDF 報表</button>
    </div>
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

    // 月份變更事件處理
    document.getElementById('month-select').addEventListener('change', function() {
        // 保存選擇的月份到 localStorage
        localStorage.setItem('selectedMonth', this.value);
        loadLatestData();
    });

    async function exportToPDF() {
        try {
            const response = await fetch('/api/analysis/export-pdf', {
                method: 'GET',
                headers: {
                    'Accept': 'application/pdf'
                }
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const blob = await response.blob();
            const downloadUrl = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = downloadUrl;
            a.download = 'financial_report.pdf';
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(downloadUrl);
            
            Swal.fire({
                icon: 'success',
                title: 'PDF 匯出成功',
                showConfirmButton: false,
                timer: 1500
            });
        } catch (error) {
            console.error('匯出失敗:', error);
            Swal.fire({
                icon: 'error',
                title: '匯出失敗',
                text: '請稍後再試'
            });
        }
    }

    async function clearFinancialData() {
        try {
            const result = await Swal.fire({
                title: '確定要清空所有數據嗎？',
                text: "此操作無法復原！",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: '是的，清空！',
                cancelButtonText: '取消'
            });

            if (result.isConfirmed) {
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
                    throw new Error(result.error);
                }

                // 清空 localStorage 中的月份選擇
                localStorage.removeItem('selectedMonth');
                
                // 重置表單
                document.querySelectorAll('input[type="number"]').forEach(input => {
                    input.value = '0';
                });
                updateAll();
                
                // 清空報告內容
                document.getElementById("reportContent").innerHTML = "";
                
                await Swal.fire({
                    icon: 'success',
                    title: '清空成功',
                    text: result.message,
                    showConfirmButton: false,
                    timer: 1500
                });
                
                await fetchAndDisplayReport();
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

    async function fetchAndDisplayReport() {
        try {
            const response = await fetch("/api/analysis/ai-report");
            const result = await response.json();

            const reportContent = document.getElementById("reportContent");
            if (result.error) {
                reportContent.innerHTML = `<p class="text-danger">${result.error}</p>`;
            } else if (result.report) {
                reportContent.innerHTML = result.report.replace(/\n/g, "<br>");
            } else {
                reportContent.innerHTML = "<p>無財務數據</p>";
            }
        } catch (error) {
            console.error("無法載入報告：", error);
            document.getElementById("reportContent").innerHTML = "<p class='text-danger'>無法載入報告，請稍後再試。</p>";
        }
    }

    function updateAll() {
        const incomeInput = document.getElementById("income-input");
        const incomeAmount = document.getElementById("income-amount");
        const expenseInputs = document.querySelectorAll(".expense-input");
        const expenseAmounts = document.querySelectorAll(".expense-amount");

        const income = parseFloat(incomeInput.value) || 0;
        incomeAmount.textContent = income.toLocaleString('en-US');

        let totalExpenses = 0;
        expenseInputs.forEach((input, index) => {
            const amount = parseFloat(input.value) || 0;
            totalExpenses += amount;
            expenseAmounts[index].textContent = amount.toLocaleString('en-US');
        });

        const netProfit = income - totalExpenses;
        document.getElementById("net-profit").textContent = netProfit.toLocaleString('en-US');
    }

    async function saveData() {
    	   const month = document.getElementById('month-select').value;
    	   // 保存當前選擇的月份和數據到localStorage
    	   localStorage.setItem('selectedMonth', month);
    	   
    	   // 獲取表單數據
    	   const income = parseFloat(document.getElementById("income-input").value) || 0;
    	   const expenseInputs = document.querySelectorAll(".expense-input");
    	   
    	   const data = [];
    	   const localData = {};
    	   
    	   // 保存營業收入
    	   data.push({ itemName: "營業收入", amount: income });
    	   localData["營業收入"] = income;

    	   // 計算總支出並保存每項支出
    	   let totalExpenses = 0;
    	   expenseInputs.forEach(input => {
    	       const itemName = input.closest('tr').cells[0].textContent;
    	       const amount = parseFloat(input.value) || 0;
    	       totalExpenses += amount;
    	       data.push({ itemName, amount });
    	       localData[itemName] = amount;
    	   });

    	   // 計算並保存淨利
    	   const netProfit = income - totalExpenses;
    	   data.push({ itemName: "淨利", amount: netProfit });
    	   localData["淨利"] = netProfit;

    	   // 保存到 localStorage
    	   localStorage.setItem(`financialData_${month}`, JSON.stringify(localData));

    	   try {
    	       // 保存到資料庫
    	       const response = await fetch("/api/analysis/save-financial-data", {
    	           method: "POST",
    	           headers: { "Content-Type": "application/json" },
    	           body: JSON.stringify({ month, data }),
    	       });
    	       const result = await response.json();
    	       
    	       if (result.error) {
    	           throw new Error(result.error);
    	       }

    	       await Swal.fire({
    	           icon: 'success',
    	           title: '保存成功',
    	           text: result.message || '數據已成功保存',
    	           showConfirmButton: false,
    	           timer: 1500
    	       });
    	       
    	       // 更新顯示
    	       await loadLatestData();
    	       await fetchAndDisplayReport();
    	       
    	   } catch (error) {
    	       console.error("保存失敗：", error);
    	       Swal.fire({
    	           icon: 'error',
    	           title: '保存失敗',
    	           text: error.message || '請稍後再試'
    	       });
    	       
    	       // 即使保存到資料庫失敗，本地數據也已保存
    	       console.log('本地數據已保存');
    	   }
    	}

    async function fetchSalesData() {
        try {
            const rankingResponse = await fetch("/api/analysis/sales-ranking");
            if (!rankingResponse.ok) {
                throw new Error(`HTTP error! status: ${rankingResponse.status}`);
            }
            const salesRanking = await rankingResponse.json();

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
            }
        } catch (error) {
            console.error("無法取得銷售數據：", error);
        }
    }

    async function loadLatestData() {
        try {
            // 從 localStorage 獲取上次選擇的月份
            let selectedMonth = localStorage.getItem('selectedMonth');
            
            // 如果沒有存儲的月份，則從當前選擇框獲取
            if (!selectedMonth) {
                selectedMonth = document.getElementById('month-select').value;
            }

            // 設置選擇框的值
            document.getElementById('month-select').value = selectedMonth;

            // 獲取指定月份的數據
            const response = await fetch(`/api/analysis/financial-data/${selectedMonth}`);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            
            // 從 localStorage 獲取上次保存的數據
            const savedData = localStorage.getItem(`financialData_${selectedMonth}`);
            const parsedData = savedData ? JSON.parse(savedData) : null;
            
            if (data && data.items) {
                // 如果有數據庫數據，則使用數據庫數據
                const incomeInput = document.getElementById('income-input');
                if (data.items['營業收入']) {
                    incomeInput.value = data.items['營業收入'];
                }

                const expenseInputs = document.querySelectorAll('.expense-input');
                expenseInputs.forEach(input => {
                    const itemName = input.closest('tr').cells[0].textContent;
                    if (data.items[itemName]) {
                        input.value = data.items[itemName];
                    }
                });
                
                // 保存到 localStorage
                localStorage.setItem(`financialData_${selectedMonth}`, JSON.stringify(data.items));
            } else if (parsedData) {
                // 如果沒有數據庫數據但有本地存儲數據，則使用本地存儲數據
                const incomeInput = document.getElementById('income-input');
                if (parsedData['營業收入']) {
                    incomeInput.value = parsedData['營業收入'];
                }

                const expenseInputs = document.querySelectorAll('.expense-input');
                expenseInputs.forEach(input => {
                    const itemName = input.closest('tr').cells[0].textContent;
                    if (parsedData[itemName]) {
                        input.value = parsedData[itemName];
                    }
                });
            }

            // 更新顯示
            updateAll();
        } catch (error) {
            console.error('載入數據失敗:', error);
            
            // 如果加載失敗，嘗試從 localStorage 讀取
            const savedData = localStorage.getItem(`financialData_${document.getElementById('month-select').value}`);
            if (savedData) {
                const parsedData = JSON.parse(savedData);
                const incomeInput = document.getElementById('income-input');
                if (parsedData['營業收入']) {
                    incomeInput.value = parsedData['營業收入'];
                }

                const expenseInputs = document.querySelectorAll('.expense-input');
                expenseInputs.forEach(input => {
                    const itemName = input.closest('tr').cells[0].textContent;
                    if (parsedData[itemName]) {
                        input.value = parsedData[itemName];
                    }
                });
                updateAll();
            }
        }
    }

    // 頁面載入時初始化
    document.addEventListener("DOMContentLoaded", async () => {
        await loadLatestData();
        await fetchSalesData();
        await fetchAndDisplayReport();
        updateAll();
    });
</script>
        
   
</body>
</html>