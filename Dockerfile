FROM python:3.8-slim-buster

RUN mkdir ./app \
    && chmod 777 ./app
WORKDIR /app

ENV LANG C.UTF-8
ENV TZ=Europe/London
ENV DEBIAN_FRONTEND=noninteractive

#us-east-1 eu-west-1
RUN sed -i.bak 's/us-east-1\.ec2\.//' /etc/apt/sources.list \
  && apt -qq update \
  && apt -qq install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    tar \
    git \
    busybox \
    ffmpeg \
    aria2 \
    gnupg2 \
  && curl https://rclone.org/install.sh | bash

RUN mkdir /app/gautam \
  && wget -O /app/gautam/gclone.gz https://git.io/JJMSG \
  && gzip -d /app/gautam/gclone.gz \
  && chmod 0775 /app/gautam/gclone \
  && wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add - \
  && echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list \
  && apt -qq update \
  && apt -qq install -y --no-install-recommends unrar \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["bash","start.sh"]
