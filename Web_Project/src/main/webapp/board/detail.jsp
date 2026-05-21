<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="dto.CommentDTO" %>
<%@ page import="java.util.List" %>
<%
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    int channelId = Integer.parseInt(request.getParameter("channelId"));

    BoardDAO dao = new BoardDAO();
    BoardDTO dto = dao.selectBoard(boardId);

    CommentDAO commentDAO = new CommentDAO();
    List<CommentDTO> commentList = commentDAO.getCommentList(boardId);
    
    // 기존에 작성한 loginId, loginNick 선언 코드를 지우고 이 내용으로 교체해줘
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

<hr>

<div class="comment-list">
    <h3>댓글</h3>
    <%
        for(CommentDTO comment : commentList) {
    %>
        <div style="border-bottom: 1px solid #ddd; margin-bottom: 10px; padding-bottom: 10px;">
            <strong><%= comment.getWriterNick() %></strong>
            
            <%-- 비로그인 사용자라면 IP 주소 노출 --%>
            <% if(comment.getMemberId() == null) { %>
                <span style="font-size: 0.8em; color: gray;">(<%= comment.getIpAddress() %>)</span>
            <% } %>
            
            <span style="font-size: 0.8em; color: gray; margin-left: 10px;"><%= comment.getCreatedAt() %></span>
            
            <p style="margin: 5px 0;"><%= comment.getContent() %></p>
            
            <%-- 삭제 버튼 영역 --%>
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

<a href="list.jsp?channelId=<%= channelId %>">목록으로</a>

</body>
</html>