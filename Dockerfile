# Use a base image with Java and Maven pre-installed
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project descriptor
COPY pom.xml .

# Copy the rest of the source code
COPY src ./src

# Build the application
RUN mvn clean package

# Use a lightweight base image for the runtime
FROM openjdk:17-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage to the runtime image
COPY ./target/*.jar ./app.jar

#sync the time
RUN unlink /etc/localtime;ln -s  /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# Expose the port that the application runs on
EXPOSE 8080

# Add env for java option
# ENV JAVA_OPTIONS="-Xmx2048m -Xms256m"

# Entrypoint to run the application
# ENTRYPOINT java -jar $JAVA_OPTIONS app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]