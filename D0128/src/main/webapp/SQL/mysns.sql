CREATE TABLE user2 (
    id VARCHAR2(128) PRIMARY KEY,
    jsonstr CLOB
);

CREATE TABLE feed (
    no NUMBER PRIMARY KEY,
    id VARCHAR2(128),
    jsonstr CLOB,
    CONSTRAINT fk_feed_user FOREIGN KEY (id) REFERENCES user2(id)
);

CREATE TABLE friend (
    id VARCHAR2(128),
    frid VARCHAR2(128),
    CONSTRAINT fk_friend_user FOREIGN KEY (id) REFERENCES user2(id),
    CONSTRAINT fk_friend_frid FOREIGN KEY (frid) REFERENCES user2(id)
);

CREATE TABLE Projects (
    ProjectID NUMBER PRIMARY KEY,
    ProjectName VARCHAR2(100) NOT NULL,
    ProjectTeamID NUMBER REFERENCES ProjectTeams(ProjectTeamID),
    CreatedAt DATE DEFAULT SYSDATE
); 

CREATE TABLE ProjectGanttCharts (
    ProjectChartID NUMBER PRIMARY KEY,
    ProjectID NUMBER REFERENCES Projects(ProjectID),
    TaskName VARCHAR2(200) NOT NULL,
    CreatedAt DATE DEFAULT SYSDATE
); 

CREATE TABLE ProjectIssues (
    ProjectIssueID NUMBER PRIMARY KEY,
    ProjectUserID VARCHAR2(50) REFERENCES ProjectUsers(ProjectUserID),
    ProjectID NUMBER REFERENCES Projects(ProjectID),
    Title VARCHAR2(200) NOT NULL,
    Description CLOB,
    CreatedAt DATE DEFAULT SYSDATE
); 

CREATE TABLE ProjectComments (
    ProjectCommentID NUMBER PRIMARY KEY,
    ProjectUserID VARCHAR2(50) REFERENCES ProjectUsers(ProjectUserID),
    ProjectIssueID NUMBER REFERENCES ProjectIssues(ProjectIssueID),
    CommentText CLOB NOT NULL,
    CreatedAt DATE DEFAULT SYSDATE
); 

CREATE TABLE ProjectDashboards (
    ProjectDashboardID NUMBER PRIMARY KEY,
    ProjectID NUMBER REFERENCES Projects(ProjectID),
    Content CLOB,
    UpdatedAt DATE DEFAULT SYSDATE
);

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_feed_no';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_feed_no';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4080 THEN
            RAISE;
        END IF;
END;
/

CREATE SEQUENCE seq_feed_no START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_feed_no
BEFORE INSERT ON feed
FOR EACH ROW
BEGIN
    IF :NEW.no IS NULL THEN
        SELECT seq_feed_no.NEXTVAL INTO :NEW.no FROM DUAL;
    END IF;
END;
/