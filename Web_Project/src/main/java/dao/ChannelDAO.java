package dao;

import dto.ChannelDTO;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChannelDAO {

    // 채널 생성 (CHANNEL INSERT + CHANNEL_ADMIN INSERT 트랜잭션)
    public void createChannel(ChannelDTO channel) throws Exception {
        Connection conn = null;
        PreparedStatement psChannel = null;
        PreparedStatement psAdmin = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String sqlChannel = "INSERT INTO CHANNEL (CHANNEL_ID, CHANNEL_NAME, DESCRIPTION, OWNER_ID) " +
                                "VALUES (CHANNEL_SEQ.NEXTVAL, ?, ?, ?)";
            psChannel = conn.prepareStatement(sqlChannel);
            psChannel.setString(1, channel.getChannelName());
            psChannel.setString(2, channel.getDescription());
            psChannel.setString(3, channel.getOwnerId());
            psChannel.executeUpdate();

            // 방금 생성된 채널 ID 가져오기
            String sqlId = "SELECT CHANNEL_SEQ.CURRVAL FROM DUAL";
            PreparedStatement psId = conn.prepareStatement(sqlId);
            ResultSet rs = psId.executeQuery();
            int channelId = 0;
            if (rs.next()) channelId = rs.getInt(1);
            rs.close();
            psId.close();

            String sqlAdmin = "INSERT INTO CHANNEL_ADMIN (CHANNEL_ID, MEMBER_ID, ADMIN_ROLE) " +
                              "VALUES (?, ?, 'OWNER')";
            psAdmin = conn.prepareStatement(sqlAdmin);
            psAdmin.setInt(1, channelId);
            psAdmin.setString(2, channel.getOwnerId());
            psAdmin.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (psAdmin != null) psAdmin.close();
            if (psChannel != null) psChannel.close();
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    // 채널명 중복 검사
    public boolean isNameDuplicate(String channelName) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM CHANNEL WHERE CHANNEL_NAME = ?");
            ps.setString(1, channelName);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
            return false;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    // 전체 채널 목록
    public List<ChannelDTO> getAllChannels() throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<ChannelDTO> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "SELECT CHANNEL_ID, CHANNEL_NAME, DESCRIPTION, OWNER_ID, CREATED_AT " +
                "FROM CHANNEL ORDER BY CREATED_AT DESC");
            rs = ps.executeQuery();
            while (rs.next()) {
                ChannelDTO c = new ChannelDTO();
                c.setChannelId(rs.getInt("CHANNEL_ID"));
                c.setChannelName(rs.getString("CHANNEL_NAME"));
                c.setDescription(rs.getString("DESCRIPTION"));
                c.setOwnerId(rs.getString("OWNER_ID"));
                c.setCreatedAt(rs.getDate("CREATED_AT"));
                list.add(c);
            }
            return list;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    // 채널 단건 조회
    public ChannelDTO getChannelById(int channelId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "SELECT CHANNEL_ID, CHANNEL_NAME, DESCRIPTION, OWNER_ID, CREATED_AT " +
                "FROM CHANNEL WHERE CHANNEL_ID = ?");
            ps.setInt(1, channelId);
            rs = ps.executeQuery();
            if (rs.next()) {
                ChannelDTO c = new ChannelDTO();
                c.setChannelId(rs.getInt("CHANNEL_ID"));
                c.setChannelName(rs.getString("CHANNEL_NAME"));
                c.setDescription(rs.getString("DESCRIPTION"));
                c.setOwnerId(rs.getString("OWNER_ID"));
                c.setCreatedAt(rs.getDate("CREATED_AT"));
                return c;
            }
            return null;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    // 구독
    public void subscribe(int channelId, String memberId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "INSERT INTO CHANNEL_SUBSCRIPTION (CHANNEL_ID, MEMBER_ID) VALUES (?, ?)");
            ps.setInt(1, channelId);
            ps.setString(2, memberId);
            ps.executeUpdate();
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    // 구독 취소
    public void unsubscribe(int channelId, String memberId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "DELETE FROM CHANNEL_SUBSCRIPTION WHERE CHANNEL_ID = ? AND MEMBER_ID = ?");
            ps.setInt(1, channelId);
            ps.setString(2, memberId);
            ps.executeUpdate();
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    // 구독 여부 확인
    public boolean isSubscribed(int channelId, String memberId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM CHANNEL_SUBSCRIPTION WHERE CHANNEL_ID = ? AND MEMBER_ID = ?");
            ps.setInt(1, channelId);
            ps.setString(2, memberId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
            return false;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    // 내 구독 채널 목록
    public List<ChannelDTO> getSubscribedChannels(String memberId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<ChannelDTO> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                "SELECT C.CHANNEL_ID, C.CHANNEL_NAME, C.DESCRIPTION, C.OWNER_ID, C.CREATED_AT " +
                "FROM CHANNEL C JOIN CHANNEL_SUBSCRIPTION S ON C.CHANNEL_ID = S.CHANNEL_ID " +
                "WHERE S.MEMBER_ID = ? ORDER BY S.CREATED_AT DESC");
            ps.setString(1, memberId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ChannelDTO c = new ChannelDTO();
                c.setChannelId(rs.getInt("CHANNEL_ID"));
                c.setChannelName(rs.getString("CHANNEL_NAME"));
                c.setDescription(rs.getString("DESCRIPTION"));
                c.setOwnerId(rs.getString("OWNER_ID"));
                c.setCreatedAt(rs.getDate("CREATED_AT"));
                list.add(c);
            }
            return list;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
    
    public List<ChannelDTO> searchChannels(String keyword) {
        List<ChannelDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM CHANNEL WHERE CHANNEL_NAME LIKE '%'||?||'%' OR DESCRIPTION LIKE '%'||?||'%'";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, keyword);
            pstmt.setString(2, keyword);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ChannelDTO channel = new ChannelDTO();
                // DTO에 맞게 카멜 케이스로 변경
                channel.setChannelId(rs.getInt("CHANNEL_ID"));
                channel.setChannelName(rs.getString("CHANNEL_NAME"));
                channel.setDescription(rs.getString("DESCRIPTION"));
                channel.setOwnerId(rs.getString("OWNER_ID"));
                list.add(channel);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 해제
        }
        return list;
    }
}