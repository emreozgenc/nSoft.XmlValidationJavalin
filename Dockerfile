FROM openjdk:8u111-jre-alpine

COPY ./target/app.jar app.jar

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV LANG=C.UTF-8

ENTRYPOINT ["java","-jar","/app.jar"]