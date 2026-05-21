package dto;

import java.util.Date;

public class BoardDTO {

    private int boardId;
    private int channelId;

    private String title;
    private String content;

    private String memberId;

    private String writerNick;
    private String writerIp;

    private String boardPassword;

    private int readCount;

    private int recommendCount;
    private int unrecommendCount;

    private Date createdAt;
    private Date updatedAt;

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public int getChannelId() { return channelId; }
    public void setChannelId(int channelId) { this.channelId = channelId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getWriterNick() { return writerNick; }
    public void setWriterNick(String writerNick) { this.writerNick = writerNick; }

    public String getWriterIp() { return writerIp; }
    public void setWriterIp(String writerIp) { this.writerIp = writerIp; }

    public String getBoardPassword() { return boardPassword; }
    public void setBoardPassword(String boardPassword) { this.boardPassword = boardPassword; }

    public int getReadCount() { return readCount; }
    public void setReadCount(int readCount) { this.readCount = readCount; }

    public int getRecommendCount() { return recommendCount; }
    public void setRecommendCount(int recommendCount) { this.recommendCount = recommendCount; }

    public int getUnrecommendCount() { return unrecommendCount; }
    public void setUnrecommendCount(int unrecommendCount) { this.unrecommendCount = unrecommendCount; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
