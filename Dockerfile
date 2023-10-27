# the first stage of our build will use a maven 3.6.1 parent image
FROM maven:3.6.1-jdk-11-slim AS MAVEN_BUILD
# copy the pom and src code to the container
COPY ./ ./

# package dataverse uploader
RUN mvn clean compile assembly:single

FROM openjdk:11-jre-slim-buster

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=MAVEN_BUILD target/DVUploader-v1.2.0.jar /DVUploader.jar

# set the entrypoint command to execute the jar
ENTRYPOINT ["java", "-jar", "/DVUploader.jar"]
