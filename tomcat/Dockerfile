# Tomcat 9 기반 이미지 사용
FROM tomcat:9.0-jre21-temurin

# Tomcat 관리자 계정 설정
ENV TOMCAT_USER=admin
ENV TOMCAT_PASS=admin123

# Tomcat 관리자 계정 추가
RUN echo '<tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '<user username="'$TOMCAT_USER'" password="'$TOMCAT_PASS'" roles="manager-gui,admin-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# server.xml 수정: 자동 배포 및 unpackWARs 설정
RUN sed -i '/<Host name="localhost"/,/<\/Host>/s/<Host name="localhost" appBase="webapps"/<Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true"/' /usr/local/tomcat/conf/server.xml

# WAR 파일 복사 (webapps 디렉토리로)
COPY ./webapps/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat 실행
USER root
CMD ["catalina.sh", "run"]

# Tomcat이 8080 포트를 사용하도록 설정
EXPOSE 8080
