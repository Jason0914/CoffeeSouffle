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
    
    @PostMapping("/member_backend/")
    @ResponseBody
    public ResponseEntity<?> createMember(@ModelAttribute Member member, Model model) {
        try {
            // 輸出接收到的數據
            System.out.println("Received member data: " + member);
            System.out.println("isMember value: " + member.getIsMember());
            
            // 確保 isMember 是 1
            member.setIsMember(1);
            memberService.createMember(member);
            
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PutMapping("/member_backend/{memberId}")
    @ResponseBody
    public String updateMember(@ModelAttribute Member member, 
                             @PathVariable("memberId") Integer memberId, 
                             Model model, 
                             HttpSession session) throws InterruptedException {
        
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() == null || 
            currentMember.getIsMember() != 1) {
            return "redirect:/member";
        }
        
        member.setIsMember(1);
        memberService.updateMember(memberId, member);
        
        List<Member> memberList = memberService.getAllMember();
        model.addAttribute("member", member);
        model.addAttribute("memberList", memberList);
        model.addAttribute("_method", "PUT");
        
        Thread.sleep(1300);
        return "member_backend";
    }
    
    @DeleteMapping("/member_backend/{memberId}")
    public String deleteMember(@PathVariable("memberId") Integer memberId, 
                             Model model,
                             HttpSession session) throws Exception {
        
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() == null || 
            currentMember.getIsMember() != 1) {
            return "redirect:/member";
        }
        
        // 防止刪除自己的帳號
        if (currentMember.getMemberId().equals(memberId)) {
            throw new Exception("Cannot delete your own account");
        }
        
        memberService.deleteMember(memberId);
        List<Member> memberList = memberService.getAllMember();
        model.addAttribute("memberList", memberList);
        Thread.sleep(1300);
        return "member_backend";
    }

    @GetMapping("/member_backend/checkAccount")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkAccount(@RequestParam String account,
                                                         HttpSession session) {
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() == null || 
            currentMember.getIsMember() != 1) {
            return ResponseEntity.status(403).build();
        }
        
        boolean exists = memberService.checkAccount(account);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/member_backend/checkEmail")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkEmail(@RequestParam String email,
                                                       HttpSession session) {
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() == null || 
            currentMember.getIsMember() != 1) {
            return ResponseEntity.status(403).build();
        }
        
        boolean exists = memberService.checkEmail(email);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/member_backend/checkPhone")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkPhone(@RequestParam String phone,
                                                       HttpSession session) {
        Member currentMember = (Member) session.getAttribute("member");
        if (currentMember == null || currentMember.getIsMember() == null || 
            currentMember.getIsMember() != 1) {
            return ResponseEntity.status(403).build();
        }
        
        boolean exists = memberService.checkPhone(phone);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }
}