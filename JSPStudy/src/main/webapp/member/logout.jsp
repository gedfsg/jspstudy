<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate(); // 세션 완전 삭제
    response.sendRedirect(request.getContextPath() + "/member/login.jsp");
%>