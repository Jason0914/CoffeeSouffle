package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/analysis")
public class SalesAnalysisController {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/coffeesouffle";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "A0918088240a";

    // 銷售排行
    @GetMapping("/sales-ranking")
    public List<Map<String, Object>> getSalesRanking() {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT oi.order_name AS product_name, " +
                       "SUM(oi.quantity) AS total_quantity, " +
                       "SUM(oi.quantity * oi.price) AS total_sales " +
                       "FROM order_items oi " +
                       "GROUP BY oi.order_name " +
                       "ORDER BY total_sales DESC";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("productName", rs.getString("product_name"));
                row.put("totalSales", rs.getDouble("total_sales"));
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }


    @PostMapping("/save-financial-data")
    public Map<String, String> saveFinancialData(@RequestBody Map<String, Object> requestData) {
        String month = (String) requestData.get("month"); // 接收月份
        List<Map<String, Object>> data = (List<Map<String, Object>>) requestData.get("data"); // 接收項目數據
    
        String insertQuery = "INSERT INTO financial_data (month, item_name, amount) VALUES (?, ?, ?)";
    
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
    
            for (Map<String, Object> entry : data) {
                stmt.setString(1, month);
                stmt.setString(2, (String) entry.get("itemName"));
    
                // 確保 amount 是 Double 類型
                Object amountObj = entry.get("amount");
                double amount = 0.0;
    
                if (amountObj instanceof Integer) {
                    amount = ((Integer) amountObj).doubleValue();
                } else if (amountObj instanceof Double) {
                    amount = (Double) amountObj;
                }
    
                stmt.setDouble(3, amount);
                stmt.addBatch();
            }
            stmt.executeBatch();
            return Map.of("message", "數據保存成功");
        } catch (SQLException e) {
            e.printStackTrace();
            return Map.of("message", "數據保存失敗", "error", e.getMessage());
        }
    }
    
   
}
