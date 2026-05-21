<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="dto.MemberDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");

    int channelId = Integer.parseInt(request.getParameter("channelId"));

    BoardDTO dto = new BoardDTO();
    dto.setChannelId(channelId);
    dto.setTitle(request.getParameter("title"));
    dto.setContent(request.getParameter("content"));
    dto.setWriterIp(request.getRemoteAddr());

    if (loginMember == null) {
        dto.setWriterNick(request.getParameter("writerNick"));
        dto.setBoardPassword(request.getParameter("boardPassword"));
    } else {
        dto.setMemberId(loginMember.getMemberId());
        dto.setWriterNick(loginMember.getNickname());
    }

    BoardDAO dao = new BoardDAO();
    int result = dao.insertBoard(dto);

    if (result > 0) {
        response.sendRedirect(request.getContextPath() + "/channel/channel.jsp?id=" + channelId);
    } else {
        response.sendRedirect(request.getContextPath() + "/board/write.jsp?channelId=" + channelId);
    }
%>
