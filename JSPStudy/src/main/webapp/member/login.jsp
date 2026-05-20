<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loginMember") != null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String errorMsg = (String) request.getAttribute("errorMsg");
    String joined = request.getParameter("joined");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
</head>
<body>

<h2>로그인</h2>

<% if ("1".equals(joined)) { %>
    <p style="color:green;">회원가입이 완료되었습니다! 로그인해주세요.</p>
<% } %>

<% if (errorMsg != null) { %>
    <p style="color:red;"><%= errorMsg %></p>
<% } %>

<form action="loginAction.jsp" method="post">
    <div>
        <label>아이디</label><br>
        <input type="text" name="memberId" required>
    </div>
    <div>
        <label>비밀번호</label><br>
        <input type="password" name="password" required>
    </div>
    <button type="submit">로그인</button>
</form>

<a href="join.jsp">회원가입</a>

</body>
</html>