# TODO: Replace 80% of that cache handling with juke tasks
# so contributors can have reproducible test builds without needing docker...
# Also will allow to properly handle building game in map checking mode

ARG BYOND_BASE_IMAGE=i386/ubuntu:bionic
ARG BYOND_MAJOR=513
ARG BYOND_MINOR=1542
ARG NODE_VERSION=15
ARG PYTHON_VERSION=3.7

# Base BYOND image
FROM --platform=linux/386 ${BYOND_BASE_IMAGE} AS byond
SHELL ["/bin/bash", "-c"]
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y make man curl unzip libssl-dev
ARG BYOND_MAJOR
ARG BYOND_MINOR
ARG BYOND_DOWNLOAD_URL=https://secure.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip
RUN curl ${BYOND_DOWNLOAD_URL} -o byond.zip \
    && unzip byond.zip \
	&& rm -rf byond.zip
WORKDIR /byond
RUN make here
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/*

# Legacy GitLab CI packaging container, using pre-built game in pipeline
FROM byond AS cm-runner
ENV DREAMDAEMON_PORT=1400
RUN mkdir -p /cm/data
WORKDIR /cm
COPY map_config map_config
COPY maps maps
COPY nano nano
COPY librust_g.so .
COPY tools/runner-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
COPY ColonialMarinesALPHA.dmb application.dmb
COPY ColonialMarinesALPHA.rsc application.rsc
ENTRYPOINT ["/entrypoint.sh"]

# Image used for building the game with DreamMaker
FROM byond AS cm-builder
ARG DM_PROJECT_NAME
ARG PYTHON_VERSION
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y python${PYTHON_VERSION} python3-pip
RUN pip3 install python-dateutil requests beautifulsoup4 pyyaml
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/*

# TGUI deps prep (cache stage - keep only base structure)
FROM node:${NODE_VERSION}-buster AS tgui-thin
WORKDIR /tgui
COPY tgui .
RUN rm -rf docs public
RUN find packages \! -name "package.json" -mindepth 2 -maxdepth 2 -print | xargs rm -rf

# TGUI deps fetch (cache stage - keep deps as standalone layer)
FROM node:${NODE_VERSION}-buster AS tgui-deps
COPY --from=tgui-thin tgui /tgui
WORKDIR /tgui
RUN chmod u+x bin/tgui && bin/tgui --deps-only

# TGUI builder
FROM node:${NODE_VERSION}-buster AS tgui-build
WORKDIR /tgui
COPY --from=tgui-deps /tgui/.yarn/cache .yarn/cache
COPY tgui .
RUN chmod u+x bin/tgui && bin/tgui --deps-check && bin/tgui
RUN rm -rf .yarn/cache

# More cache shenanigans, trim uneeded build context for layer caching DM build
# this ensures modifying eg. dynamic maps don't force a game rebuild, as we just add them at end regardless
# *.txt is the changelog date marker (uses gitlab project ID)
FROM byond AS cm-cache
COPY . /build
WORKDIR /build
RUN rm -rf tgui config strings maps map_config tools *.txt
# Copy back the few files we need during DM build
COPY maps/_basemap.dm maps/
COPY maps/map_files/generic maps/map_files/generic

# Actual game building stage. We include tgui here because it'll be packed in RSC file
FROM cm-builder AS cm-build
COPY --from=cm-cache /build /build
WORKDIR /build
COPY --from=tgui-build /tgui/public tgui/public
RUN source /byond/bin/byondsetup && DreamMaker ColonialMarinesALPHA.dme

# Deployment container piecing everything together for use
FROM byond AS deploy
ENV DREAMDAEMON_PORT=1400
RUN mkdir -p /cm/data
COPY tools/runner-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
RUN useradd -ms /bin/bash byond
RUN chown -R byond:byond /byond /cm /entrypoint.sh
WORKDIR /cm
USER byond
COPY librust_g.so .
COPY config config
COPY map_config map_config
COPY strings strings
COPY nano nano
COPY maps maps
COPY --from=cm-build /build/ColonialMarinesALPHA.rsc application.rsc
COPY --from=cm-build /build/ColonialMarinesALPHA.dmb application.dmb
ENTRYPOINT [ "/entrypoint.sh" ]
