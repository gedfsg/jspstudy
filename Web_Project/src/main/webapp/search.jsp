<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dao.ChannelDAO" %>
<%@ page import="dto.ChannelDTO" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");

    List<ChannelDTO> channelList = null;
    List<BoardDTO> boardList = null;

    if (keyword != null && !keyword.trim().isEmpty()) {
        ChannelDAO channelDAO = new ChannelDAO();
        channelList = channelDAO.searchChannels(keyword);

        BoardDAO boardDAO = new BoardDAO();
        boardList = boardDAO.searchBoards(keyword);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>검색 결과</title>
</head>
<body>
    <h2>'<%= keyword != null ? keyword : "" %>' 검색 결과</h2>
    <hr>

    <h3>채널 검색 결과</h3>
    <ul>
    <%
        if (channelList != null && !channelList.isEmpty()) {
            for (ChannelDTO channel : channelList) {
    %>
        <li>
            <a href="channel/channel.jsp?channelId=<%= channel.getChannelId() %>">
                <strong><%= channel.getChannelName() %></strong>
            </a> 
            - <%= channel.getDescription() %>
        </li>
    <%
            }
        } else {
    %>
        <li>일치하는 채널이 없습니다.</li>
    <%
        }
    %>
    </ul>

    <hr>

    <h3>게시글 검색 결과</h3>
    <ul>
    <%
        if (boardList != null && !boardList.isEmpty()) {
            for (BoardDTO board : boardList) {
    %>
        <li>
            <a href="board/detail.jsp?boardId=<%= board.getBoardId() %>&channelId=<%= board.getChannelId() %>">
    			<strong><%= board.getTitle() %></strong>
			</a>
            [조회수: <%= board.getReadCount() %>] | <%= board.getCreatedAt() %> | <%= board.getWriterNick() %>
        </li>
    <%
            }
        } else {
    %>
        <li>일치하는 게시글이 없습니다.</li>
    <%
        }
    %>
    </ul>
</body>
</html>