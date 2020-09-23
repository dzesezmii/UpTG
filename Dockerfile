FROM python:3.8-slim-buster

RUN mkdir ./app \
    && chmod 777 ./app
WORKDIR /app

RUN apk add --update --no-cache \
    curl \
    wget \
    unzip \
    unrar \
    tar \
    git \
    busybox \
    ffmpeg \
    aria2 \
  && curl https://rclone.org/install.sh | bash

RUN mkdir /app/gautam \
  && wget -O /app/gautam/gclone.gz https://git.io/JJMSG \
  && gzip -d /app/gautam/gclone.gz \
  && chmod 0775 /app/gautam/gclone \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["bash","start.sh"]
