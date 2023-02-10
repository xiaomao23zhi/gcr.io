FROM openjdk:8-jdk-slim

RUN apt-get -qq update && \
    apt-get -qq upgrade -y && \
    apt-get -qq install -y git wget && \
    wget -q https://desktop.docker.com/win/stable/amd64/61853/Docker%20Desktop%20Installer.exe -P /tmp
