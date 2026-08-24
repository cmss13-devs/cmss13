# Unfortunately we have to duplicate values from dependencies.sh because this community decided to use a stupid sh script instead of an envfile, thanks a lot
ARG BYOND_BASE_IMAGE=debian:trixie
ARG UTILITY_BASE_IMAGE=alpine:3
ARG PROJECT_NAME=colonialmarines
ARG BYOND_MAJOR=516
ARG BYOND_MINOR=1687
ARG RUSTG_TARGET=7.0.0
ARG BYOND_UID=1000

# BUILD_TYPE=standalone to build with juke in docker
# BUILD_TYPE=deploy to directly use already built local files
# This will only work properly with later docker version! If it doesn't try launching with DOCKER_BUILDKIT=1 env variable
ARG BUILD_TYPE=deploy

# Layer building rustg for use in final containers
FROM rust:1 AS rustg-builder
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y build-essential gcc-multilib
RUN rustup target add i686-unknown-linux-gnu
ARG RUSTG_ORIGIN=https://github.com/tgstation/rust-g.git
ARG RUSTG_TARGET
RUN git clone --depth 1 --branch ${RUSTG_TARGET} ${RUSTG_ORIGIN} /rustg
WORKDIR /rustg
RUN cargo build --release --target i686-unknown-linux-gnu --features redis_pubsub

# Base BYOND image
FROM ${BYOND_BASE_IMAGE} AS byond
SHELL ["/bin/bash", "-c"]
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y make man curl unzip python3-minimal libssl-dev libssl-dev:i386 libz-dev:i386 libcurl4-openssl-dev:i386
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
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y g++-multilib nodejs && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN npm install -g bun

# TGUI deps pre-caching, thin out files to serve as basis for layer caching
FROM oven/bun:latest AS tgui-thin
COPY tgui /tgui
RUN rm -rf docs public

# TGUI deps cache layer, actually gets the deps
FROM oven/bun:latest AS tgui-deps
COPY --from=tgui-thin tgui /tgui
WORKDIR /tgui
RUN bun install --immutable

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
COPY --from=tgui-deps /tgui/node_modules tgui/node_modules
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
COPY --chown=${BYOND_UID}:${BYOND_UID} --from=rustg-builder --link /rustg/target/i686-unknown-linux-gnu/release/librust_g.so librust_g.so
COPY --chown=${BYOND_UID}:${BYOND_UID} --from=build-results --link /build/tgui/public tgui/public/
COPY --chown=${BYOND_UID}:${BYOND_UID} --from=build-results --link /build/${PROJECT_NAME}.dmb application.dmb
COPY --chown=${BYOND_UID}:${BYOND_UID} --from=build-results --link /build/${PROJECT_NAME}.rsc application.rsc
COPY --chown=${BYOND_UID}:${BYOND_UID} map_config map_config
COPY --chown=${BYOND_UID}:${BYOND_UID} strings strings
COPY --chown=${BYOND_UID}:${BYOND_UID} nano nano
COPY --chown=${BYOND_UID}:${BYOND_UID} maps maps
COPY --chown=${BYOND_UID}:${BYOND_UID} html html
COPY --chown=${BYOND_UID}:${BYOND_UID} sound sound
COPY --chown=${BYOND_UID}:${BYOND_UID} icons icons
USER ${BYOND_UID}
RUN chown ${BYOND_UID}:${BYOND_UID} /cm
ENTRYPOINT [ "/entrypoint.sh" ]

