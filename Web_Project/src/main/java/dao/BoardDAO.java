package dao;

import dto.BoardDTO;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

    public int insertBoard(BoardDTO dto) {

        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        String sql = """
            INSERT INTO BOARD (
                BOARD_ID,
                CHANNEL_ID,
                TITLE,
                CONTENT,
                MEMBER_ID,
                WRITER_NICK,
                WRITER_IP,
                BOARD_PASSWORD
            )
            VALUES (
                SEQ_BOARD.NEXTVAL,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?
            )
        """;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getChannelId());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getMemberId());
            pstmt.setString(5, dto.getWriterNick());
            pstmt.setString(6, dto.getWriterIp());
            pstmt.setString(7, dto.getBoardPassword());
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public List<BoardDTO> selectBoardList(int channelId) {

        List<BoardDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = """
            SELECT *
            FROM BOARD
            WHERE CHANNEL_ID = ?
            ORDER BY BOARD_ID DESC
        """;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, channelId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardDTO dto = new BoardDTO();
                dto.setBoardId(rs.getInt("BOARD_ID"));
                dto.setChannelId(rs.getInt("CHANNEL_ID"));
                dto.setTitle(rs.getString("TITLE"));
                dto.setWriterNick(rs.getString("WRITER_NICK"));
                dto.setCreatedAt(rs.getDate("CREATED_AT"));
                dto.setReadCount(rs.getInt("READ_COUNT"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    public BoardDTO selectBoard(int boardId) {

        BoardDTO dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = """
            SELECT *
            FROM BOARD
            WHERE BOARD_ID = ?
        """;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BoardDTO();
                dto.setBoardId(rs.getInt("BOARD_ID"));
                dto.setChannelId(rs.getInt("CHANNEL_ID"));
                dto.setTitle(rs.getString("TITLE"));
                dto.setContent(rs.getString("CONTENT"));
                dto.setWriterNick(rs.getString("WRITER_NICK"));
                dto.setCreatedAt(rs.getDate("CREATED_AT"));
                dto.setReadCount(rs.getInt("READ_COUNT"));
                dto.setRecommendCount(rs.getInt("RECOMMEND_COUNT"));
                dto.setUnrecommendCount(rs.getInt("UNRECOMMEND_COUNT"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return dto;
    }
    
    public List<BoardDTO> searchBoards(String keyword) {
        List<BoardDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BOARD WHERE TITLE LIKE '%'||?||'%' OR CONTENT LIKE '%'||?||'%' ORDER BY BOARD_ID DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, keyword);
            pstmt.setString(2, keyword);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardDTO board = new BoardDTO();
                board.setBoardId(rs.getInt("BOARD_ID"));
                board.setChannelId(rs.getInt("CHANNEL_ID"));
                board.setTitle(rs.getString("TITLE"));
                board.setWriterNick(rs.getString("WRITER_NICK"));
                board.setReadCount(rs.getInt("READ_COUNT"));
                list.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }
    
    public List<BoardDTO> searchBoardsInChannel(int channelId, String searchType, String keyword) {
        List<BoardDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM BOARD WHERE CHANNEL_ID = ? ";

        if ("title".equals(searchType)) {
            sql += "AND TITLE LIKE '%'||?||'%' ";
        } else if ("title_content".equals(searchType)) {
            sql += "AND (TITLE LIKE '%'||?||'%' OR CONTENT LIKE '%'||?||'%') ";
        } else if ("writer".equals(searchType)) {
            sql += "AND WRITER_NICK LIKE '%'||?||'%' ";
        }
        
        sql += "ORDER BY BOARD_ID DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, channelId);

            if ("title_content".equals(searchType)) {
                pstmt.setString(2, keyword);
                pstmt.setString(3, keyword);
            } else {
                pstmt.setString(2, keyword);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardDTO board = new BoardDTO();
                board.setBoardId(rs.getInt("BOARD_ID"));
                board.setChannelId(rs.getInt("CHANNEL_ID"));
                board.setTitle(rs.getString("TITLE"));
                board.setWriterNick(rs.getString("WRITER_NICK"));
                board.setReadCount(rs.getInt("READ_COUNT"));
                list.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }
    
    public List<BoardDTO> getBoardsByChannel(int channelId) {
        List<BoardDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM BOARD WHERE CHANNEL_ID = ? ORDER BY BOARD_ID DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, channelId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardDTO board = new BoardDTO();
                board.setBoardId(rs.getInt("BOARD_ID"));
                board.setChannelId(rs.getInt("CHANNEL_ID"));
                board.setTitle(rs.getString("TITLE"));
                board.setWriterNick(rs.getString("WRITER_NICK"));
                board.setReadCount(rs.getInt("READ_COUNT"));
                board.setCreatedAt(rs.getDate("CREATED_AT"));
                list.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }
    
    public void updateBoardLikeCounts(int boardId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = """
            UPDATE BOARD 
            SET 
                RECOMMEND_COUNT = (SELECT COUNT(*) FROM BOARD_LIKE WHERE BOARD_ID = ? AND LIKE_TYPE = 1),
                UNRECOMMEND_COUNT = (SELECT COUNT(*) FROM BOARD_LIKE WHERE BOARD_ID = ? AND LIKE_TYPE = 2)
            WHERE BOARD_ID = ?
        """;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardId);
            pstmt.setInt(2, boardId);
            pstmt.setInt(3, boardId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}