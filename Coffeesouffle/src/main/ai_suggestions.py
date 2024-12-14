from flask import Flask, request, jsonify # type: ignore
from flask_cors import CORS # type: ignore
import random
import json
app = Flask(__name__)
CORS(app)

@app.route('/ai_suggestions', methods=['POST'])
def generate_suggestions():
    try:
        data = request.get_json()
        print("Received data:", data)  # 調試輸入數據

        financial_data = data.get("financialData", [])
        sales_data = data.get("salesData", [])

        suggestions = []

        # 財務數據分析
        for item in financial_data:
            if item["netProfit"] < 0:
                suggestions.append(
                    f"建議檢查 {item['month']} 的營業收入與支出，淨利為負，請減少不必要的開支。"
                )
            elif item["expenses"] / item["income"] > 0.8:
                suggestions.append(
                    f"{item['month']} 月支出佔比過高，建議降低 {item['highestExpense']}。"
                )
            else:
                suggestions.append(
                    f"{item['month']} 月財務表現良好，可考慮增加營銷投入。"
                )

        # 銷售數據分析
        if sales_data:
            top_product = max(sales_data, key=lambda x: x["totalSales"])
            suggestions.append(
                f"熱門商品建議：增加 {top_product['productName']} 的庫存，因為銷售額最高 ({top_product['totalSales']})。"
            )
            low_sales_products = [
                product["productName"]
                for product in sales_data
                if product["totalSales"] < 500
            ]
            if low_sales_products:
                suggestions.append(
                    f"以下商品銷售表現較差，建議進行促銷或下架：{', '.join(low_sales_products)}。"
                )

        return app.response_class(
            response=json.dumps({"suggestions": suggestions}, ensure_ascii=False),
            mimetype="application/json"
        )
    except Exception as e:
        print("Error occurred:", str(e))  # 打印錯誤日誌
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='localhost', port=8084, debug=True)

