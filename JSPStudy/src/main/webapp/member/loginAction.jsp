<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.MemberDAO" %>
<%@ page import="dto.MemberDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String memberId = request.getParameter("memberId");
    String password = request.getParameter("password");

    // 빈 값 체크
    if (memberId == null || memberId.trim().isEmpty() ||
        password == null || password.trim().isEmpty()) {
        request.setAttribute("errorMsg", "아이디와 비밀번호를 입력해주세요.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }

    MemberDAO dao = new MemberDAO();
    MemberDTO member = null;

    try {
        member = dao.login(memberId, password);
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMsg", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }

    if (member != null) {
        // 로그인 성공 → 세션에 회원 정보 저장
        session.setAttribute("loginMember", member);
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    } else {
        // 로그인 실패 → 에러 메시지와 함께 login.jsp로 포워딩
        request.setAttribute("errorMsg", "아이디 또는 비밀번호가 일치하지 않습니다.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
%>