package com.example.demo.dao;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.model.dto.OrderDto;
import com.example.demo.model.dto.OrderItemDto;
import com.example.demo.model.po.Order;

@Repository
public class OrderDaoImpl implements OrderDao {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Override
    public List<Order> findAllOrder() {
        String sql = "SELECT order_id, table_number, order_time, expire_time, total_price, client_id " +
                    "FROM orders WHERE expire_time > NOW() OR expire_time IS NULL " +
                    "ORDER BY order_id DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Order.class));
    }

    @Override
    public Order findOrderById(Integer orderId) {
        String sql = "SELECT order_id, table_number, order_time, expire_time, total_price, client_id " +
                    "FROM orders WHERE order_id = ? AND (expire_time > NOW() OR expire_time IS NULL)";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Order.class), orderId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public Order findOrderByIdAndClientId(Integer orderId, String clientId) {
        String sql = "SELECT order_id, table_number, order_time, expire_time, total_price, client_id " +
                    "FROM orders WHERE order_id = ? AND client_id = ? " +
                    "AND (expire_time > NOW() OR expire_time IS NULL)";
        try {
            return jdbcTemplate.queryForObject(sql, 
                new BeanPropertyRowMapper<>(Order.class), 
                orderId, 
                clientId);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public int createOrder(OrderDto orderDto) {
        String sql = "INSERT INTO orders (table_number, total_price, order_time, client_id, expire_time) " +
                    "VALUES (?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, orderDto.getTableNumber());
            ps.setInt(2, orderDto.getTotalPrice());
            ps.setTimestamp(3, new java.sql.Timestamp(orderDto.getOrderTime().getTime()));
            ps.setString(4, orderDto.getClientId());
            ps.setTimestamp(5, new java.sql.Timestamp(orderDto.getExpireTime().getTime()));
            return ps;
        }, keyHolder);

        return keyHolder.getKey().intValue();
    }

    @Override
    public void createOrderItem(Integer orderId, OrderItemDto orderItemDto) {
        String sql = "INSERT INTO order_items (order_id, order_name, quantity, price) " +
                    "VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            orderId, 
            orderItemDto.getOrderName(), 
            orderItemDto.getQuantity(), 
            orderItemDto.getPrice()
        );
    }

    @Override
    @Transactional
    public int deleteOrder(Integer orderId) {
        String deleteOrderItemsSql = "DELETE FROM order_items WHERE order_id = ?";
        jdbcTemplate.update(deleteOrderItemsSql, orderId);

        String deleteOrderSql = "DELETE FROM orders WHERE order_id = ?";
        return jdbcTemplate.update(deleteOrderSql, orderId);
    }

    @Override
    public List<Order> findOrdersByClientAndTable(Integer tableNumber, String clientId) {
        String sql = "SELECT order_id, table_number, order_time, expire_time, total_price, client_id " +
                    "FROM orders WHERE table_number = ? AND client_id = ? " +
                    "AND (expire_time > NOW() OR expire_time IS NULL) " +
                    "ORDER BY order_time DESC";
        try {
            return jdbcTemplate.query(sql, 
                new BeanPropertyRowMapper<>(Order.class), 
                tableNumber, 
                clientId
            );
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
}