package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.model.po.Member;
import jakarta.servlet.http.HttpSession;

@Controller
public class PathController {
    
    
    
    // 前台頁面路徑
    @GetMapping({"/", "/index"})
    public String indexPage() {
        return "index";
    }
    
    @GetMapping("/table")
    public String tablePage() {
        return "table";
    }
        
    @GetMapping("/member")
    public String memberPage(HttpSession session) {
        Boolean loginStatus = (Boolean) session.getAttribute("loginStatus");
        Member member = (Member) session.getAttribute("member");
        
        if (loginStatus != null && loginStatus && 
            member != null && member.getIsMember() != null && 
            member.getIsMember() == 1) {
            return "redirect:/member_backend";
        }
        return "member";
    }
    
    @GetMapping("/cart")
    public String cartPage() {
        return "cart";
    }

    // 後台頁面路徑 - 需要登入驗證
    @GetMapping("/Charts")
    public String ChartsPage(HttpSession session) {
        return "Charts";
    }

    
}