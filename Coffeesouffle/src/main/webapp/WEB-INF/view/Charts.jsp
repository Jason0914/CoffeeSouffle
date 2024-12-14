<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/css/Charts.css" />
    <title>銷售分析報告</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  </head>
  <body>
    <h1>銷售分析圖表</h1>

    <div class="chart-container">
      <!-- 銷售排名圖表 -->
      <div class="chart-box">
        <h2>銷售排名</h2>
        <canvas id="salesRankingChart"></canvas>
      </div>

      <!-- 銷售預測圖表 -->
      <div class="chart-box">
        <h2>銷售預測</h2>
        <canvas id="salesPredictionChart"></canvas>
      </div>
    </div>
    <h1 style="text-align: center">營業計算表</h1>
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
            <input
              type="number"
              id="income-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>原物料成本</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>房租</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>水電瓦斯</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>薪資</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>勞健保</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>電信費</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>稅（每月）</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>雜項支出</td>
          <td class="expense-amount">0</td>
          <td>
            <input
              type="number"
              class="expense-input"
              value="0"
              oninput="updateAll()"
            />
          </td>
        </tr>
        <tr>
          <td>淨利</td>
          <td id="net-profit">0</td>
          <td></td>
        </tr>
      </tbody>
    </table>
    <div style="text-align: center; margin-top: 20px">
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
      <button onclick="saveData()">保存到資料庫</button>
    </div>
    <h1 style="text-align: center; font-size: 2em;">財務狀況統整</h1>
    <!-- 分析結果 -->
    <div id="report" style="margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9; max-width: 800px;">
      <pre id="reportContent" style="font-size: 1.5em; line-height: 1.6; white-space: pre-wrap; word-wrap: break-word;">正在載入報表...</pre>
    </div>
    <script>
      async function fetchAndDisplayReport() {
        try {
          const response = await fetch("/api/analysis/ai-report");
          const result = await response.json();

          if (result.error) {
            document.getElementById(
              "reportContent"
            ).innerHTML = `<p>${result.error}</p>`;
          } else {
            document.getElementById("reportContent").innerHTML =
              result.report.replace(/\n/g, "<br>");
          }
        } catch (error) {
          console.error("無法載入報告：", error);
          document.getElementById("reportContent").innerHTML =
            "<p>無法載入報告，請稍後再試。</p>";
        }
      }

      document.addEventListener("DOMContentLoaded", fetchAndDisplayReport);

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

      // 初始化時執行一次
      document.addEventListener("DOMContentLoaded", updateAll);

      async function saveData() {
        const income =
          parseFloat(document.getElementById("income-input").value) || 0;
        const expenseInputs = document.querySelectorAll(".expense-input");
        const expenseItems = document.querySelectorAll(".expense-amount");
        const month = document.getElementById("month-select").value;

        const data = [];
        data.push({ itemName: "營業收入", amount: income });

        let totalExpenses = 0;
        expenseInputs.forEach((input, index) => {
          const itemName =
            expenseItems[index].parentElement.cells[0].textContent;
          const amount = parseFloat(input.value) || 0; // 確保數據是浮點數
          totalExpenses += amount;
          data.push({ itemName, amount });
        });

        // 計算並添加淨利
        const netProfit = income - totalExpenses;
        data.push({ itemName: "淨利", amount: netProfit });

        try {
          const response = await fetch("/api/analysis/save-financial-data", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ month, data }),
          });
          const result = await response.json();
          alert(result.message);
        } catch (error) {
          console.error("保存失敗：", error);
          alert("保存失敗，請檢查控制台日誌");
        }
      }

      async function fetchSalesData() {
        try {
          // 獲取銷售排行資料
          const rankingResponse = await fetch("/api/analysis/sales-ranking");
          const salesRanking = await rankingResponse.json();

          // 獲取銷售預測資料
          const predictionResponse = await fetch(
            "/api/analysis/sales-prediction?days=30"
          );
          const salesPrediction = await predictionResponse.json();

          // 繪製銷售排名圖表
          const rankingLabels = salesRanking.map((item) => item.productName);
          const rankingValues = salesRanking.map((item) => item.totalSales);
          new Chart(document.getElementById("salesRankingChart"), {
            type: "bar",
            data: {
              labels: rankingLabels,
              datasets: [
                {
                  label: "銷售額 (元)",
                  data: rankingValues,
                  backgroundColor: "rgba(75, 192, 192, 0.6)",
                  borderColor: "rgba(75, 192, 192, 1)",
                  borderWidth: 1,
                },
              ],
            },
            options: {
              responsive: true,
              maintainAspectRatio: true,
              scales: {
                y: {
                  beginAtZero: true,
                  title: { display: true, text: "銷售額 (元)" },
                },
              },
            },
          });

          // 繪製銷售預測圖表
          const predictionLabels = salesPrediction.map((item) => item.ds);
          const predictionValues = salesPrediction.map((item) => item.yhat);
          new Chart(document.getElementById("salesPredictionChart"), {
            type: "line",
            data: {
              labels: predictionLabels,
              datasets: [
                {
                  label: "預測銷量 (元)",
                  data: predictionValues,
                  borderColor: "rgba(255, 99, 132, 1)",
                  borderWidth: 2,
                  fill: false,
                },
              ],
            },
            options: {
              responsive: true,
              maintainAspectRatio: true,
              scales: {
                y: {
                  beginAtZero: true,
                  title: { display: true, text: "預測銷量 (元)" },
                },
              },
            },
          });
        } catch (error) {
          console.error("無法取得數據：", error);
        }
      }

      // 初始化資料載入
      fetchSalesData();
    </script>
  </body>
</html>
