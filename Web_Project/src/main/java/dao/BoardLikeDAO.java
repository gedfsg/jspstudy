package dao;

import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BoardLikeDAO {

	public boolean processLike(int boardId, String memberId, int likeType) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    boolean isSuccess = false;

	    try {
	        conn = DBUtil.getConnection();
	        
	        // 1. 이미 기록이 있는지 확인
	        String checkSql = "SELECT count(*) FROM BOARD_LIKE WHERE BOARD_ID = ? AND MEMBER_ID = ?";
	        pstmt = conn.prepareStatement(checkSql);
	        pstmt.setInt(1, boardId);
	        pstmt.setString(2, memberId);
	        rs = pstmt.executeQuery();

	        if (rs.next() && rs.getInt(1) > 0) {
	            // 이미 기록이 있다면 아무것도 하지 않고 종료 (이미 눌렀음)
	            isSuccess = false;
	        } else {
	            // 2. 기록이 없을 때만 새로 추가 (INSERT)
	            pstmt.close();
	            String insertSql = "INSERT INTO BOARD_LIKE (BOARD_ID, MEMBER_ID, LIKE_TYPE) VALUES (?, ?, ?)";
	            pstmt = conn.prepareStatement(insertSql);
	            pstmt.setInt(1, boardId);
	            pstmt.setString(2, memberId);
	            pstmt.setInt(3, likeType);
	            pstmt.executeUpdate();
	            isSuccess = true;
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
	    return isSuccess;
	}
}