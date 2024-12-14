from flask import Flask, request, jsonify  # type: ignore
from flask_cors import CORS  # type: ignore
import mysql.connector  # type: ignore
from datetime import datetime, timedelta  # 用於處理日期
import pandas as pd # type: ignore

app = Flask(__name__)
CORS(app)

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'A0918088240a',
    'database': 'coffeesouffle'
}

# 預測 API
@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        days = data.get("days", 30)  # 預設為30天

        # 連接資料庫
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)

        # 查詢歷史銷售數據
        cursor.execute("""
            SELECT
                DATE(order_time) AS ds,
                SUM(quantity * price) AS y
            FROM
                order_items oi
            JOIN
                orders o ON oi.order_id = o.order_id
            GROUP BY
                DATE(order_time)
            ORDER BY
                DATE(order_time);
        """)
        rows = cursor.fetchall()

        # 將歷史數據轉換為所需格式
        historical_data = [{"ds": row["ds"].strftime("%Y-%m-%d"), "y": row["y"]} for row in rows]

        # 獲取當前日期
        current_date = datetime.now()

        # 預測未來的銷售數據
        predictions = []
        for i in range(days):
            future_date = current_date + timedelta(days=i)
            predicted_value = historical_data[-1]["y"] + i * 8000  # 預測邏輯：每天增加固定值
            predictions.append({"ds": future_date.strftime("%Y-%m-%d"), "yhat": predicted_value})

        return jsonify(predictions)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# 新增 AI 財務報表分析 API
@app.route('/ai-analysis', methods=['POST'])
def ai_analysis():
    try:
        # 連接資料庫
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)

        # 查詢財務數據
        cursor.execute("""
            SELECT month, item_name, SUM(amount) AS total_amount
            FROM financial_data
            GROUP BY month, item_name
            ORDER BY month;
        """)
        financial_rows = cursor.fetchall()

        # 查詢訂單數據
        cursor.execute("""
            SELECT
                DATE(order_time) AS order_date,
                SUM(quantity * price) AS total_sales
            FROM
                order_items oi
            JOIN
                orders o ON oi.order_id = o.order_id
            GROUP BY
                DATE(order_time)
            ORDER BY
                DATE(order_time);
        """)
        order_rows = cursor.fetchall()

        # 轉換為 pandas DataFrame 進行分析
        financial_data = pd.DataFrame(financial_rows)
        order_data = pd.DataFrame(order_rows)

        # 總結財務數據
        financial_summary = financial_data.groupby("month").agg(
            total_income=("total_amount", lambda x: x[financial_data["item_name"] == "營業收入"].sum()),
            total_expense=("total_amount", lambda x: x[financial_data["item_name"] != "營業收入"].sum()),
            net_profit=("total_amount", lambda x: x[financial_data["item_name"] == "營業收入"].sum() -
                                            x[financial_data["item_name"] != "營業收入"].sum())
        ).reset_index()

        # 預測銷售數據
        last_date = order_data["order_date"].max()
        avg_daily_sales = order_data["total_sales"].mean()
        future_dates = [(last_date + timedelta(days=i)).strftime("%Y-%m-%d") for i in range(1, 31)]
        predicted_sales = [{"ds": date, "yhat": avg_daily_sales} for date in future_dates]

        # 整合結果
        report = {
            "financialSummary": financial_summary.to_dict(orient="records"),
            "salesPrediction": predicted_sales
        }
        return jsonify(report)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    app.run(host='localhost', port=8083, debug=True)




