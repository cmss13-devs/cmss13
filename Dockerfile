ARG BYOND_BASE_IMAGE=i386/ubuntu:bionic

FROM ${BYOND_BASE_IMAGE} AS byond
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y make man curl unzip libssl-dev
ARG BYOND_MAJOR=513
ARG BYOND_MINOR=1539
ARG BYOND_DOWNLOAD_URL=https://secure.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip
RUN curl ${BYOND_DOWNLOAD_URL} -o byond.zip \
    && unzip byond.zip \
	&& rm -rf byond.zip
WORKDIR /byond
RUN make here
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/*

FROM byond AS cm-runner
ENV DREAMDAEMON_PORT=1400
RUN mkdir -p /cm/data
WORKDIR /cm
COPY map_config map_config
COPY maps maps
COPY nano nano
ARG RUSTG_LIBRARY_FILE=librust_g.so
ADD ${RUSTG_LIBRARY_FILE} librust_g.so
COPY tools/runner-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ARG DM_PROJECT_NAME=ColonialMarinesALPHA
COPY ${DM_PROJECT_NAME}.dmb application.dmb
COPY ${DM_PROJECT_NAME}.rsc application.rsc
ENTRYPOINT ["/entrypoint.sh"]
