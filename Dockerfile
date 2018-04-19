FROM mikafouenski/alpine-python
MAINTAINER mikafouenski

RUN apk add --no-cache --virtual .sqlite \
        sqlite && \
    apk add --no-cache --virtual .pillow-deps \
        jpeg-dev \
        zlib-dev \
        freetype-dev \
        lcms2-dev \
        openjpeg-dev \
        tiff-dev \
        tk-dev \
        tcl-dev && \
    pip install \
        flask \
        pony>=0.9 \
        Pillow \
        requests>=1.0.0 \
        mutagen \
        watchdog \
        pymysql \
        gunicorn \
        https://github.com/spl0k/supysonic/archive/master.tar.gz && \
    apk add --no-cache --virtual .media \
        ffmpeg \
        flac \
        mpg123 \
        vorbis-tools \
        lame && \
    mkdir /app && \
    curl -o /app/sqlite.sql https://raw.githubusercontent.com/spl0k/supysonic/master/schema/sqlite.sql && \
    curl -o /app/app.py https://raw.githubusercontent.com/spl0k/supysonic/master/cgi-bin/supysonic.wsgi && \
    rm -rf /tmp/* /root/.cache

ADD root/ /

EXPOSE 8000
VOLUME /config /music 

