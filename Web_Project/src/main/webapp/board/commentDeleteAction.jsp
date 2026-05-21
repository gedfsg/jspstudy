<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="dto.CommentDTO" %>
<%@ page import="dto.MemberDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    int commentId = Integer.parseInt(request.getParameter("commentId"));
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    int channelId = Integer.parseInt(request.getParameter("channelId"));
    String inputPassword = request.getParameter("password");

    // 세션에서 로그인 정보 꼼꼼하게 챙기기
    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
    String loginId = null;
    if (loginMember != null) {
        loginId = loginMember.getMemberId();
    }

    CommentDAO dao = new CommentDAO();
    // 방금 만든 메서드로 삭제하려는 댓글의 원래 정보를 불러와
    CommentDTO comment = dao.getComment(commentId);

    boolean canDelete = false;

    if (comment != null) {
        // 1. 로그인한 유저가 작성한 댓글인 경우 (아이디 일치 확인)
        if (comment.getMemberId() != null && comment.getMemberId().equals(loginId)) {
            canDelete = true;
        }
        // 2. 비로그인 유저가 작성한 댓글인 경우 (비밀번호 일치 확인)
        else if (comment.getMemberId() == null && comment.getPassword() != null && comment.getPassword().equals(inputPassword)) {
            canDelete = true;
        }
    }

    // 권한이 확인되면 삭제 실행
    if (canDelete) {
        int result = dao.deleteComment(commentId);
        if (result > 0) {
            // 삭제 성공 시 다시 댓글이 있던 게시글 상세 페이지로 새로고침
            response.sendRedirect("detail.jsp?boardId=" + boardId + "&channelId=" + channelId);
        } else {
            out.println("<script>alert('댓글 삭제 과정에서 DB 오류가 발생했어.'); history.back();</script>");
        }
    } else {
        // 남의 댓글이거나 비밀번호가 틀렸을 때 차단
        out.println("<script>alert('삭제 권한이 없거나 비밀번호가 틀렸어.'); history.back();</script>");
    }
%>