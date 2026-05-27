<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardFileDAO, dto.BoardFileDTO, java.io.*" %>
<%
    int fileId = Integer.parseInt(request.getParameter("fileId"));
    BoardFileDAO fileDAO = new BoardFileDAO();
    BoardFileDTO fileDTO = fileDAO.getFile(fileId);

    if (fileDTO == null) { response.sendError(404); return; }

    String uploadDir = application.getRealPath("/uploads/board");
    File file = new File(uploadDir, fileDTO.getSavedName());
    if (!file.exists()) { response.sendError(404); return; }

    String encodedName = new String(fileDTO.getOriginalName().getBytes("UTF-8"), "ISO-8859-1");
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");
    response.setContentLengthLong(file.length());

    try (FileInputStream fis = new FileInputStream(file);
         OutputStream os = response.getOutputStream()) {  // out → os 로 변경
        byte[] buf = new byte[4096];
        int len;
        while ((len = fis.read(buf)) != -1) os.write(buf, 0, len);
    }
%>