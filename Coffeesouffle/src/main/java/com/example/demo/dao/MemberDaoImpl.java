package com.example.demo.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.po.Member;

@Repository
public class MemberDaoImpl implements MemberDao {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 查詢所有
    @Override
    public List<Member> findAllMember() {
        String sql = "SELECT member_id, account, password, name, gender, birthday, email, phone, is_member FROM member";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Member.class));
    }

    // 根據 ID 查詢
    @Override
    public Member findMemberById(Integer memberId) {
        String sql = "SELECT member_id, account, password, name, gender, birthday, email, phone, is_member FROM member WHERE member_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Member.class), memberId);
        } catch (DataAccessException e) {
            e.printStackTrace();
            return null;
        }
    }

    // 根據 Account 查詢
    @Override
    public Member findMemberByAccount(String account) {
        String sql = "SELECT member_id, account, password, salt, name, gender, birthday, email, phone, is_member FROM member WHERE account = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Member.class), account);
        } catch (DataAccessException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // 新增會員
    @Override
    public int createMember(Member member) {
        String sql = "INSERT INTO member (account, password, salt, name, gender, birthday, email, phone, is_member) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, 
            member.getAccount(), 
            member.getPassword(), 
            member.getSalt(), 
            member.getName(), 
            member.getGender(), 
            member.getBirthday(), 
            member.getEmail(), 
            member.getPhone(),
            1  // 設定 is_member 為 1 表示員工
        );
    }

    // 修改會員
    @Override
    public int updateMember(Integer memberId, Member member) {
        String sql = "UPDATE member SET password = ?, name = ?, gender = ?, birthday = ?, email = ?, phone = ?, is_member = ? WHERE member_id = ? AND account = ?";
        return jdbcTemplate.update(sql, 
            member.getPassword(), 
            member.getName(), 
            member.getGender(), 
            member.getBirthday(), 
            member.getEmail(), 
            member.getPhone(),
            1,  // 確保更新時保持 is_member 為 1
            memberId, 
            member.getAccount()
        );
    }

    // 刪除會員
    @Override
    public int deleteMember(Integer memberId) {
        String sql = "DELETE FROM member WHERE member_id = ?";
        return jdbcTemplate.update(sql, memberId);
    }

    // 登入驗證
    @Override
    public Member login(String account, String password) {
        String sql = "SELECT * FROM member WHERE account = ? AND password = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Member.class), account, password);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 其他方法保持不變...
    @Override
    public boolean checkAccount(String account) {
        String sql = "SELECT COUNT(*) FROM member WHERE account = ?";
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, account);
            return count != null && count > 0;
        } catch (EmptyResultDataAccessException e) {
            return false;
        } catch (DataAccessException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean checkEmail(String email) {
        String sql = "SELECT COUNT(*) FROM member WHERE email = ?";
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
            return count != null && count > 0;
        } catch (EmptyResultDataAccessException e) {
            return false;
        } catch (DataAccessException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean checkPhone(String phone) {
        String sql = "SELECT COUNT(*) FROM member WHERE phone = ?";
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, phone);
            return count != null && count > 0;
        } catch (EmptyResultDataAccessException e) {
            return false;
        } catch (DataAccessException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Member findMemberByEmail(String email) {
        String sql = "SELECT member_id, account, password, salt, name, gender, birthday, email, phone, is_member FROM member WHERE email = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Member.class), email);
        } catch (DataAccessException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void update(Member member) {
        String sql = "UPDATE member SET password = ?, salt = ? WHERE email = ?";
        jdbcTemplate.update(sql, member.getPassword(), member.getSalt(), member.getEmail());
    }
}
