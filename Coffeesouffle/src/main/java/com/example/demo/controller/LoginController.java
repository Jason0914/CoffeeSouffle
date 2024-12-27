package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.example.demo.model.po.Member;
import com.example.demo.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
    
    @Autowired
    private MemberService memberService;
    
    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<?> login(@RequestBody Map<String, String> map, HttpSession session) {
        try {
            String account = map.get("account");
            String password = map.get("password");
            
            System.out.println("Login attempt - Account: " + account + ", Password: " + password);
            
            // 1. 先查找會員
            Member member = memberService.findMemberByAccount(account);
            System.out.println("Found member: " + member);
            
            if (member == null) {
                System.out.println("Member not found");
                return ResponseEntity.status(401).body("帳號或密碼錯誤");
            }
            
            System.out.println("Stored password: " + member.getPassword());
            System.out.println("Stored salt: " + member.getSalt());
            
            // 2. 驗證密碼
            boolean passwordMatch = memberService.verifyPassword(password, member.getPassword(), member.getSalt());
            System.out.println("Password match: " + passwordMatch);
            
            if (!passwordMatch) {
                System.out.println("Password verification failed");
                return ResponseEntity.status(401).body("帳號或密碼錯誤");
            }
            
            // 3. 檢查是否為員工
            if (member.getIsMember() != 1) {
                System.out.println("Not an employee");
                return ResponseEntity.status(403).body("您沒有權限訪問後台系統");
            }

            session.setAttribute("loginStatus", true);
            session.setAttribute("member", member);

            Map<String, String> result = new HashMap<>();
            result.put("redirectUrl", "/member_backend");
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("伺服器錯誤：" + e.getMessage());
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/index";
    }
}