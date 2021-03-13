FROM python:3.8-alpine

LABEL "com.github.actions.name"="S3 Sync"
LABEL "com.github.actions.description"="Sync a directory with AWS S3 directory"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL version="0.0.1"
LABEL maintainer="ThePoWow.Me Ltd. <info@dianurse.com>"


RUN pip install --quiet --no-cache-dir awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
