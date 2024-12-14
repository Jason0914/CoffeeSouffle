package com.example.demo.dao;

import java.sql.PreparedStatement;
import java.sql.Statement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

@Repository
public class CustomerDaoImpl implements CustomerDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public int findOrCreateCustomerBySessionId(String sessionId) {
        String findSql = "SELECT id FROM customers WHERE session_id = ?";
        Integer customerId = jdbcTemplate.query(findSql, rs -> rs.next() ? rs.getInt("id") : null, sessionId);

        if (customerId != null) {
            return customerId;
        }

        String insertSql = "INSERT INTO customers (session_id) VALUES (?)";
        GeneratedKeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, sessionId);
            return ps;
        }, keyHolder);

        return keyHolder.getKey().intValue();
    }
}

