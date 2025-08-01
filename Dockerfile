FROM tomcat:latest
MAINTAINER srivamsi <srivamsi.v@hcltech.com>
EXPOSE 8080
COPY target/maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war
