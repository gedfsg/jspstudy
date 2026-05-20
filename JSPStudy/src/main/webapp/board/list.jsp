<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="java.util.List" %>
<%
    int channelId = Integer.parseInt(request.getParameter("channelId"));
    BoardDAO dao = new BoardDAO();
    List<BoardDTO> list = dao.selectBoardList(channelId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 목록</title>
</head>
<body>

<h1>게시글 목록</h1>

<a href="write.jsp?channelId=<%= channelId %>">글쓰기</a>

<hr>

<table border="1">
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>조회수</th>
        <th>작성일</th>
    </tr>
    <% for (BoardDTO dto : list) { %>
    <tr>
        <td><%= dto.getBoardId() %></td>
        <td>
            <a href="detail.jsp?boardId=<%= dto.getBoardId() %>&channelId=<%= channelId %>">
                <%= dto.getTitle() %>
            </a>
        </td>
        <td><%= dto.getWriterNick() %></td>
        <td><%= dto.getReadCount() %></td>
        <td><%= dto.getCreatedAt() %></td>
    </tr>
    <% } %>
</table>

</body>
</html>
