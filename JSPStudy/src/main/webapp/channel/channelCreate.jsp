<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 비로그인 차단
    if (session.getAttribute("loginMember") == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }
    String errorMsg = (String) request.getAttribute("errorMsg");
    String oldName = (String) request.getAttribute("oldName");
    String oldDesc = (String) request.getAttribute("oldDesc");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채널 생성</title>
</head>
<body>

<h2>채널 생성</h2>

<% if (errorMsg != null) { %>
    <p style="color:red;"><%= errorMsg %></p>
<% } %>

<form action="channelCreateAction.jsp" method="post">
    <div>
        <label>채널 이름</label><br>
        <input type="text" name="channelName" value="<%= oldName != null ? oldName : "" %>" required maxlength="50">
    </div>
    <div>
        <label>채널 설명</label><br>
        <textarea name="description" maxlength="200"><%= oldDesc != null ? oldDesc : "" %></textarea>
    </div>
    <button type="submit">채널 생성</button>
</form>

<a href="index.jsp">메인으로</a>

</body>
</html>