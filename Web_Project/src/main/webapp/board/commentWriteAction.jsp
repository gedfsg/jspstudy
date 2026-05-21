<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.CommentDTO" %>
<%@ page import="dao.CommentDAO" %>
<%
    // 폼에서 넘어온 한글 데이터가 깨지지 않게 인코딩 처리
    request.setCharacterEncoding("UTF-8");

    // 넘어온 파라미터들 받기
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    int channelId = Integer.parseInt(request.getParameter("channelId"));
    String writerNick = request.getParameter("writerNick");
    String password = request.getParameter("password");
    String content = request.getParameter("content");

    // 세션에서 로그인 아이디 확인 (비로그인이면 null)
    dto.MemberDTO loginMember = (dto.MemberDTO) session.getAttribute("loginMember");
String memberId = null;

if (loginMember != null) {
    memberId = loginMember.getMemberId();
}

    // 비로그인 사용자용 IP 주소 추출
    String ipAddress = request.getRemoteAddr();

    // DTO 객체 만들어서 데이터 차곡차곡 담기
    CommentDTO comment = new CommentDTO();
    comment.setBoardId(boardId);
    comment.setWriterNick(writerNick);
    comment.setContent(content);
    comment.setMemberId(memberId);
    
    // 로그인을 안 한 사용자라면 비밀번호랑 IP 주소도 세팅
    if (memberId == null) {
        comment.setPassword(password);
        comment.setIpAddress(ipAddress);
    }

    // DAO 불러서 DB에 저장 시도
    CommentDAO dao = new CommentDAO();
    int result = dao.insertComment(comment);

    if (result > 0) {
        // 성공하면 원래 보던 게시글 상세 페이지로 새로고침하듯 이동
        response.sendRedirect("detail.jsp?boardId=" + boardId + "&channelId=" + channelId);
    } else {
        // 혹시라도 실패하면 알림창 띄우고 이전 페이지로 돌려보냄
        out.println("<script>");
        out.println("alert('댓글 작성에 실패했어.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>