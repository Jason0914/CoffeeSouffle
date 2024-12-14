package com.example.demo.dao;

public interface CustomerDao {
    int findOrCreateCustomerBySessionId(String sessionId);
}
