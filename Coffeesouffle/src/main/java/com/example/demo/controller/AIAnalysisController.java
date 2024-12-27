package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/analysis")
public class AIAnalysisController {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

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

    @PostMapping("/save-financial-data")
    public Map<String, Object> saveFinancialData(@RequestBody Map<String, Object> requestData) {
        String month = (String) requestData.get("month");
        List<Map<String, Object>> data = (List<Map<String, Object>>) requestData.get("data");

        try {
            String deleteQuery = "DELETE FROM financial_data WHERE month = ?";
            jdbcTemplate.update(deleteQuery, month);

            String insertQuery = "INSERT INTO financial_data (month, item_name, amount) VALUES (?, ?, ?)";
            jdbcTemplate.batchUpdate(insertQuery,
                data.stream().map(entry -> new Object[]{
                    month,
                    entry.get("itemName"),
                    ((Number) entry.get("amount")).doubleValue()
                }).collect(Collectors.toList())
            );
            
            return Map.of("message", "數據保存成功", "success", true);
        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("message", "數據保存失敗", "error", e.getMessage());
        }
    }

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
            if (rowsAffected >= 0) {
                response.put("message", "所有財務數據已清空");
                response.put("success", "true");
            } else {
                response.put("message", "數據庫中沒有數據需要清空");
                response.put("success", "true");
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("error", "清空數據失敗：" + e.getMessage()));
        }
    }

    @GetMapping("/export-pdf")
    public ResponseEntity<byte[]> exportPDF() {
        try {
            Document document = new Document(PageSize.A4);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            document.open();

            // 設置中文字型
            BaseFont baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
            Font titleFont = new Font(baseFont, 18, Font.BOLD);
            Font headerFont = new Font(baseFont, 12, Font.BOLD);
            Font normalFont = new Font(baseFont, 10, Font.NORMAL);
            Font footerFont = new Font(baseFont, 8, Font.ITALIC);

            // 添加標題
            Paragraph title = new Paragraph("咖啡舒芙蕾年度財務報表", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // 添加報表日期
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy年MM月dd日");
            String currentDate = dateFormat.format(new java.util.Date());
            Paragraph info = new Paragraph("報表生成日期: " + currentDate, normalFont);
            info.setAlignment(Element.ALIGN_RIGHT);
            info.setSpacingAfter(20);
            document.add(info);

            // 創建表格
            PdfPTable table = new PdfPTable(5);
            float[] columnWidths = {0.5f, 1f, 1.5f, 1.5f, 1.5f};
            table.setWidths(columnWidths);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);

            // 添加表頭
            String[] headers = {"編號", "月份", "營業收入", "總成本", "淨利"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(new BaseColor(220, 220, 220));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                cell.setBorderColor(BaseColor.BLACK);
                table.addCell(cell);
            }

            // 添加數據
            Map<String, Map<String, Double>> financialData = fetchFinancialData();
            addChineseTableData(table, financialData, normalFont);

            document.add(table);

            // 添加頁腳
            Paragraph footer = new Paragraph();
            footer.add(new Chunk("機密文件 - 咖啡舒芙蕾", footerFont));
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(20);
            document.add(footer);

            document.close();

            // 創建響應頭
            String filename = "財務報表_" + currentDate + ".pdf";
            ContentDisposition contentDisposition = ContentDisposition.attachment()
                .filename(filename, StandardCharsets.UTF_8)
                .build();

            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.setContentType(MediaType.APPLICATION_PDF);
            responseHeaders.setContentDisposition(contentDisposition);

            return new ResponseEntity<>(baos.toByteArray(), responseHeaders, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private void addChineseTableData(PdfPTable table, Map<String, Map<String, Double>> financialData, Font normalFont) {
        if (financialData.isEmpty()) {
            for (int i = 0; i < 5; i++) {
                table.addCell(createCell("-", normalFont));
            }
            return;
        }

        List<Integer> months = financialData.keySet().stream()
            .map(Integer::parseInt)
            .sorted()
            .collect(Collectors.toList());

        double totalRevenue = 0;
        double totalCost = 0;
        double totalNet = 0;

        for (int i = 0; i < months.size(); i++) {
            Integer month = months.get(i);
            Map<String, Double> monthData = financialData.get(month.toString());
            double revenue = monthData.getOrDefault("營業收入", 0.0);
            double cost = monthData.entrySet().stream()
                .filter(e -> !e.getKey().equals("營業收入") && !e.getKey().equals("淨利"))
                .mapToDouble(Map.Entry::getValue)
                .sum();
            double netIncome = revenue - cost;

            totalRevenue += revenue;
            totalCost += cost;
            totalNet += netIncome;

            table.addCell(createCell(String.valueOf(i + 1), normalFont));
            table.addCell(createCell(month + "月", normalFont));
            table.addCell(createCell(String.format("%,.2f", revenue), normalFont));
            table.addCell(createCell(String.format("%,.2f", cost), normalFont));
            table.addCell(createCell(String.format("%,.2f", netIncome), normalFont));
        }

        // 添加總計行
        addChineseTotalRow(table, totalRevenue, totalCost, totalNet, normalFont);
    }

    private void addChineseTotalRow(PdfPTable table, double totalRevenue, double totalCost, double totalNet, Font font) {
        PdfPCell emptyCell = createCell("", font);
        table.addCell(emptyCell);
        
        PdfPCell totalCell = createCell("總計", font);
        totalCell.setBackgroundColor(new BaseColor(220, 220, 220));
        table.addCell(totalCell);
        
        table.addCell(createCell(String.format("%,.2f", totalRevenue), font));
        table.addCell(createCell(String.format("%,.2f", totalCost), font));
        table.addCell(createCell(String.format("%,.2f", totalNet), font));
    }

    private PdfPCell createCell(String content, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(content, font));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(6);
        cell.setBorderColor(BaseColor.BLACK);
        return cell;
    }

    @GetMapping("/latest-financial-data")
    public ResponseEntity<Map<String, Object>> getLatestFinancialData() {
        try {
            String query = """
                SELECT month, item_name, amount 
                FROM financial_data 
                WHERE month = (SELECT month FROM financial_data ORDER BY month DESC LIMIT 1)
            """;
            
            List<Map<String, Object>> results = jdbcTemplate.queryForList(query);
            if (results.isEmpty()) {
                return ResponseEntity.ok(new HashMap<>());
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("month", results.get(0).get("month"));
            
            Map<String, Double> items = new HashMap<>();
            for (Map<String, Object> row : results) {
                String itemName = (String) row.get("item_name");
                Double amount = ((BigDecimal) row.get("amount")).doubleValue();
                items.put(itemName, amount);
            }
            response.put("items", items);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/financial-data/{month}")
    public ResponseEntity<Map<String, Object>> getFinancialDataByMonth(@PathVariable String month) {
        try {
            String query = "SELECT item_name, amount FROM financial_data WHERE month = ?";
            List<Map<String, Object>> results = jdbcTemplate.queryForList(query, month);
            
            if (results.isEmpty()) {
                return ResponseEntity.ok(new HashMap<>());
            }
            
            Map<String, Object> response = new HashMap<>();
            Map<String, Double> items = new HashMap<>();
            
            for (Map<String, Object> row : results) {
                String itemName = (String) row.get("item_name");
                Double amount = ((BigDecimal) row.get("amount")).doubleValue();
                items.put(itemName, amount);
            }
            
            response.put("month", month);
            response.put("items", items);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
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

    private String generateReport(Map<String, Map<String, Double>> financialData, List<Map<String, Object>> orderData) {
        StringBuilder report = new StringBuilder();
        report.append("\n財務概況：\n");

        java.text.DecimalFormat formatter = new java.text.DecimalFormat("#,###");

        List<String> sortedMonths = new ArrayList<>(financialData.keySet());
        Collections.sort(sortedMonths, (a, b) -> {
            int monthA = Integer.parseInt(a);
            int monthB = Integer.parseInt(b);
            return Integer.compare(monthA, monthB);
        });

        for (String month : sortedMonths) {
            Map<String, Double> items = financialData.get(month);
            double income = items.getOrDefault("營業收入", 0.0);
            
            double expenses = items.entrySet().stream()
                .filter(entry -> !entry.getKey().equals("營業收入") && !entry.getKey().equals("淨利"))
                .mapToDouble(Map.Entry::getValue)
                .sum();
                
            double netProfit = items.getOrDefault("淨利", income - expenses);

            report.append(String.format("- %s 月營業收入：%s 元，總支出：%s 元，淨利：%s 元\n",
                    month, 
                    formatter.format(income), 
                    formatter.format(expenses), 
                    formatter.format(netProfit)));
        }

        

        // 近期銷售報告
        report.append("\n近期銷售表現：\n");
        if (!orderData.isEmpty()) {
            double totalSales = 0;
            int dayCount = 0;
            
            for (Map<String, Object> order : orderData) {
                if (dayCount < 7) { // 只顯示最近7天
                    Date orderDate = (Date) order.get("order_date");
                    double dailySales = (double) order.get("totalSales");
                    totalSales += dailySales;
                    
                    report.append(String.format("- %s：銷售額 %s 元\n", 
                        new SimpleDateFormat("MM月dd日").format(orderDate),
                        formatter.format(dailySales)));
                    
                    dayCount++;
                }
            }
         
        } else {
            report.append("- 暫無銷售數據\n");
        }

        return report.toString();
    }

    private double calculateTotalExpenses(Map<String, Double> monthData) {
        return monthData.entrySet().stream()
            .filter(entry -> !entry.getKey().equals("營業收入") && !entry.getKey().equals("淨利"))
            .mapToDouble(Map.Entry::getValue)
            .sum();
    }
}