<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="java.util.List" %>
<%
    int channelId = Integer.parseInt(request.getParameter("channelId"));
    String searchType = request.getParameter("searchType");
    String keyword = request.getParameter("keyword");

    BoardDAO dao = new BoardDAO();
    List<BoardDTO> list = null;

    // 검색 파라미터가 있으면 검색 메서드 실행, 없으면 전체 목록 실행
    if (keyword != null && !keyword.trim().isEmpty() && searchType != null) {
        list = dao.searchBoardsInChannel(channelId, searchType, keyword);
    } else {
        list = dao.selectBoardList(channelId);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 목록</title>
</head>
<body>

<h1>게시글 목록</h1>

<a href="<%= request.getContextPath() %>/board/write.jsp?channelId=<%= channelId %>">글쓰기</a>

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
            <a href="<%= request.getContextPath() %>/board/detail.jsp?boardId=<%= dto.getBoardId() %>&channelId=<%= channelId %>">
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