FROM alpine:3.10
# jq - json parser lib
RUN apk add --no-cache jq
RUN apk add --no-cache git

# gh - github cli
RUN mkdir /ghcli
WORKDIR /ghcli
RUN wget https://github.com/cli/cli/releases/download/v1.0.0/gh_1.0.0_linux_386.tar.gz -O ghcli.tar.gz
RUN tar --strip-components=1 -xf ghcli.tar.gz

COPY entrypoint.sh /entrypoint.sh
COPY . .


ENTRYPOINT ["/entrypoint.sh"]
