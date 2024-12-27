package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.model.po.Member;
import com.example.demo.service.MemberService;
import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
    
    @Autowired
    private MemberService memberService;

    // 顯示員工管理頁面
    @GetMapping("/member_backend")
    public String getAllMember(Model model, HttpSession session) {
        // 檢查是否登入
        Boolean loginStatus = (Boolean) session.getAttribute("loginStatus");
        Member currentMember = (Member) session.getAttribute("member");
        
        if (loginStatus == null || !loginStatus || 
            currentMember == null || currentMember.getIsMember() == null || 
            currentMember.getIsMember() != 1) {
            return "redirect:/member";
        }
        
        List<Member> memberList = memberService.getAllMember();
        model.addAttribute("memberList", memberList);
        return "member_backend";
    }
    
    // 新增員工
    @PostMapping("/member_backend")
    @ResponseBody
    public ResponseEntity<?> createMember(@ModelAttribute Member member) {
        try {
            // 輸出接收到的數據進行調試
            System.out.println("Received member data: " + member.toString());
            
            // 基本驗證
            if (member.getAccount() == null || member.getPassword() == null) {
                return ResponseEntity.badRequest().body("帳號和密碼不能為空");
            }

            // 檢查帳號是否已存在
            if (memberService.checkAccount(member.getAccount())) {
                return ResponseEntity.badRequest().body("帳號已存在");
            }

            // 檢查 Email 是否已存在
            if (memberService.checkEmail(member.getEmail())) {
                return ResponseEntity.badRequest().body("Email已存在");
            }

            // 檢查手機號碼是否已存在
            if (memberService.checkPhone(member.getPhone())) {
                return ResponseEntity.badRequest().body("手機號碼已存在");
            }

            // 設定為員工
            member.setIsMember(1);

            // 創建會員
            int result = memberService.createMember(member);
            
            if (result > 0) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.badRequest().body("新增失敗");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("新增失敗：" + e.getMessage());
        }
    }
    
    // 更新員工資料
    @PutMapping("/member_backend/{memberId}")
    @ResponseBody
    public ResponseEntity<?> updateMember(@ModelAttribute Member member, 
                                        @PathVariable("memberId") Integer memberId, 
                                        HttpSession session) {
        try {
            Member currentMember = (Member) session.getAttribute("member");
            if (currentMember == null || currentMember.getIsMember() != 1) {
                return ResponseEntity.status(403).body("沒有權限執行此操作");
            }
            
            member.setIsMember(1);
            memberService.updateMember(memberId, member);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("更新失敗：" + e.getMessage());
        }
    }
    
    // 刪除員工
    @DeleteMapping("/member_backend/{memberId}")
    @ResponseBody
    public ResponseEntity<?> deleteMember(@PathVariable("memberId") Integer memberId, 
                                        HttpSession session) {
        try {
            Member currentMember = (Member) session.getAttribute("member");
            if (currentMember == null || currentMember.getIsMember() != 1) {
                return ResponseEntity.status(403).body("沒有權限執行此操作");
            }
            
            // 防止刪除自己的帳號
            if (currentMember.getMemberId().equals(memberId)) {
                return ResponseEntity.badRequest().body("不能刪除自己的帳號");
            }
            
            memberService.deleteMember(memberId);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("刪除失敗：" + e.getMessage());
        }
    }

    // 檢查帳號是否存在
    @GetMapping("/member_backend/checkAccount")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkAccount(@RequestParam String account,
                                                         HttpSession session) {
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() != 1) {
            return ResponseEntity.status(403).build();
        }
        
        boolean exists = memberService.checkAccount(account);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    // 檢查 Email 是否存在
    @GetMapping("/member_backend/checkEmail")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkEmail(@RequestParam String email,
                                                       HttpSession session) {
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() != 1) {
            return ResponseEntity.status(403).build();
        }
        
        boolean exists = memberService.checkEmail(email);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    // 檢查手機號碼是否存在
    @GetMapping("/member_backend/checkPhone")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkPhone(@RequestParam String phone,
                                                       HttpSession session) {
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() != 1) {
            return ResponseEntity.status(403).build();
        }
        
        boolean exists = memberService.checkPhone(phone);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }
}