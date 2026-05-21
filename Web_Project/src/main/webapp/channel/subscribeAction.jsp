<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChannelDAO" %>
<%@ page import="dto.MemberDTO" %>
<%
    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
    if (loginMember == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }

    String action = request.getParameter("action");
    int channelId = Integer.parseInt(request.getParameter("channelId"));

    ChannelDAO dao = new ChannelDAO();
    if ("subscribe".equals(action)) {
        dao.subscribe(channelId, loginMember.getMemberId());
    } else if ("unsubscribe".equals(action)) {
        dao.unsubscribe(channelId, loginMember.getMemberId());
    }

    response.sendRedirect(request.getContextPath() + "/channel/channel.jsp?id=" + channelId);
%>
