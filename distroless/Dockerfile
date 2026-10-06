FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -q -B package

FROM gcr.io/distroless/java21-debian12:nonroot
COPY --from=build /src/target/orders.jar /app/orders.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/orders.jar"]
