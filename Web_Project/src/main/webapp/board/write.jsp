<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.MemberDTO" %>
<%
    String channelIdParam = request.getParameter("channelId");
    if (channelIdParam == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    int channelId = Integer.parseInt(channelIdParam);
    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글쓰기</title>
</head>
<body>

<div>
    <strong><a href="<%= request.getContextPath() %>/index.jsp">커뮤니티</a></strong>
</div>
<hr>

<h2>글쓰기</h2>

<form action="<%= request.getContextPath() %>/board/write_process.jsp" method="post" enctype="multipart/form-data">
    <input type="hidden" name="channelId" value="<%= channelId %>">

    <% if (loginMember == null) { %>
        <div>
            <label>닉네임: <input type="text" name="writerNick" required></label>
        </div>
        <div>
            <label>비밀번호: <input type="password" name="boardPassword" required></label>
        </div>
    <% } %>

    <div>
        <label>제목: <input type="text" name="title" size="60" required></label>
    </div>
    <div>
        <label>내용:<br>
            <textarea name="content" rows="15" cols="60" required></textarea>
        </label>
    </div>

    <div style="margin-top: 10px;">
        <label>파일 첨부 (최대 5개, 각 10MB 이하):<br>
            <input type="file" name="uploadFiles" multiple>
        </label>
        <p style="font-size: 0.85em; color: gray;">
            이미지(jpg, png, gif, webp)는 게시글에 미리보기로 표시됩니다.
        </p>
    </div>

    <button type="submit">등록</button>
    <a href="<%= request.getContextPath() %>/channel/channel.jsp?id=<%= channelId %>">취소</a>
</form>

</body>
</html>