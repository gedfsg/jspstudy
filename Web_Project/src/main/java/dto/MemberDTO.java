package dto;

import java.util.Date;

public class MemberDTO {

    private String memberId;
    private String password;
    private String nickname;
    private String email;
    private String role;
    private Date   createdAt;

    // 기본 생성자
    public MemberDTO() {}

    // 회원가입용 생성자 (role, createdAt은 DB 기본값 사용)
    public MemberDTO(String memberId, String password, String nickname, String email) {
        this.memberId = memberId;
        this.password = password;
        this.nickname = nickname;
        this.email    = email;
    }

    // Getter & Setter
    public String getMemberId()             { return memberId; }
    public void   setMemberId(String v)     { memberId = v; }

    public String getPassword()             { return password; }
    public void   setPassword(String v)     { password = v; }

    public String getNickname()             { return nickname; }
    public void   setNickname(String v)     { nickname = v; }

    public String getEmail()                { return email; }
    public void   setEmail(String v)        { email = v; }

    public String getRole()                 { return role; }
    public void   setRole(String v)         { role = v; }

    public Date   getCreatedAt()            { return createdAt; }
    public void   setCreatedAt(Date v)      { createdAt = v; }
}