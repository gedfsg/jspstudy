<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="dto.CommentDTO" %>
<%@ page import="dao.BoardFileDAO" %>       <%-- 추가 --%>
<%@ page import="dto.BoardFileDTO" %>       <%-- 추가 --%>
<%@ page import="java.util.List" %>
<%
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    int channelId = Integer.parseInt(request.getParameter("channelId"));

    BoardDAO dao = new BoardDAO();
    BoardDTO dto = dao.selectBoard(boardId);

    CommentDAO commentDAO = new CommentDAO();
    List<CommentDTO> commentList = commentDAO.getCommentList(boardId);

    BoardFileDAO fileDAO = new BoardFileDAO();           // 추가
    List<BoardFileDTO> fileList = fileDAO.getFileList(boardId);  // 추가

    dto.MemberDTO loginMember = (dto.MemberDTO) session.getAttribute("loginMember");
    String loginId = null;
    String loginNick = null;

    if (loginMember != null) {
        loginId = loginMember.getMemberId();
        loginNick = loginMember.getNickname();
    }
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

<%-- ↓ 첨부파일 영역 추가 --%>
<% if (fileList != null && !fileList.isEmpty()) { %>
<hr>
<div style="margin: 15px 0;">
    <strong>첨부파일</strong>
    <ul style="list-style: none; padding: 0;">
    <% for (BoardFileDTO f : fileList) { %>
        <li style="margin: 8px 0;">
            <% if (f.isImage()) { %>
                <img src="<%= request.getContextPath() %>/uploads/board/<%= f.getSavedName() %>"
                     alt="<%= f.getOriginalName() %>"
                     style="max-width: 600px; max-height: 400px; display: block; margin-bottom: 4px;">
            <% } %>
            <a href="<%= request.getContextPath() %>/board/fileDownload.jsp?fileId=<%= f.getFileId() %>">
                📎 <%= f.getOriginalName() %>
            </a>
            <span style="font-size: 0.8em; color: gray;">
                (<%= String.format("%.1f", f.getFileSize() / 1024.0) %> KB)
            </span>
        </li>
    <% } %>
    </ul>
</div>
<% } %>
<%-- ↑ 여기까지 추가 --%>

<hr>

<div style="text-align: center; margin: 20px 0;">
    <a href="recommendAction.jsp?boardId=<%= dto.getBoardId() %>&channelId=<%= channelId %>&type=1">
        <button style="color: blue;">
            👍 추천 <%= dto.getRecommendCount() %>
        </button>
    </a>
    
    <a href="recommendAction.jsp?boardId=<%= dto.getBoardId() %>&channelId=<%= channelId %>&type=2">
        <button style="color: red;">
            👎 비추천 <%= dto.getUnrecommendCount() %>
        </button>
    </a>
</div>

<div class="comment-list">
    <h3>댓글</h3>
    <%
        for(CommentDTO comment : commentList) {
    %>
        <div style="border-bottom: 1px solid #ddd; margin-bottom: 10px; padding-bottom: 10px;">
            <strong><%= comment.getWriterNick() %></strong>
            
            <% if(comment.getMemberId() == null) { %>
                <span style="font-size: 0.8em; color: gray;">(<%= comment.getIpAddress() %>)</span>
            <% } %>
            
            <span style="font-size: 0.8em; color: gray; margin-left: 10px;"><%= comment.getCreatedAt() %></span>
            
            <p style="margin: 5px 0;"><%= comment.getContent() %></p>
            
            <form action="commentDeleteAction.jsp" method="post" style="display:inline;">
                <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>">
                <input type="hidden" name="boardId" value="<%= boardId %>">
                <input type="hidden" name="channelId" value="<%= channelId %>">
                
                <% if(comment.getMemberId() == null) { %>
                    <input type="password" name="password" placeholder="비밀번호" required style="width:80px;">
                <% } %>
                <button type="submit" style="font-size: 0.8em;">삭제</button>
            </form>
        </div>
    <%
        }
    %>
</div>

<div class="comment-write" style="margin-top: 20px;">
    <form action="commentWriteAction.jsp" method="post">
        <input type="hidden" name="boardId" value="<%= boardId %>">
        <input type="hidden" name="channelId" value="<%= channelId %>">
        
        <% if(loginId != null) { %>
            <div style="margin-bottom: 10px;">
                작성자: <strong><%= loginNick %></strong>
                <input type="hidden" name="writerNick" value="<%= loginNick %>">
            </div>
        <% } else { %>
            <div style="margin-bottom: 10px;">
                닉네임: <input type="text" name="writerNick" required style="width: 100px; margin-right: 10px;">
                비밀번호: <input type="password" name="password" required style="width: 100px;">
            </div>
        <% } %>
        
        <div>
            <textarea name="content" rows="3" style="width: 100%;" placeholder="댓글을 남겨보세요" required></textarea>
        </div>
        <button type="submit" style="margin-top: 5px;">댓글 등록</button>
    </form>
</div>

<hr>

<a href="<%= request.getContextPath() %>/channel/channel.jsp?id=<%= channelId %>">목록으로</a>

</body>
</html>