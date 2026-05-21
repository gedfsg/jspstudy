<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChannelDAO" %>
<%@ page import="dto.ChannelDTO" %>
<%@ page import="dto.MemberDTO" %>
<%
    // 채널 ID 파라미터 확인
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    int channelId = Integer.parseInt(idParam);

    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");

    ChannelDAO dao = new ChannelDAO();
    ChannelDTO channel = dao.getChannelById(channelId);

    if (channel == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 구독 여부 확인
    boolean isSubscribed = false;
    if (loginMember != null) {
        isSubscribed = dao.isSubscribed(channelId, loginMember.getMemberId());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= channel.getChannelName() %></title>
</head>
<body>

<%-- 상단 네비게이션 --%>
<div>
    <strong><a href="<%= request.getContextPath() %>/index.jsp">커뮤니티</a></strong>
    <span style="float:right;">
        <% if (loginMember != null) { %>
            <span><%= loginMember.getNickname() %>님</span>
            <a href="<%= request.getContextPath() %>/channel/channelCreate.jsp">채널 생성</a>
            <a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/member/login.jsp">로그인</a>
            <a href="<%= request.getContextPath() %>/member/join.jsp">회원가입</a>
        <% } %>
    </span>
</div>

<hr>

<%-- 채널 정보 --%>
<h2><%= channel.getChannelName() %></h2>
<p><%= channel.getDescription() != null ? channel.getDescription() : "" %></p>
<small style="color:gray;">개설자: <%= channel.getOwnerId() %></small>

<%-- 구독 버튼 --%>
<% if (loginMember != null) { %>
    <% if (isSubscribed) { %>
        <a href="<%= request.getContextPath() %>/channel/subscribeAction.jsp?action=unsubscribe&channelId=<%= channelId %>">
            <button>구독 취소</button>
        </a>
    <% } else { %>
        <a href="<%= request.getContextPath() %>/channel/subscribeAction.jsp?action=subscribe&channelId=<%= channelId %>">
            <button>구독</button>
        </a>
    <% } %>
<% } %>

<hr>

<%-- 게시글 목록으로 이동 (board/list.jsp 재사용) --%>
<jsp:include page="/board/list.jsp">
    <jsp:param name="channelId" value="<%= channelId %>"/>
</jsp:include>

</body>
</html>
