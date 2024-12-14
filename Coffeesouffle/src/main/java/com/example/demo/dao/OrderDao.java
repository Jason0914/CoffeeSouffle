package com.example.demo.dao;

import java.util.List;
import com.example.demo.model.dto.OrderDto;
import com.example.demo.model.dto.OrderItemDto;
import com.example.demo.model.po.Order;

public interface OrderDao {
    List<Order> findAllOrder();                           // 查詢所有訂單
    Order findOrderById(Integer orderId);                 // 根據ID查詢訂單
    Order findOrderByIdAndClientId(Integer orderId, String clientId); // 根據ID和clientId查詢訂單
    int createOrder(OrderDto orderDto);                   // 創建訂單
    void createOrderItem(Integer orderId, OrderItemDto orderItemDto); // 創建訂單項目
    int deleteOrder(Integer orderId);                     // 刪除訂單
    List<Order> findOrdersByClientAndTable(Integer tableNumber, String clientId); // 根據桌號和clientId查詢訂單
}
