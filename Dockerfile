FROM python:3.8-slim-buster

RUN mkdir ./app \
    && chmod 777 ./app
WORKDIR /app

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

#us-east-1 eu-west-1 sed -i.bak 's/us-east-1\.ec2\.//' /etc/apt/sources.list \
RUN apt -qq update \
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
  && curl https://rclone.org/install.sh | bash \
  && mkdir /app/gautam \
  && wget -O /app/gautam/gclone.gz https://git.io/JJMSG \
  && gzip -d /app/gautam/gclone.gz \
  && chmod 0775 /app/gautam/gclone \
  && wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add - \
  && echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list \
  && apt -qq update \
  && apt -qq install -y --no-install-recommends unrar \
  && pip install --no-cache-dir -r requirements.txt \
  && apt-get remove --purge -y git $(apt-mark showauto) \
  && apt clean autoclean \
  && apt autoremove -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY requirements.txt .

COPY . .
CMD ["bash","start.sh"]
