<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loginMember") != null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String errorMsg  = (String) request.getAttribute("errorMsg");
    String oldId     = request.getAttribute("oldId")    != null ? (String) request.getAttribute("oldId")    : "";
    String oldNick   = request.getAttribute("oldNick")  != null ? (String) request.getAttribute("oldNick")  : "";
    String oldEmail  = request.getAttribute("oldEmail") != null ? (String) request.getAttribute("oldEmail") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
</head>
<body>

<h2>회원가입</h2>

<% if (errorMsg != null) { %>
    <p style="color:red;"><%= errorMsg %></p>
<% } %>

<form action="joinAction.jsp" method="post">
    <div>
        <label>아이디</label><br>
        <input type="text" name="memberId" value="<%= oldId %>" maxlength="20" required>
    </div>
    <div>
        <label>비밀번호</label><br>
        <input type="password" name="password" maxlength="100" required>
    </div>
    <div>
        <label>비밀번호 확인</label><br>
        <input type="password" name="passwordCheck" maxlength="100" required>
    </div>
    <div>
        <label>닉네임</label><br>
        <input type="text" name="nickname" value="<%= oldNick %>" maxlength="20" required>
    </div>
    <div>
        <label>이메일</label><br>
        <input type="email" name="email" value="<%= oldEmail %>" maxlength="100">
    </div>
    <button type="submit">가입하기</button>
</form>

<a href="login.jsp">이미 계정이 있으신가요? 로그인</a>

</body>
</html>