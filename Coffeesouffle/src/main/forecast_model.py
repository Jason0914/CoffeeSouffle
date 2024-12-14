import mysql.connector  # type: ignore
from datetime import datetime

def load_data_from_sql():
    db_config = {
        'host': 'localhost',
        'user': 'root',
        'password': 'A0918088240a',
        'database': 'coffeesouffle'
    }
    try:
        # 連接資料庫
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)

        # 執行 SQL 查詢
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

        # 獲取查詢結果
        rows = cursor.fetchall()

        # 格式化結果
        result = []
        for row in rows:
            formatted_date = row["ds"].strftime("%Y-%m-%d") if isinstance(row["ds"], datetime) else row["ds"]
            result.append({
                "ds": formatted_date,
                "y": float(row["y"])  # 確保金額是浮點數
            })

        return result
    except Exception as e:
        print(f"資料庫查詢失敗: {e}")
        return []
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()
