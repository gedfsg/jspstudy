package dao;

import dto.BoardFileDTO;
import util.DBUtil;
import java.sql.*;
import java.util.*;

public class BoardFileDAO {

    public int insertFile(BoardFileDTO dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "INSERT INTO BOARD_FILE (FILE_ID, BOARD_ID, ORIGINAL_NAME, SAVED_NAME, FILE_SIZE) "
                   + "VALUES (SEQ_BOARD_FILE.NEXTVAL, ?, ?, ?, ?)";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getBoardId());
            pstmt.setString(2, dto.getOriginalName());
            pstmt.setString(3, dto.getSavedName());
            pstmt.setLong(4, dto.getFileSize());
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return result;
    }

    public List<BoardFileDTO> getFileList(int boardId) {
        List<BoardFileDTO> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT * FROM BOARD_FILE WHERE BOARD_ID = ? ORDER BY FILE_ID ASC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                BoardFileDTO dto = new BoardFileDTO();
                dto.setFileId(rs.getInt("FILE_ID"));
                dto.setBoardId(rs.getInt("BOARD_ID"));
                dto.setOriginalName(rs.getString("ORIGINAL_NAME"));
                dto.setSavedName(rs.getString("SAVED_NAME"));
                dto.setFileSize(rs.getLong("FILE_SIZE"));
                dto.setCreatedAt(rs.getDate("CREATED_AT"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }

    public BoardFileDTO getFile(int fileId) {
        BoardFileDTO dto = null;
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT * FROM BOARD_FILE WHERE FILE_ID = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, fileId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new BoardFileDTO();
                dto.setFileId(rs.getInt("FILE_ID"));
                dto.setBoardId(rs.getInt("BOARD_ID"));
                dto.setOriginalName(rs.getString("ORIGINAL_NAME"));
                dto.setSavedName(rs.getString("SAVED_NAME"));
                dto.setFileSize(rs.getLong("FILE_SIZE"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return dto;
    }
}