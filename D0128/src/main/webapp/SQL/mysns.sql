-- 사용자 테이블
CREATE TABLE user2 (
    id VARCHAR2(128) PRIMARY KEY, -- Oracle을 기준으로 작성됨. 타 DBMS에서는 VARCHAR(128)로 조정 필요
    jsonstr CLOB
);

-- 친구 관계 테이블 (삭제 시 CASCADE 설정 추가)
CREATE TABLE friend (
    id VARCHAR2(128),
    frid VARCHAR2(128),
    CONSTRAINT fk_friend_user FOREIGN KEY (id) REFERENCES user2(id) ON DELETE CASCADE,
    CONSTRAINT fk_friend_frid FOREIGN KEY (frid) REFERENCES user2(id) ON DELETE CASCADE
);

-- 프로젝트 팀 테이블 (Projects보다 먼저 생성)
CREATE TABLE ProjectTeams (
    ProjectTeamID NUMBER PRIMARY KEY,
    TeamName VARCHAR2(100) NOT NULL
);

-- 프로젝트 테이블 (ProjectTeams가 먼저 생성된 후 실행해야 함)
CREATE TABLE Projects (
    ProjectID NUMBER PRIMARY KEY,
    ProjectName VARCHAR2(100) NOT NULL,
    ProjectTeamID NUMBER REFERENCES ProjectTeams(ProjectTeamID) ON DELETE SET NULL,
    CreatedAt DATE DEFAULT SYSDATE
);

-- 피드 테이블
CREATE TABLE feed (
    no NUMBER PRIMARY KEY,
    id VARCHAR2(128),
    jsonstr CLOB,
    CONSTRAINT fk_feed_user FOREIGN KEY (id) REFERENCES user2(id) ON DELETE CASCADE
);

-- 프로젝트 간트 차트
CREATE TABLE ProjectGanttCharts (
    ProjectChartID NUMBER PRIMARY KEY,
    ProjectID NUMBER REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    TaskName VARCHAR2(200) NOT NULL,
    CreatedAt DATE DEFAULT SYSDATE
);

-- 프로젝트 이슈
CREATE TABLE ProjectIssues (
    ProjectIssueID NUMBER PRIMARY KEY,
    ProjectUserID VARCHAR2(50),
    ProjectID NUMBER REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    Title VARCHAR2(200) NOT NULL,
    Description CLOB,
    CreatedAt DATE DEFAULT SYSDATE,
    CONSTRAINT fk_project_issue_user FOREIGN KEY (ProjectUserID) REFERENCES user2(id) ON DELETE SET NULL
);

-- 프로젝트 코멘트
CREATE TABLE ProjectComments (
    ProjectCommentID NUMBER PRIMARY KEY,
    ProjectUserID VARCHAR2(50),
    ProjectIssueID NUMBER REFERENCES ProjectIssues(ProjectIssueID) ON DELETE CASCADE,
    CommentText CLOB NOT NULL,
    CreatedAt DATE DEFAULT SYSDATE,
    CONSTRAINT fk_project_comment_user FOREIGN KEY (ProjectUserID) REFERENCES user2(id) ON DELETE SET NULL
);

-- 프로젝트 대시보드
CREATE TABLE ProjectDashboards (
    ProjectDashboardID NUMBER PRIMARY KEY,
    ProjectID NUMBER REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    Content CLOB,
    UpdatedAt DATE DEFAULT SYSDATE
);

-- SEQUENCE 및 TRIGGER 삭제 (예외 처리 개선)
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_feed_no';
EXCEPTION
    WHEN SQLCODE = -2289 THEN NULL; -- SEQUENCE가 존재하지 않을 경우 무시
    WHEN OTHERS THEN RAISE;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_feed_no';
EXCEPTION
    WHEN SQLCODE = -4080 THEN NULL; -- TRIGGER가 존재하지 않을 경우 무시
    WHEN OTHERS THEN RAISE;
END;
/

-- 피드 번호 시퀀스 생성 (MAX(no) 값과 비교하여 초기값 조정)
DECLARE
    v_max_no NUMBER;
BEGIN
    SELECT COALESCE(MAX(no), 0) INTO v_max_no FROM feed;
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_feed_no START WITH ' || (v_max_no + 1) || ' INCREMENT BY 1 NOCACHE';
END;
/

-- 피드 테이블 트리거 (중복 방지)
CREATE OR REPLACE TRIGGER trg_feed_no
BEFORE INSERT ON feed
FOR EACH ROW
BEGIN
    IF :NEW.no IS NULL THEN
        SELECT seq_feed_no.NEXTVAL INTO :NEW.no FROM DUAL;
    END IF;
END;
/
