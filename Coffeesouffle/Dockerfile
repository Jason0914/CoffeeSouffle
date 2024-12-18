# 使用 Tomcat 官方映像，指定 Tomcat 版本
FROM tomcat:9.0-jdk17-openjdk

# 複製打包好的 .war 檔案到 Tomcat 的 webapps 目錄
COPY target/Coffeesouffle-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/app.war


EXPOSE 8080

# 啟動 Tomcat
CMD ["catalina.sh", "run"]
