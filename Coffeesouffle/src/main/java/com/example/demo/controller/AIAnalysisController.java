package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/analysis")
public class AIAnalysisController {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 銷售排行功能 - 修正查詢語句
    @GetMapping("/sales-ranking")
    public List<Map<String, Object>> getSalesRanking() {
        String query = """
            SELECT oi.order_name AS product_name,
                   SUM(oi.quantity) AS total_quantity,
                   SUM(oi.quantity * oi.price) AS total_sales
            FROM order_items oi
            GROUP BY oi.order_name
            ORDER BY total_sales DESC
        """;
        return jdbcTemplate.queryForList(query);
    }

    // 保存財務數據
    @PostMapping("/save-financial-data")
    public Map<String, String> saveFinancialData(@RequestBody Map<String, Object> requestData) {
        String month = (String) requestData.get("month");
        List<Map<String, Object>> data = (List<Map<String, Object>>) requestData.get("data");

        try {
            // 先刪除該月份的舊數據
            String deleteQuery = "DELETE FROM financial_data WHERE month = ?";
            jdbcTemplate.update(deleteQuery, month);

            // 插入新數據
            String insertQuery = "INSERT INTO financial_data (month, item_name, amount) VALUES (?, ?, ?)";
            jdbcTemplate.batchUpdate(insertQuery,
                data.stream().map(entry -> new Object[]{
                    month,
                    entry.get("itemName"),
                    ((Number) entry.get("amount")).doubleValue()
                }).collect(Collectors.toList())
            );
            return Map.of("message", "數據保存成功（如有舊數據已被覆蓋）");
        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("message", "數據保存失敗", "error", e.getMessage());
        }
    }

    // AI 報告生成
    @GetMapping("/ai-report")
    public Map<String, Object> generateAIReport() {
        try {
            Map<String, Map<String, Double>> financialData = fetchFinancialData();
            List<Map<String, Object>> orderData = fetchOrderData();
            String report = generateReport(financialData, orderData);
            return Map.of("report", report);
        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("error", "無法生成報表：" + e.getMessage());
        }
    }
    @DeleteMapping("/clear-financial-data")
    public ResponseEntity<Map<String, String>> clearFinancialData() {
        try {
            String clearDataQuery = "DELETE FROM financial_data";
            int rowsAffected = jdbcTemplate.update(clearDataQuery);
            
            Map<String, String> response = new HashMap<>();
            if (rowsAffected > 0) {
                response.put("message", "所有財務數據已清空");
            } else {
                response.put("message", "數據庫中沒有數據需要清空");
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("error", "清空數據失敗：" + e.getMessage()));
        }
    }

    private Map<String, Map<String, Double>> fetchFinancialData() {
        String query = "SELECT month, item_name, amount FROM financial_data";
        List<Map<String, Object>> results = jdbcTemplate.queryForList(query);

        Map<String, Map<String, Double>> financialData = new HashMap<>();
        for (Map<String, Object> row : results) {
            String month = (String) row.get("month");
            String itemName = (String) row.get("item_name");
            Double amount = ((BigDecimal) row.get("amount")).doubleValue();

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
        
        for (Map<String, Object> row : results) {
            row.put("totalSales", ((BigDecimal) row.get("total_sales")).doubleValue());
        }
        return results;
    }

    private String generateReport(Map<String, Map<String, Double>> financialData,
                                List<Map<String, Object>> orderData) {
        StringBuilder report = new StringBuilder();

        report.append("\n財務概況：\n");
        for (String month : financialData.keySet()) {
            Map<String, Double> items = financialData.get(month);
            double income = items.getOrDefault("營業收入", 0.0);
            
            double expenses = items.entrySet().stream()
                .filter(entry -> !entry.getKey().equals("營業收入") && !entry.getKey().equals("淨利"))
                .mapToDouble(Map.Entry::getValue)
                .sum();
                
            double netProfit = items.getOrDefault("淨利", income - expenses);

            report.append(String.format("- %s 月營業收入：%.2f 元，總支出：%.2f 元，淨利：%.2f 元。\n",
                    month, income, expenses, netProfit));
        }

        report.append("\n近期銷售表現：\n");
        orderData.stream().limit(7).forEach(order -> {
            Date orderDate = (Date) order.get("order_date");
            double totalSales = (double) order.get("totalSales");
            report.append(String.format("- %s 銷售總額：%.2f 元。\n", orderDate, totalSales));
        });

        return report.toString();
    }
}
