<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    int channelId = Integer.parseInt(request.getParameter("channelId"));

    BoardDAO dao = new BoardDAO();
    BoardDTO dto = dao.selectBoard(boardId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>
</head>
<body>

<h1><%= dto.getTitle() %></h1>

<hr>

작성자 : <%= dto.getWriterNick() %>
<br><br>

조회수 : <%= dto.getReadCount() %>
<br><br>

작성일 : <%= dto.getCreatedAt() %>

<hr>

<div>
    <%= dto.getContent() %>
</div>

<hr>

<a href="list.jsp?channelId=<%= channelId %>">목록으로</a>

</body>
</html>
