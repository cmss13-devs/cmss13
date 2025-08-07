# TODO: Use an .envfile and make everyone use it instead
ARG BYOND_BASE_IMAGE=ubuntu:focal
ARG UTILITY_BASE_IMAGE=alpine:3
ARG PROJECT_NAME=colonialmarines
ARG BYOND_MAJOR=514
ARG BYOND_MINOR=1575
ARG NODE_VERSION=16
ARG BYOND_UID=1000

# BUILD_TYPE=standalone to build with juke in docker
# BUILD_TYPE=deploy to directly use already built local files
# This will only work properly with later docker version! If it doesn't try launching with DOCKER_BUILDKIT=1 env variable
ARG BUILD_TYPE=deploy

# Base BYOND image
FROM ${BYOND_BASE_IMAGE} AS byond
SHELL ["/bin/bash", "-c"]
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y make man curl unzip libssl-dev libssl-dev:i386 libz-dev:i386 lib32stdc++6 python3-minimal
RUN update-alternatives --install /usr/local/bin/python python /usr/bin/python3 20
ARG BYOND_MAJOR
ARG BYOND_MINOR
ARG BYOND_DOWNLOAD_URL=http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip
RUN curl ${BYOND_DOWNLOAD_URL} -o byond.zip -A "CMSS13/1.0 Continuous Integration"\
    && unzip byond.zip \
	&& rm -rf byond.zip
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /byond
RUN make here

# DM Build Env to be used in particular with juke if not running it locally
FROM byond AS cm-builder
COPY tools/docker/nodesource.gpg /usr/share/keyrings/nodesource.gpg
COPY tools/docker/nodesource.list /etc/apt/sources.list.d/
COPY tools/docker/apt-node-prefs /etc/apt/preferences/
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y nodejs yarn g++-multilib && apt-get clean && rm -rf /var/lib/apt/lists/*

# TGUI deps pre-caching, thin out files to serve as basis for layer caching
FROM node:${NODE_VERSION}-buster AS tgui-thin
COPY tgui /tgui
RUN rm -rf docs public
RUN find packages \! -name "package.json" -mindepth 2 -maxdepth 2 -print | xargs rm -rf

# TGUI deps cache layer, actually gets the deps
FROM node:${NODE_VERSION}-buster AS tgui-deps
COPY --from=tgui-thin tgui /tgui
WORKDIR /tgui
RUN yarn install --immutable

# Game source cache stage: remove irrelevant dupes not dockerignored to prevent cache misses
FROM ${UTILITY_BASE_IMAGE} AS source-cache
COPY . /src
WORKDIR /src
RUN rm -rf *.rsc *.dmb

# Stage actually building with juke if needed
FROM cm-builder AS cm-build-standalone
ARG PROJECT_NAME
COPY --from=source-cache /src /build
WORKDIR /build
COPY --from=tgui-deps /tgui/.yarn/cache tgui/.yarn/cache
RUN ./tools/docker/juke-build.sh

# Helper Stage just packaging locally provided resources
FROM ${UTILITY_BASE_IMAGE} AS cm-build-deploy
ARG PROJECT_NAME
RUN mkdir /build
WORKDIR /build
COPY tgui/public tgui/public
COPY ${PROJECT_NAME}.dmb ${PROJECT_NAME}.dmb
COPY ${PROJECT_NAME}.rsc ${PROJECT_NAME}.rsc

# Alias for using either of the above
FROM cm-build-${BUILD_TYPE} AS build-results

# Deployment stage, piecing a workable game image
FROM byond AS deploy
ARG PROJECT_NAME
ARG BYOND_UID
ENV DREAMDAEMON_PORT=1400
RUN mkdir -p /cm/data
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /cm/ytdl
COPY tools/docker/runner-entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh /cm/ytdl
RUN useradd -u ${BYOND_UID} -ms /bin/bash byond
WORKDIR /cm
COPY librust_g.so .
COPY config config
COPY map_config map_config
COPY strings strings
COPY nano nano
COPY maps maps
COPY html html
COPY sound sound
COPY icons icons
COPY --from=build-results /build/tgui/public tgui/public/
COPY --from=build-results /build/${PROJECT_NAME}.dmb application.dmb
COPY --from=build-results /build/${PROJECT_NAME}.rsc application.rsc
RUN chown -R byond:byond /byond /cm /entrypoint.sh
USER ${BYOND_UID}
ENTRYPOINT [ "/entrypoint.sh" ]
