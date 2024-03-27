FROM maven:3.5.3-jdk-8-alpine as build

WORKDIR /app
COPY . .
RUN mvn install -DskipTests=true


## build stage ##
FROM alpine:3.19
RUN adduser -D shoeshop
RUN apk add openjdk8

WORKDIR /run
COPY --from=build /app/target/shoe-ShoppingCart-0.0.1-SNAPSHOT.jar /run/shoe-ShoppingCart-0.0.1-SNAPSHOT.jar
RUN chown -R shoeshop:shoeshop /run

USER shoeshop

EXPOSE 8080

ENTRYPOINT java -jar /run/shoe-ShoppingCart-0.0.1-SNAPSHOT.jar
