package com.example.demo.service;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.KeyUtil;
import com.example.demo.dao.MemberDao;
import com.example.demo.model.po.Member;

@Service
public class MemberService {
    
    @Autowired
    private MemberDao memberDao;
    
    // 取得所有會員
    public List<Member> getAllMember() {
        return memberDao.findAllMember();
    }

    // 根據ID取得會員
    public Member getMemberById(Integer memberId) {
        return memberDao.findMemberById(memberId);
    }
    
    // 根據帳號取得會員
    public Member findMemberByAccount(String account) {
        return memberDao.findMemberByAccount(account);
    }

    // 新增會員
    public int createMember(Member member) throws Exception {
        if(member == null) {
            System.out.println("會員資料為空");
            return 0;
        }

        // 1. 生成 salt
        byte[] salt = new byte[16];
        SecureRandom secureRandom = new SecureRandom();
        secureRandom.nextBytes(salt);
        String saltHex = KeyUtil.bytesToHex(salt);

        // 2. 密碼加密
        String hashedPassword = hashPassword(member.getPassword(), saltHex);
        
        // 3. 設定加密後的密碼和salt
        member.setPassword(hashedPassword);
        member.setSalt(saltHex);
        
        System.out.printf("新增會員 - 帳號: %s, 原始密碼長度: %d, 加密後密碼: %s%n", 
            member.getAccount(), 
            member.getPassword().length(), 
            hashedPassword);
        
        return memberDao.createMember(member);
    }

    // 修改會員
    public int updateMember(Integer memberId, Member member) throws NoSuchAlgorithmException {
        if(member.getPassword() != null && !member.getPassword().isEmpty()) {
            // 生成新的 salt 和加密密碼
            byte[] salt = new byte[16];
            SecureRandom secureRandom = new SecureRandom();
            secureRandom.nextBytes(salt);
            String saltHex = KeyUtil.bytesToHex(salt);
            
            String hashedPassword = hashPassword(member.getPassword(), saltHex);
            member.setPassword(hashedPassword);
            member.setSalt(saltHex);
        }
        
        return memberDao.updateMember(memberId, member);
    }

    // 刪除會員
    public int deleteMember(Integer memberId) {
        return memberDao.deleteMember(memberId);
    }
    
    // 登入驗證
    public Member login(String account, String password) throws Exception {
        Member member = memberDao.findMemberByAccount(account);
        
        if (member == null) {
            System.out.println("查無此帳號");
            return null;
        }
        
        // 驗證密碼
        if (!verifyPassword(password, member.getPassword(), member.getSalt())) {
            System.out.println("密碼錯誤");
            return null;
        }
        
        return member;
    }

    // 密碼驗證
    public boolean verifyPassword(String inputPassword, String storedPassword, String salt) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
            messageDigest.update(KeyUtil.hexStringToByteArray(salt));
            byte[] hashedBytes = messageDigest.digest(inputPassword.getBytes());
            String hashedPassword = KeyUtil.bytesToHex(hashedBytes);
            
            System.out.println("Input password: " + inputPassword);
            System.out.println("Computed hash: " + hashedPassword);
            System.out.println("Stored hash: " + storedPassword);
            
            return hashedPassword.equals(storedPassword);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 密碼加密
    private String hashPassword(String password, String salt) throws NoSuchAlgorithmException {
        MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
        messageDigest.update(KeyUtil.hexStringToByteArray(salt));
        byte[] hashedBytes = messageDigest.digest(password.getBytes());
        return KeyUtil.bytesToHex(hashedBytes);
    }

    // 驗證帳號是否存在
    public boolean checkAccount(String account) {
        return memberDao.checkAccount(account);
    }

    // 驗證 Email 是否存在
    public boolean checkEmail(String email) {
        return memberDao.checkEmail(email);
    }
    
    // 驗證手機號碼是否存在
    public boolean checkPhone(String phone) {
        return memberDao.checkPhone(phone);
    }
}
