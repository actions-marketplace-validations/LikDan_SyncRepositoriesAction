FROM alpine:3.10
# jq - json parser lib
RUN apk add --no-cache jq
COPY entrypoint.sh /entrypoint.sh
COPY . .
ENTRYPOINT ["/entrypoint.sh"]
