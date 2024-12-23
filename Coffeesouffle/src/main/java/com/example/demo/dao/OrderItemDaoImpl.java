package com.example.demo.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.po.OrderItem;

//OrderItemDao 的實現類，使用 JDBC 來執行資料庫操作
@Repository
public class OrderItemDaoImpl implements OrderItemDao{

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	// 根據 OrderID 單筆查詢，查不到會有 DataAccess 例外
	@Override
	public List<OrderItem> findOrderItemById(Integer orderId) {
	    String sql = "SELECT order_item_id, order_id, order_name, quantity, price FROM order_items WHERE order_id = ?";
	    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(OrderItem.class), orderId);
	}

	


	// 取得所有 OrderItem
	@Override
	public List<OrderItem> fintAllOrderItem() {
	    String sql = "SELECT order_name, SUM(quantity) as quantity, "
	            + "MAX(order_item_id) as order_item_id, "  // 添加必要的欄位
	            + "MAX(order_id) as order_id, "
	            + "MAX(price) as price "
	            + "FROM order_items "  // 修正表名為小寫
	            + "GROUP BY order_name "
	            + "ORDER BY quantity DESC";
	    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(OrderItem.class));
	}

	
	// service呼叫 DAO 執行動作
}
