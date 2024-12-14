package com.example.demo.hash;

import java.security.MessageDigest;
import java.security.SecureRandom;
import com.example.demo.KeyUtil;

public class PasswordHashGenerator {
    public static void main(String[] args) throws Exception {
        // 設定密碼
        String password = "admin123";
        
        // 生成 salt
        byte[] salt = new byte[16];
        SecureRandom secureRandom = new SecureRandom();
        secureRandom.nextBytes(salt);
        
        // 將 salt 轉換為 hex 字串
        String saltHex = KeyUtil.bytesToHex(salt);
        
        // 使用 SHA-256 生成密碼雜湊
        MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
        messageDigest.update(salt);
        byte[] hashedBytes = messageDigest.digest(password.getBytes());
        String hashedPassword = KeyUtil.bytesToHex(hashedBytes);
        
        // 輸出完整的 SQL 插入語句
        System.out.println("DELETE FROM member WHERE account = 'admin';");
        System.out.println("\nINSERT INTO member (account, password, salt, name, gender, birthday, email, phone, is_member)");
        System.out.println("VALUES ('admin', '" + hashedPassword + "', '" + saltHex + "', '管理員', '男生', '2024-01-01', 'admin@example.com', '0912345678', 1);");
        
        System.out.println("\n登入資訊：");
        System.out.println("帳號: admin");
        System.out.println("密碼: admin123");
    }
}