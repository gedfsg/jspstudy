<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChannelDAO" %>
<%@ page import="dto.ChannelDTO" %>
<%@ page import="dto.MemberDTO" %>
<%@ page import="java.util.List" %>
<%
    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
    String created = request.getParameter("created");

    List<ChannelDTO> channelList = null;
    List<ChannelDTO> subscribedList = null;
    try {
        ChannelDAO dao = new ChannelDAO();
        channelList = dao.getAllChannels();
        if (loginMember != null) {
            subscribedList = dao.getSubscribedChannels(loginMember.getMemberId());
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티</title>
</head>
<body>
<div class="search-container">
    <form action="search.jsp" method="GET">
        <input type="text" name="keyword" placeholder="채널이나 게시글 검색" required>
        <button type="submit">검색</button>
    </form>
</div>

<%-- 상단 네비게이션 --%>
<div>
    <strong>커뮤니티</strong>
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

<%-- 채널 생성 성공 메시지 --%>
<% if ("1".equals(created)) { %>
    <p style="color:green;">채널이 생성되었습니다!</p>
<% } %>

<%-- 내 구독 채널 (로그인 시만) --%>
<% if (loginMember != null && subscribedList != null && !subscribedList.isEmpty()) { %>
    <h3>내 구독 채널</h3>
    <ul>
        <% for (ChannelDTO c : subscribedList) { %>
            <li>
                <a href="<%= request.getContextPath() %>/channel/channel.jsp?id=<%= c.getChannelId() %>">
                    <%= c.getChannelName() %>
                </a>
                <small><%= c.getDescription() != null ? c.getDescription() : "" %></small>
            </li>
        <% } %>
    </ul>
    <hr>
<% } %>

<%-- 전체 채널 목록 --%>
<h3>전체 채널</h3>
<% if (channelList == null || channelList.isEmpty()) { %>
    <p>아직 채널이 없습니다. 첫 번째 채널을 만들어보세요!</p>
<% } else { %>
    <ul>
        <% for (ChannelDTO c : channelList) { %>
            <li>
                <a href="<%= request.getContextPath() %>/channel/channel.jsp?id=<%= c.getChannelId() %>">
                    <%= c.getChannelName() %>
                </a>
                <small><%= c.getDescription() != null ? c.getDescription() : "" %></small>
                <small style="color:gray;">개설자: <%= c.getOwnerId() %></small>
            </li>
        <% } %>
    </ul>
<% } %>

</body>
</html>