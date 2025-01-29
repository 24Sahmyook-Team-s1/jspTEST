-- user 테이블 데이터 삽입 (JSON 데이터 포함)
INSERT INTO user2 (id, jsonstr) VALUES ('kim@abc.com', '{"password": "111", "name": "김시민"}');
INSERT INTO user2 (id, jsonstr) VALUES ('lee@abc.com', '{"password": "222", "name": "이순신"}');
INSERT INTO user2 (id, jsonstr) VALUES ('kwon@abc.com', '{"password": "333", "name": "권율"}');

-- feed 테이블 데이터 삽입 (JSON 형식으로 저장, 자동 증가 no 사용)
INSERT INTO feed (id, jsonstr) VALUES ('kim@abc.com', '{"message": "Hello"}');
INSERT INTO feed (id, jsonstr) VALUES ('kwon@abc.com', '{"message": "Aloha"}');
