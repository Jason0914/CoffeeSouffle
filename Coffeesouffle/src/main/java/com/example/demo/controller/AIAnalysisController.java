package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Date;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/analysis")
public class AIAnalysisController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/ai-report")
public Map<String, Object> generateAIReport() {
    try {
        // 獲取財務數據
        Map<String, Map<String, Double>> financialData = fetchFinancialData();

        // 獲取訂單數據
        List<Map<String, Object>> orderData = fetchOrderData();

        // 生成報告
        String report = generateReport(financialData, orderData);

      

        return Map.of(
            "report", report
          
        );
    } catch (Exception e) {
        e.printStackTrace();
        return Map.of("error", "無法生成 AI 報表：" + e.getMessage());
    }
}


    private Map<String, Map<String, Double>> fetchFinancialData() {
        String query = "SELECT month, item_name, SUM(amount) AS total_amount FROM financial_data GROUP BY month, item_name";
        List<Map<String, Object>> results = jdbcTemplate.queryForList(query);

        Map<String, Map<String, Double>> financialData = new HashMap<>();
        for (Map<String, Object> row : results) {
            String month = (String) row.get("month");
            String itemName = (String) row.get("item_name");
            // 將 BigDecimal 明確轉換為 Double
            Double amount = ((BigDecimal) row.get("total_amount")).doubleValue();

            financialData.putIfAbsent(month, new HashMap<>());
            financialData.get(month).put(itemName, amount);
        }
        return financialData;
    }

    private List<Map<String, Object>> fetchOrderData() {
        String query = """
            SELECT DATE(order_time) AS order_date, SUM(quantity * price) AS total_sales
            FROM order_items oi
            JOIN orders o ON oi.order_id = o.order_id
            GROUP BY DATE(order_time)
            ORDER BY DATE(order_time)
        """;
        List<Map<String, Object>> results = jdbcTemplate.queryForList(query);

        // 確保 BigDecimal 轉換正確
        for (Map<String, Object> row : results) {
            row.put("totalSales", ((BigDecimal) row.get("total_sales")).doubleValue());
        }

        return results;
    }

    private String generateReport(Map<String, Map<String, Double>> financialData,
                                  List<Map<String, Object>> orderData) {
        StringBuilder report = new StringBuilder();
      

        // 分析財務數據
        report.append("\n財務概況：\n");
        for (String month : financialData.keySet()) {
            Map<String, Double> items = financialData.get(month);
            double income = items.getOrDefault("營業收入", 0.0);
            double expenses = items.values().stream().mapToDouble(Double::doubleValue).sum() - income;
            double netProfit = items.getOrDefault("淨利", income - expenses);

            report.append(String.format("- %s 月營業收入：%.2f 元，總支出：%.2f 元，淨利：%.2f 元。\n",
                    month, income, expenses, netProfit));
        }

        // 分析訂單數據
        report.append("\n近期銷售表現：\n");
        orderData.stream().limit(7).forEach(order -> {
            Date orderDate = (Date) order.get("order_date");
            double totalSales = (double) order.get("totalSales");
            report.append(String.format("- %s 銷售總額：%.2f 元。\n", orderDate, totalSales));
        });

        return report.toString();
    }


}    