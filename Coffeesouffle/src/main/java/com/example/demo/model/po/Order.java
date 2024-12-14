package com.example.demo.model.po;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {
    private Integer orderId;
    private Integer tableNumber;
    private String orderName;
    private Integer quantity;
    private Integer price;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date orderTime;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date expireTime;  // 新增過期時間字段
    
    private Integer totalPrice;
    private String clientId;  // 新增客戶端標識字段
}