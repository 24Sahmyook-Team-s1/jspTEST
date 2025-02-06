package dao;
import java.sql.Timestamp;

public class ProjectissueObj {
    private int projectIssueId;  // 이슈의 고유 ID
    private int projectUserId;   // 이슈를 등록한 사용자 ID
    private String title;         // 이슈의 제목
    private String description;   // 이슈에 대한 설명
    private Timestamp createdAt;  // 이슈 생성일 및 시간

    // 생성자
    public ProjectissueObj(int projectIssueId, int projectUserId, String title, String description, Timestamp createdAt) {
        this.projectIssueId = projectIssueId;
        this.projectUserId = projectUserId;
        this.title = title;
        this.description = description;
        this.createdAt = createdAt;
    }

    // Getter 메서드
    public int getProjectIssueId() {
        return projectIssueId;
    }

    public int getProjectUserId() {
        return projectUserId;
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
}
