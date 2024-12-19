# 使用 OpenJDK 17 基礎鏡像
FROM openjdk:17-jdk-slim

# 設置工作目錄
WORKDIR /app

# 複製 .war 文件到容器
COPY target/Coffeesouffle-0.0.1-SNAPSHOT.war app.war

# 啟動應用
CMD ["java", "-Dserver.port=${PORT}", "-jar", "app.war"]
