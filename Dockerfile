FROM node:14.15.1-stretch-slim AS node_14151

LABEL maintainer="Boris Mihajlovski <boris_mih@yahoo.com>"

# General system staff
RUN apt update && apt upgrade -y && apt autoremove -y && \
    apt install -my xvfb gnupg libfontconfig1 procps zip locales git tmux wget && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN echo 'Europe/Skopje' > /etc/timezone
ENV TZ=Europe/Skopje
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN locale-gen

# Prepare dependencies path on the target
RUN mkdir -p /project/app/node_modules && chown -R node:node /project

# switch to normal user
USER node

# ---------------------------------- React app basic ------------------------------------
FROM node_14151 AS scheduling-web
LABEL description="Basic React App"

# Frontend dependencies caching
COPY app/package.json /project/app/package.json
RUN cd /project/app && npm install

WORKDIR /project
