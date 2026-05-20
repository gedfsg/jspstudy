<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.MemberDAO" %>
<%@ page import="dto.MemberDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String memberId      = request.getParameter("memberId");
    String password      = request.getParameter("password");
    String passwordCheck = request.getParameter("passwordCheck");
    String nickname      = request.getParameter("nickname");
    String email         = request.getParameter("email");

    String errorMsg = null;

    if (memberId == null || memberId.trim().isEmpty()) {
        errorMsg = "아이디를 입력해주세요.";
    } else if (password == null || password.trim().isEmpty()) {
        errorMsg = "비밀번호를 입력해주세요.";
    } else if (!password.equals(passwordCheck)) {
        errorMsg = "비밀번호가 일치하지 않습니다.";
    } else if (nickname == null || nickname.trim().isEmpty()) {
        errorMsg = "닉네임을 입력해주세요.";
    }

    if (errorMsg == null) {
        MemberDAO dao = new MemberDAO();
        try {
            if (dao.isIdDuplicate(memberId)) {
                errorMsg = "이미 사용 중인 아이디입니다.";
            } else if (dao.isNicknameDuplicate(nickname)) {
                errorMsg = "이미 사용 중인 닉네임입니다.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
        }
    }

    if (errorMsg != null) {
        request.setAttribute("errorMsg", errorMsg);
        request.setAttribute("oldId",    memberId);
        request.setAttribute("oldNick",  nickname);
        request.setAttribute("oldEmail", email);
        request.getRequestDispatcher("join.jsp").forward(request, response);
        return;
    }

    try {
        MemberDAO dao = new MemberDAO();
        MemberDTO member = new MemberDTO(memberId, password, nickname, email);
        dao.join(member);
        response.sendRedirect("login.jsp?joined=1");
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMsg", "회원가입 중 오류가 발생했습니다.");
        request.setAttribute("oldId",    memberId);
        request.setAttribute("oldNick",  nickname);
        request.setAttribute("oldEmail", email);
        request.getRequestDispatcher("join.jsp").forward(request, response);
    }
%>