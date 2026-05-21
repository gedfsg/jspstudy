package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import dto.BoardLikeDTO;
import util.DBUtil;

public class BoardLikeDAO {

    // 1. 이미 추천/비추천을 눌렀는지 확인하는 메서드
    public boolean checkAlreadyVoted(int boardId, String memberId) {
        String sql = "SELECT * FROM BOARD_LIKE WHERE BOARD_ID = ? AND MEMBER_ID = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, boardId);
            pstmt.setString(2, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return true; // 이미 투표한 기록이 있음
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // 기록 없음 (투표 가능)
    }

    // 2. 추천/비추천 추가 및 게시판 테이블 카운트 업데이트
    public int addVote(BoardLikeDTO dto) {
        int result = 0;
        String insertSql = "INSERT INTO BOARD_LIKE (BOARD_ID, MEMBER_ID, LIKE_TYPE) VALUES (?, ?, ?)";
        String updateBoardSql = "";
        
        if (dto.getLikeType() == 1) {
            updateBoardSql = "UPDATE BOARD SET LIKE_COUNT = LIKE_COUNT + 1 WHERE BOARD_ID = ?";
        } else {
            updateBoardSql = "UPDATE BOARD SET DISLIKE_COUNT = DISLIKE_COUNT + 1 WHERE BOARD_ID = ?";
        }

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            // 트랜잭션 시작 (두 쿼리가 모두 성공해야만 반영)
            conn.setAutoCommit(false); 

            // 1) BOARD_LIKE 테이블에 기록 추가
            try (PreparedStatement pstmt1 = conn.prepareStatement(insertSql)) {
                pstmt1.setInt(1, dto.getBoardId());
                pstmt1.setString(2, dto.getMemberId());
                pstmt1.setInt(3, dto.getLikeType());
                pstmt1.executeUpdate();
            }

            // 2) BOARD 테이블의 총 카운트 증가
            try (PreparedStatement pstmt2 = conn.prepareStatement(updateBoardSql)) {
                pstmt2.setInt(1, dto.getBoardId());
                result = pstmt2.executeUpdate();
            }

            // 오류 없이 끝났다면 커밋
            conn.commit(); 
        } catch (Exception e) {
            try {
                // 중간에 하나라도 실패하면 롤백해서 원래 상태로 복구
                if (conn != null) conn.rollback(); 
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
}