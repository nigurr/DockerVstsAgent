FROM ubuntu:18.04 AS base
WORKDIR /
RUN apt-get update \
    && apt-get install -y --no-install-recommends liblttng-ust0 \
    libssl1.0.0 \
    libkrb5-3 \
    libicu60 \
    curl \
    ca-certificates \
    icu-devtools \
    libunwind8 \
    unzip \
    git \
    gnupg

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
RUN apt-get install -y nodejs

FROM base as agent 
WORKDIR /
COPY ./agent /agent
RUN /agent/src/dev.sh l

FROM base as execution
WORKDIR /
RUN mkdir /home/appuser
COPY --from=agent /agent/_layout /agent
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
RUN chown -R appuser /agent
RUN chown -R appuser /home/appuser
USER appuser
RUN /agent/config.sh --unattended --url https://dev.azure.com/mseng --auth pat --pool Nitin dockAgent --acceptTeeEula
ENTRYPOINT [ "/agent/run.sh" ]