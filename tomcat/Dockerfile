# Tomcat 9 기반 이미지 사용
FROM tomcat:9.0

# Tomcat 관리자 계정 설정
ENV TOMCAT_USER=admin
@@ -11,7 +11,7 @@ RUN echo '<tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# WAR 파일 복사 (webapps 디렉토리로)
COPY ./webapps/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat 실행
CMD ["catalina.sh", "run"]
