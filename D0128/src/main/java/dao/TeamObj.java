package dao;

import java.util.Date;

public class TeamObj {
    private int teamId;          // 팀 ID
    private String teamName;     // 팀 이름
    private Date createdAt;      // 생성일
    private String adminUserId;  // 관리자 사용자 ID

    // 생성자
    public TeamObj(int teamId, String teamName, Date createdAt, String adminUserId) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.createdAt = createdAt;
        this.adminUserId = adminUserId;
    }

    // Getter 메서드
    public int getTeamId() {
        return teamId;
    }

    public String getTeamName() {
        return teamName;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public String getAdminUserId() {
        return adminUserId;
    }
}
