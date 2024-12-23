package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.model.dto.OrderDto;
import com.example.demo.model.po.Order;
import com.example.demo.model.po.OrderItem;
import com.example.demo.service.OrderService;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;

    // 新增前台訂單提交端點
    @PostMapping("/submitOrder")
    @ResponseBody
    public ResponseEntity<?> submitOrder(@RequestBody OrderDto orderDto) {
        try {
            if (orderDto.getClientId() == null || orderDto.getClientId().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("缺少客戶識別碼");
            }
            orderService.createOrder(orderDto);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("建立訂單失敗：" + e.getMessage());
        }
    }

    // 後台管理頁面
    @GetMapping("/order_backend")
    public String getAllOrder(Model model) {
        List<Order> orderList = orderService.getAllOrder();
        model.addAttribute("orderList", orderList);

        List<OrderItem> orderItemsList = orderService.getAllOrderItem();
        model.addAttribute("orderItemList", orderItemsList);

        return "order_backend";
    }

    // 後台單筆查詢
    @GetMapping("/order_backend/{orderId}")
    @ResponseBody
    public List<OrderItem> getOrderItem(@PathVariable("orderId") Integer orderId) {
        return orderService.getOrderItemById(orderId);
    }

    // 後台刪除訂單
    @DeleteMapping("/order_backend/{orderId}")
    public String deleteOrder(@PathVariable("orderId") Integer orderId, Model model) throws Exception {
        orderService.deleteOrder(orderId);
        List<Order> orderList = orderService.getAllOrder();
        model.addAttribute("orderList", orderList);
        Thread.sleep(1300);
        return "order_backend";
    }

    // 前台用戶查詢訂單
    @GetMapping("/orders/client")
    @ResponseBody
    public ResponseEntity<?> getOrdersByClientAndTable(
            @RequestParam("tableNumber") Integer tableNumber,
            @RequestParam("clientId") String clientId) {
        try {
            List<Order> orders = orderService.getOrdersByClientAndTable(tableNumber, clientId);
            return ResponseEntity.ok(orders);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("查詢失敗：" + e.getMessage());
        }
    }

    // 查看訂單明細
    @GetMapping("/table/orders/details/{orderId}")
    @ResponseBody
    public ResponseEntity<?> getOrderDetailsForTable(
            @PathVariable("orderId") Integer orderId,
            @RequestParam("clientId") String clientId) {
        try {
            Map<String, Object> response = new HashMap<>();
            
            Order order = orderService.getOrderByIdAndClientId(orderId, clientId);
            if (order == null) {
                return ResponseEntity.badRequest().body("無法存取此訂單");
            }

            List<OrderItem> orderItems = orderService.getOrderItemById(orderId);
            if (orderItems == null || orderItems.isEmpty()) {
                return ResponseEntity.badRequest().body("找不到訂單項目");
            }

            response.put("order", order);
            response.put("items", orderItems);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("查詢失敗：" + e.getMessage());
        }
    }

    // 前台刪除訂單
    @DeleteMapping("/table/orders/delete/{orderId}")
    @ResponseBody
    public ResponseEntity<?> deleteOrderForTable(
            @PathVariable("orderId") Integer orderId,
            @RequestParam("clientId") String clientId) {
        try {
            Order order = orderService.getOrderByIdAndClientId(orderId, clientId);
            if (order == null) {
                return ResponseEntity.badRequest().body("無法刪除此訂單");
            }
            orderService.deleteOrder(orderId);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("刪除失敗：" + e.getMessage());
        }
    }
}
