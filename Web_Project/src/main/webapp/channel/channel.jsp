<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChannelDAO" %>
<%@ page import="dto.ChannelDTO" %>
<%@ page import="dto.MemberDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    // index.jsp에서 넘어오는 'id' 파라미터 받기
    String idParam = request.getParameter("id");
    
    // 검색 폼에서 자기 자신으로 전송할 때 폼 안의 name="id" 값을 받음
    if (idParam == null || idParam.trim().isEmpty()) {
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

    boolean isSubscribed = false;
    if (loginMember != null) {
        isSubscribed = dao.isSubscribed(channelId, loginMember.getMemberId());
    }
    
    // 검색용 파라미터 받기
    String searchType = request.getParameter("searchType");
    String keyword = request.getParameter("keyword");
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

<%-- 채널 내부 검색 폼 영역 --%>
<div style="text-align: center; margin-bottom: 20px;">
    <form action="channel.jsp" method="GET">
        <input type="hidden" name="id" value="<%= channelId %>">
        
        <select name="searchType">
            <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>제목</option>
            <option value="title_content" <%= "title_content".equals(searchType) ? "selected" : "" %>>제목 + 내용</option>
            <option value="writer" <%= "writer".equals(searchType) ? "selected" : "" %>>작성자</option>
        </select>
        
        <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="<%= keyword != null ? keyword : "" %>">
        <button type="submit">검색</button>
    </form>
</div>

<%-- 게시글 목록으로 이동 (board/list.jsp 재사용) --%>
<jsp:include page="/board/list.jsp">
    <jsp:param name="channelId" value="<%= channelId %>"/>
    <jsp:param name="searchType" value="<%= searchType != null ? searchType : \"\" %>"/>
    <jsp:param name="keyword" value="<%= keyword != null ? keyword : \"\" %>"/>
</jsp:include>

</body>
</html>