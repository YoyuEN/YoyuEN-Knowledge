FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY Backend-0.0.1-SNAPSHOT.jar app.jar
ENV TZ=Asia/Shanghai \
    JAVA_OPTS="-Xms512m -Xmx2g -Dfile.encoding=UTF-8"
EXPOSE 12138
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar app.jar"]