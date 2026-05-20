<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChannelDAO" %>
<%@ page import="dto.ChannelDTO" %>
<%@ page import="dto.MemberDTO" %>
<%
    // 비로그인 차단
    if (session.getAttribute("loginMember") == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String channelName  = request.getParameter("channelName");
    String description  = request.getParameter("description");
    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
    String ownerId = loginMember.getMemberId();

    String errorMsg = null;

    if (channelName == null || channelName.trim().isEmpty()) {
        errorMsg = "채널 이름을 입력해주세요.";
    }

    if (errorMsg == null) {
        try {
            ChannelDAO dao = new ChannelDAO();
            if (dao.isNameDuplicate(channelName)) {
                errorMsg = "이미 존재하는 채널 이름입니다.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "서버 오류가 발생했습니다.";
        }
    }

    if (errorMsg != null) {
        request.setAttribute("errorMsg", errorMsg);
        request.setAttribute("oldName", channelName);
        request.setAttribute("oldDesc", description);
        request.getRequestDispatcher("channelCreate.jsp").forward(request, response);
        return;
    }

    try {
        ChannelDAO dao = new ChannelDAO();
        ChannelDTO channel = new ChannelDTO(channelName, description, ownerId);
        dao.createChannel(channel);
        response.sendRedirect(request.getContextPath() + "/index.jsp?created=1");
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMsg", "채널 생성 중 오류가 발생했습니다.");
        request.setAttribute("oldName", channelName);
        request.setAttribute("oldDesc", description);
        request.getRequestDispatcher("channelCreate.jsp").forward(request, response);
    }
%>