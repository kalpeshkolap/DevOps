FROM     centos:7
WORKDIR  /app
RUN      yum update -y && yum install java -y && yum install wget -y
RUN      wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz
RUN      tar -xvzf apache-tomcat-8.0.23.tar.gz && mv apache-tomcat-8.0.23  apache && rm -rf apache-tomcat-8.0.23.tar.gz
ADD      ./Lab6A.war /app/apache/webapps/
EXPOSE   8080
CMD      ["/app/apache/bin/catalina.sh", "run"]
