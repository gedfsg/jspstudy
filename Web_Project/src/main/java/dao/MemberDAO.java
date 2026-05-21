package dao;

import dto.MemberDTO;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MemberDAO {

    // 1. 아이디 중복 확인
    public boolean isIdDuplicate(String memberId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM MEMBER WHERE MEMBER_ID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn  = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return false;
    }

    // 2. 닉네임 중복 확인
    public boolean isNicknameDuplicate(String nickname) throws SQLException {
        String sql = "SELECT COUNT(*) FROM MEMBER WHERE NICKNAME = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn  = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname);
            rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return false;
    }

    // 3. 회원가입
    public int join(MemberDTO member) throws SQLException {
        String sql = "INSERT INTO MEMBER (MEMBER_ID, PASSWORD, NICKNAME, EMAIL) "
                   + "VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn  = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, member.getMemberId());
            pstmt.setString(2, member.getPassword());
            pstmt.setString(3, member.getNickname());
            pstmt.setString(4, member.getEmail());
            return pstmt.executeUpdate();
        } finally {
            DBUtil.close(pstmt, conn);
        }
    }

    // 4. 로그인
    public MemberDTO login(String memberId, String password) throws SQLException {
        String sql = "SELECT * FROM MEMBER WHERE MEMBER_ID = ? AND PASSWORD = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn  = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                MemberDTO member = new MemberDTO();
                member.setMemberId(rs.getString("MEMBER_ID"));
                member.setNickname(rs.getString("NICKNAME"));
                member.setEmail(rs.getString("EMAIL"));
                member.setRole(rs.getString("ROLE"));
                member.setCreatedAt(rs.getDate("CREATED_AT"));
                return member;
            }
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return null;
    }
}