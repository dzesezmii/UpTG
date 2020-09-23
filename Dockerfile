FROM alpine:3.4

RUN mkdir ./app \
    && chmod 777 ./app
WORKDIR /app

RUN apk add --update --no-cache \
    build-base \
    openssl \
    fuse \
    ca-certificates \
    curl \
    wget \
    unzip \
    unrar \
    tar \
    git \
    busybox \
    python3 \
    python3-dev \
    ffmpeg \
    aria2 \
    bash \
  && cd /usr/bin \
  && pip install --upgrade pip

RUN cd /tmp \
  && curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip \
  && unzip /tmp/rclone-current-linux-amd64.zip \
  && cd rclone-*-linux-amd64 \
  && cp rclone /usr/bin/ \
  && chown root:root /usr/bin/rclone \
  && chmod 755 /usr/bin/rclone

RUN mkdir /app/gautam \
  && wget -O /app/gautam/gclone.gz https://git.io/JJMSG \
  && gzip -d /app/gautam/gclone.gz \
  && chmod 0775 /app/gautam/gclone \
  && rm -rf /tmp/* \
    /var/cache/* \
    /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["bash","start.sh"]
