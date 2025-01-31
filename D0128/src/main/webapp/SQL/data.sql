INSERT INTO user2 (id, jsonstr) VALUES ('user1@example.com', '{"name": "User One", "age": 30}');
INSERT INTO user2 (id, jsonstr) VALUES ('user2@example.com', '{"name": "User Two", "age": 25}');
INSERT INTO user2 (id, jsonstr) VALUES ('user3@example.com', '{"name": "User Three", "age": 35}');

INSERT INTO feed (id, jsonstr) VALUES ('user1@example.com', '{"content": "This is the first post", "likes": 10}');
INSERT INTO feed (id, jsonstr) VALUES ('user2@example.com', '{"content": "Hello world!", "likes": 5}');
INSERT INTO feed (id, jsonstr) VALUES ('user3@example.com', '{"content": "This is another post", "likes": 3}');

INSERT INTO friend (id, frid) VALUES ('user1@example.com', 'user2@example.com');
INSERT INTO friend (id, frid) VALUES ('user1@example.com', 'user3@example.com');
INSERT INTO friend (id, frid) VALUES ('user2@example.com', 'user3@example.com');
INSERT INTO friend (id, frid) VALUES ('user3@example.com', 'user1@example.com');