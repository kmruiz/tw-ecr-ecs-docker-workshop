FROM openjdk:9-slim

ARG SERVICE_VERSION
ARG JVM_PROPERTIES

WORKDIR /service
ADD . /service/

RUN echo ${SERVICE_VERSION} > version
RUN ./gradlew build
CMD java ${JVM_PROPERTIES} -jar build/libs/service-`cat version`.jar
