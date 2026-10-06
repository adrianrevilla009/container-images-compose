FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY pom.xml .
RUN mvn -q -B dependency:go-offline
COPY src ./src
RUN mvn -q -B package

FROM eclipse-temurin:21-jre-alpine
RUN adduser -D app
USER app
COPY --from=build /src/target/orders.jar /app/orders.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/orders.jar"]
