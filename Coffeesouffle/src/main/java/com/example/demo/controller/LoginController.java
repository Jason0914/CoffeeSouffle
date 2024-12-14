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
            System.out.println("Logging attempt - Account: " + map.get("account"));
            
            Member member = memberService.login(map.get("account"), map.get("password"));
            System.out.println("After login attempt - Member object: " + member);
            
            if (member == null) {
                System.out.println("Login failed - Member is null");
                return ResponseEntity.status(401).body("帳號或密碼錯誤");
            }
            
            System.out.println("Member found - IsMember value: " + member.getIsMember());
            // 檢查是否為員工
            if (member.getIsMember() == null || member.getIsMember() != 1) {
                System.out.println("Access denied - Not an employee");
                return ResponseEntity.status(403).body("您沒有權限訪問後台系統");
            }
            
            session.setAttribute("loginStatus", true);
            session.setAttribute("member", member);

            Map<String, String> result = new HashMap<>();
            result.put("redirectUrl", "/member_backend");
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            System.err.println("Login error occurred: " + e.getMessage());
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