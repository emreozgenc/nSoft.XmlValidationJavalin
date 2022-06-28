FROM openjdk:8u111-jre-alpine

COPY ./target/app.jar app.jar
COPY ./src/main/resources/static /static

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV LANG=C.UTF-8

ENTRYPOINT ["java","-jar","/app.jar"]