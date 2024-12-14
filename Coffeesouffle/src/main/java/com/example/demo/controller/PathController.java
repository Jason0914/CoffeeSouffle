package com.example.demo.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.model.po.Member;
import com.example.demo.model.po.News;
import com.example.demo.service.NewsService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PathController {
    
    @Autowired
    private NewsService newsService;

    // 前台頁面路徑
    @GetMapping({"/", "/index"})
    public String indexPage(Model model) {
        List<News> newsList = newsService.getAllNews();
        newsList = newsList.stream().limit(3).collect(Collectors.toList());
        model.addAttribute("newsList", newsList);
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

    @GetMapping("/AIReport")
    public String AIReportPage(HttpSession session) {
        return "AIReport";
    }
}
