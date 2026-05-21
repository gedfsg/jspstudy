package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import dto.CommentDTO;
import util.DBUtil;

public class CommentDAO {

    // 1. 댓글 작성
    public int insertComment(CommentDTO comment) {
        String sql = "INSERT INTO BOARD_COMMENT (COMMENT_ID, BOARD_ID, MEMBER_ID, WRITER_NICK, PASSWORD, CONTENT, IP_ADDRESS) "
                   + "VALUES (COMMENT_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, comment.getBoardId());
            pstmt.setString(2, comment.getMemberId());
            pstmt.setString(3, comment.getWriterNick());
            pstmt.setString(4, comment.getPassword());
            pstmt.setString(5, comment.getContent());
            pstmt.setString(6, comment.getIpAddress());
            
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // 2. 특정 게시글의 댓글 목록 조회 (작성일 오름차순)
    public List<CommentDTO> getCommentList(int boardId) {
        List<CommentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM BOARD_COMMENT WHERE BOARD_ID = ? ORDER BY CREATED_AT ASC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, boardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CommentDTO comment = new CommentDTO();
                    comment.setCommentId(rs.getInt("COMMENT_ID"));
                    comment.setBoardId(rs.getInt("BOARD_ID"));
                    comment.setMemberId(rs.getString("MEMBER_ID"));
                    comment.setWriterNick(rs.getString("WRITER_NICK"));
                    comment.setPassword(rs.getString("PASSWORD"));
                    comment.setContent(rs.getString("CONTENT"));
                    comment.setIpAddress(rs.getString("IP_ADDRESS"));
                    comment.setCreatedAt(rs.getDate("CREATED_AT"));
                    list.add(comment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. 댓글 삭제
    public int deleteComment(int commentId) {
        String sql = "DELETE FROM BOARD_COMMENT WHERE COMMENT_ID = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, commentId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
    
 // 4. 특정 댓글 1개 가져오기 (권한 및 비밀번호 확인용)
    public CommentDTO getComment(int commentId) {
        CommentDTO comment = null;
        String sql = "SELECT * FROM BOARD_COMMENT WHERE COMMENT_ID = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, commentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    comment = new CommentDTO();
                    comment.setCommentId(rs.getInt("COMMENT_ID"));
                    comment.setBoardId(rs.getInt("BOARD_ID"));
                    comment.setMemberId(rs.getString("MEMBER_ID"));
                    comment.setWriterNick(rs.getString("WRITER_NICK"));
                    comment.setPassword(rs.getString("PASSWORD"));
                    comment.setContent(rs.getString("CONTENT"));
                    comment.setIpAddress(rs.getString("IP_ADDRESS"));
                    comment.setCreatedAt(rs.getDate("CREATED_AT"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return comment;
    }
}