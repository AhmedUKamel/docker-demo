FROM openjdk:17-alpine

LABEL authors="ahmedukamel"

WORKDIR /app

COPY  target/*.jar application.jar

EXPOSE 8080

CMD ["java", "-jar", "application.jar"]