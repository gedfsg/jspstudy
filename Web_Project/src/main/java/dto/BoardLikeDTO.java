package dto;

public class BoardLikeDTO {
    private int boardId;
    private String memberId;
    private int likeType; // 1이면 추천, -1이면 비추천

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public int getLikeType() { return likeType; }
    public void setLikeType(int likeType) { this.likeType = likeType; }
}