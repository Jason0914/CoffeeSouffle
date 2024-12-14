package com.example.demo.service;

import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dao.OrderDao;
import com.example.demo.dao.OrderItemDao;
import com.example.demo.model.dto.OrderDto;
import com.example.demo.model.dto.OrderItemDto;
import com.example.demo.model.po.Order;
import com.example.demo.model.po.OrderItem;

@Service
public class OrderService {
    
    @Autowired
    private OrderDao orderDao;
    
    @Autowired
    private OrderItemDao orderItemDao;
    
    // 取得所有訂單（後台用）
    public List<Order> getAllOrder() {
        return orderDao.findAllOrder();
    }
    
    // 取得所有訂單項目（後台用）
    public List<OrderItem> getAllOrderItem() {
        return orderItemDao.fintAllOrderItem();
    }
    
    // 根據 ID 取得訂單
    public Order getOrderById(Integer orderId) {
        return orderDao.findOrderById(orderId);
    }
    
    // 根據 ID 和 clientId 取得訂單
    public Order getOrderByIdAndClientId(Integer orderId, String clientId) {
        return orderDao.findOrderByIdAndClientId(orderId, clientId);
    }
    
    // 根據 ID 取得訂單項目
    public List<OrderItem> getOrderItemById(Integer orderId) {
        return orderItemDao.findOrderItemById(orderId);
    }
    
    // 根據客戶 ID 和桌號取得訂單
    public List<Order> getOrdersByClientAndTable(Integer tableNumber, String clientId) {
        return orderDao.findOrdersByClientAndTable(tableNumber, clientId);
    }
    
    // 新增訂單
    @Transactional
    public void createOrder(OrderDto orderDto) {
        // 設置過期時間為訂單時間後24小時
        Calendar cal = Calendar.getInstance();
        cal.setTime(orderDto.getOrderTime());
        cal.add(Calendar.HOUR, 24);
        orderDto.setExpireTime(cal.getTime());
        
        // 新增訂單並取得訂單 ID
        int orderId = orderDao.createOrder(orderDto);
        
        // 新增訂單項目
        for (OrderItemDto item : orderDto.getItems()) {
            orderDao.createOrderItem(orderId, item);
        }
    }
    
    // 刪除訂單
    @Transactional
    public void deleteOrder(Integer orderId) {
        orderDao.deleteOrder(orderId);
    }
}