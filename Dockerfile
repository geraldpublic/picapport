FROM alpine:latest

ARG ARCH=amd64
ARG VERSION=7-1-02

ENV PICAPPORT_PORT=80

RUN apk add --update --no-cache tini openjdk8 curl && \
    mkdir -p /opt/picapport && \
    curl -SsL -o /opt/picapport/picapport-headless.jar http://www.picapport.de/download/${VERSION}/picapport-headless.jar && \
    mkdir /opt/picapport/.picapport && \
    printf "%s\n%s\n%s\n" "server.port=$PICAPPORT_PORT" "irobot.root.0.path=/srv/photos" "foto.jpg.usecache=2" > /opt/picapport/.picapport/picapport.properties

WORKDIR /opt/picapport
EXPOSE ${PICAPPORT_PORT}

#ENTRYPOINT ["java", "-DTRACE=INFO", "-Duser.home=/opt/picapport", "-cp", "picapport.jar", "de.contecon.picapport.PicApport", "-configfile=/opt/picapport/.picapport/picapport.properties", "-pgui.enabled=false"]

ENTRYPOINT ["tini", "--", "java", "-Xms256m", "-Xmx512m", "-Duser.home=/opt/picapport", "-jar", "picapport-headless.jar"]

LABEL de.whatever4711.picapport.version=$VERSION \
    de.whatever4711.picapport.name="PicApport" \
    de.whatever4711.picapport.docker.cmd="docker run -d  whatever4711/picapport:latest" \
    de.whatever4711.picapport.vendor="Marcel Grossmann" \
    de.whatever4711.picapport.architecture=$ARCH
