FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/Coffeesouffle-0.0.1-SNAPSHOT.war app.war
CMD ["java", "-Dserver.port=$PORT", "-jar", "app.war"]
