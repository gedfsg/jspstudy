package dto;

import java.util.Date;

public class BoardFileDTO {

    private int fileId;
    private int boardId;
    private String originalName;
    private String savedName;
    private long fileSize;
    private Date createdAt;

    public int getFileId() { return fileId; }
    public void setFileId(int fileId) { this.fileId = fileId; }

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public String getOriginalName() { return originalName; }
    public void setOriginalName(String originalName) { this.originalName = originalName; }

    public String getSavedName() { return savedName; }
    public void setSavedName(String savedName) { this.savedName = savedName; }

    public long getFileSize() { return fileSize; }
    public void setFileSize(long fileSize) { this.fileSize = fileSize; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public boolean isImage() {
        if (originalName == null) return false;
        String lower = originalName.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg")
            || lower.endsWith(".png") || lower.endsWith(".gif")
            || lower.endsWith(".webp");
    }
}