-- user 테이블 (이메일을 기본 키로 사용)
CREATE TABLE user2 (
    id VARCHAR2(128) PRIMARY KEY,  -- 이메일(ID)
    jsonstr CLOB                   -- JSON 형식으로 사용자 정보 저장
);

-- feed 테이블 (자동 증가 시퀀스 사용)
CREATE TABLE feed (
    no NUMBER PRIMARY KEY,          -- 게시글 번호
    id VARCHAR2(128),               -- 사용자 ID (외래 키)
    jsonstr CLOB,                    -- 게시글 내용 (JSON)
    CONSTRAINT fk_feed_user FOREIGN KEY (id) REFERENCES user(id)
);

-- friend 테이블 (친구 관계)
CREATE TABLE friend (
    id VARCHAR2(128), -- 사용자 ID
    frid VARCHAR2(128), -- 친구 ID
    CONSTRAINT fk_friend_user FOREIGN KEY (id) REFERENCES user(id),
    CONSTRAINT fk_friend_frid FOREIGN KEY (frid) REFERENCES user(id)
);

-- feed 테이블의 자동 증가 번호를 위한 시퀀스 생성
CREATE SEQUENCE seq_feed_no START WITH 1 INCREMENT BY 1 NOCACHE;

-- feed 테이블의 자동 증가 번호를 위한 트리거 생성
CREATE OR REPLACE TRIGGER trg_feed_no
BEFORE INSERT ON feed
FOR EACH ROW
BEGIN
    IF :NEW.no IS NULL THEN
        SELECT seq_feed_no.NEXTVAL INTO :NEW.no FROM DUAL;
    END IF;
END;
/
