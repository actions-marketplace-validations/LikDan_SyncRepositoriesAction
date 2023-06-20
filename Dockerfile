FROM ubuntu:latest
# jq - json parser lib
RUN apt-get update
RUN apt-get install -y jq
RUN apt-get install -y git

# gh - github cli
#RUN mkdir /ghcli
#WORKDIR /ghcli
#RUN wget https://github.com/cli/cli/releases/download/v2.29.0/gh_2.29.0_linux_386.tar.gz -O ghcli.tar.gz
#RUN tar --strip-components=1 -xf ghcli.tar.gz
RUN apt-get install -y gh

COPY entrypoint.sh /entrypoint.sh
COPY . .


ENTRYPOINT ["/entrypoint.sh"]
