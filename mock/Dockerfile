# syntax=docker/dockerfile:experimental
# export DOCKER_BUILDKIT=1 していること

# stable release
# https://github.com/OpenAPITools/openapi-generator
FROM openapitools/openapi-generator:cli-v4.3.0 AS build

ENV GENERATOR="java -jar /opt/openapi-generator/modules/openapi-generator-cli/target/openapi-generator-cli.jar"

WORKDIR /src
COPY *.yaml .
COPY v1 v1

# help
# RUN $GENERATOR help generate
# RUN $GENERATOR version
# RUN $GENERATOR list

# サーバー向けgenerate
RUN $GENERATOR generate -g spring -i openapi.yaml -o /dist -p returnSuccessCode=true


FROM maven:3-jdk-11 AS runtime
COPY --from=build /dist /dist

WORKDIR /dist

# CORS有効
RUN sed -i \
  -e 's|/\*@|@|g' \
  -e 's|}\*/|}|g' \
  -e 's|Content-Type|\*|g' \
  /dist/src/main/java/org/openapitools/OpenAPI2SpringBoot.java

# https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md
RUN --mount=type=cache,target=/root/.m2 mvn package

ENTRYPOINT ["java", "-jar", "target/openapi-spring-1.0.0.jar"]