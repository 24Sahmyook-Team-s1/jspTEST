package dao;
import java.sql.Timestamp;

public class ProjectissueObj {
    private int projectIssueId;  // 이슈의 고유 ID
    private String UserId;   // 이슈를 등록한 사용자 ID
    private int projectId;
    private String title;         // 이슈의 제목
    private String description;   // 이슈에 대한 설명
    private Timestamp createdAt;  // 이슈 생성일 및 시간
    private int issuelevel;
    
    // 생성자
    public ProjectissueObj(int projectIssueId, String UserId, int projectId, String title, String description, int issuelevel, Timestamp createdAt) {
        this.projectIssueId = projectIssueId;
        this.UserId = UserId;
        this.projectId = projectId;
        this.title = title;
        this.description = description;
        this.issuelevel = issuelevel;
        this.createdAt = createdAt;
    }

    // Getter 메서드
    public int getProjectIssueId() {
        return projectIssueId;
    }

    public String getProjectUserId() {
        return UserId;
    }
    
    public int getProjectId() {
        return projectId;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public int getIssueLevel() {
        return issuelevel;
    }
}

