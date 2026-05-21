package filter;

import dto.MemberDTO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// 이 경로들은 로그인한 사용자만 접근 가능
// 나중에 /channel/*, /board/* 등 추가하면 됨
@WebFilter(urlPatterns = {"/member/logout.jsp"})
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false); // 세션 새로 만들지 않음
        MemberDTO member = (session != null)
                ? (MemberDTO) session.getAttribute("loginMember")
                : null;

        if (member == null) {
            // 비로그인 → 로그인 페이지로 이동
            resp.sendRedirect(req.getContextPath() + "/member/login.jsp");
        } else {
            // 로그인 상태 → 요청 통과
            chain.doFilter(request, response);
        }
    }
}