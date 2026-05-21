package dto;

import java.sql.Date;

public class CommentDTO {
    private int commentId;
    private int boardId;
    private String memberId;
    private String writerNick;
    private String password;
    private String content;
    private String ipAddress;
    private Date createdAt;

    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getWriterNick() { return writerNick; }
    public void setWriterNick(String writerNick) { this.writerNick = writerNick; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}