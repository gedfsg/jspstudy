<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dao.BoardFileDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="dto.BoardFileDTO" %>
<%@ page import="dto.MemberDTO" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");

    String channelIdStr = request.getParameter("channelId");
    if (channelIdStr == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    int channelId = Integer.parseInt(channelIdStr);
    String title   = request.getParameter("title");
    String content = request.getParameter("content");
    String writerNick    = request.getParameter("writerNick");
    String boardPassword = request.getParameter("boardPassword");

    BoardDTO dto = new BoardDTO();
    dto.setChannelId(channelId);
    dto.setTitle(title);
    dto.setContent(content);
    dto.setWriterIp(request.getRemoteAddr());

    if (loginMember == null) {
        dto.setWriterNick(writerNick);
        dto.setBoardPassword(boardPassword);
    } else {
        dto.setMemberId(loginMember.getMemberId());
        dto.setWriterNick(loginMember.getNickname());
    }

    BoardDAO boardDAO = new BoardDAO();
    int boardId = boardDAO.insertBoardReturnId(dto);

    if (boardId <= 0) {
        response.sendRedirect(request.getContextPath() + "/board/write.jsp?channelId=" + channelId);
        return;
    }

    // 파일 저장 (Part 사용)
    Collection<Part> parts = request.getParts();
    if (parts != null && !parts.isEmpty()) {
        String uploadDir = application.getRealPath("/uploads/board");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        BoardFileDAO fileDAO = new BoardFileDAO();
        int fileCount = 0;

        for (Part part : parts) {
            if (!"uploadFiles".equals(part.getName())) continue;
            if (part.getSize() <= 0) continue;
            if (fileCount >= 5) break;

            // 원본 파일명 추출
            String header = part.getHeader("content-disposition");
            String originalName = "";
            for (String token : header.split(";")) {
                if (token.trim().startsWith("filename")) {
                    originalName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
            if (originalName.isEmpty()) continue;

            // UUID로 저장 파일명 생성
            String ext = "";
            int dotIdx = originalName.lastIndexOf(".");
            if (dotIdx >= 0) ext = originalName.substring(dotIdx);
            String savedName = UUID.randomUUID().toString() + ext;

            part.write(uploadDir + File.separator + savedName);

            BoardFileDTO fileDTO = new BoardFileDTO();
            fileDTO.setBoardId(boardId);
            fileDTO.setOriginalName(originalName);
            fileDTO.setSavedName(savedName);
            fileDTO.setFileSize(part.getSize());
            fileDAO.insertFile(fileDTO);
            fileCount++;
        }
    }

    response.sendRedirect(request.getContextPath() + "/channel/channel.jsp?id=" + channelId);
%>