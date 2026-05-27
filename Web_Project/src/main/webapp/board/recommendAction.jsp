<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.BoardLikeDAO" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.MemberDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
    
    String boardIdStr = request.getParameter("boardId");
    String channelIdStr = request.getParameter("channelId");
    String typeStr = request.getParameter("type"); 

    if (loginMember == null) {
        out.println("<script>alert('로그인이 필요한 기능입니다.'); history.back();</script>");
        return;
    }

    if (boardIdStr != null && typeStr != null) {
        int boardId = Integer.parseInt(boardIdStr);
        int likeType = Integer.parseInt(typeStr);
        String memberId = loginMember.getMemberId();

        BoardLikeDAO likeDAO = new BoardLikeDAO();
        boolean success = likeDAO.processLike(boardId, memberId, likeType);

        if (success) {
            // [수정 포인트] 여기서 DB의 추천수 카운트를 업데이트해줘야 함!
            BoardDAO boardDAO = new BoardDAO();
            boardDAO.updateBoardLikeCounts(boardId); 
            
            response.sendRedirect("detail.jsp?boardId=" + boardId + "&channelId=" + channelIdStr);
        } else {
            out.println("<script>alert('이미 평가하셨습니다.'); history.back();</script>");
        }
    }
%>