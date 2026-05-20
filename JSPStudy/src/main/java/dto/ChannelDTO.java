package dto;

import java.util.Date;

public class ChannelDTO {

    private int channelId;
    private String channelName;
    private String description;
    private String ownerId;
    private Date createdAt;

    public ChannelDTO() {}

    public ChannelDTO(String channelName, String description, String ownerId) {
        this.channelName = channelName;
        this.description = description;
        this.ownerId = ownerId;
    }

    public int getChannelId() { return channelId; }
    public void setChannelId(int channelId) { this.channelId = channelId; }

    public String getChannelName() { return channelName; }
    public void setChannelName(String channelName) { this.channelName = channelName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getOwnerId() { return ownerId; }
    public void setOwnerId(String ownerId) { this.ownerId = ownerId; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
