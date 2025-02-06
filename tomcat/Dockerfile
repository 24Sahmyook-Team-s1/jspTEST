# Tomcat 9 기반 이미지 사용
FROM tomcat:9.0-jdk21-temurin

# Tomcat 관리자 계정 설정
ENV TOMCAT_USER=admin
ENV TOMCAT_PASS=admin123

# Tomcat 관리자 계정 추가
RUN echo '<tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '<user username="'$TOMCAT_USER'" password="'$TOMCAT_PASS'" roles="manager-gui,admin-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# WAR 파일 복사 (webapps 디렉토리로)
COPY ./webapps/ROOT.war /usr/local/tomcat/webapps/

# Tomcat 실행
CMD ["catalina.sh", "run"]

# Tomcat이 8080 포트를 사용하도록 설정
EXPOSE 8080
