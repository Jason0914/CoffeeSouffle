package com.example.demo.filter;

import java.io.IOException;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.example.demo.model.po.Member;

@WebFilter({"/menu_backend", "/news_backend", "/order_backend", "/member_backend"})
public class RootFilter extends HttpFilter {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Boolean loginStatus = (Boolean) session.getAttribute("loginStatus");
        Member member = (Member) session.getAttribute("member");
        
        if (loginStatus == null || !loginStatus || 
            member == null || member.getIsMember() == null || 
            member.getIsMember() != 1) {
            response.sendRedirect("/member");
            return;
        }

        chain.doFilter(request, response);
    }
}
