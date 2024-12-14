package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
	@RequestMapping("/getTableData")
	public class TableController {

	    @PostMapping
	    public ResponseEntity<Map<String, Object>> getTableData(@RequestBody Map<String, Integer> request) {
	        Integer tableNumber = request.get("tableNumber");

	        // 模擬數據庫資料
	        Map<Integer, String> tableData = Map.of(
	            1, "桌號 1 的訂單資料",
	            2, "桌號 2 的訂單資料",
	            3, "桌號 3 的訂單資料",
	            4, "桌號 4 的訂單資料",
	            5, "桌號 5 的訂單資料"
	        );

	        // 查詢對應桌號資料
	        String data = tableData.getOrDefault(tableNumber, "查無資料");

	        // 返回結果
	        Map<String, Object> response = new HashMap<>();
	        response.put("tableNumber", tableNumber);
	        response.put("data", data);

	        return ResponseEntity.ok(response);
	    }
	}

