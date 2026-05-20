<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%
request.setCharacterEncoding("UTF-8");

String loginId =
    (String)session.getAttribute("loginId");

String loginNick =
    (String)session.getAttribute("loginNick");

BoardDTO dto = new BoardDTO();

dto.setChannelNo(
    Integer.parseInt(
        request.getParameter("channelNo")
    )
);

dto.setTitle(request.getParameter("title"));
dto.setContent(request.getParameter("content"));

BoardDAO dao = new BoardDAO();

int result = dao.insertBoard(dto);

if(loginId == null){

    dto.setWriterNick(
        request.getParameter("writerNick")
    );

    dto.setBoardPassword(
        request.getParameter("boardPassword")
    );

}else{

    dto.setMemberId(loginId);

    dto.setWriterNick(loginNick);

}