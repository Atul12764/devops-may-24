
FROM node:18 AS frontend-build
WORKDIR /app
COPY frontend/ ./
RUN npm install && npm run build

FROM maven:latest AS backend-build
WORKDIR /app
COPY backend/ ./
COPY --from=frontend-build /app/build ./src/main/resources/static
RUN mvn clean package -DskipTests

FROM openjdk:latest
WORKDIR /app
COPY --from=backend-build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

