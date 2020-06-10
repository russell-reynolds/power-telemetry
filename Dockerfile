FROM python:3.7.7-buster

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y autoconf && \
    apt-get install -y automake && \
    apt-get install -y flex && \
    apt-get install -y bison && \
    apt-get install -y libtool && \
    apt-get install -y pkg-config && \
    apt-get install -y powercap-utils && \
    apt-get install -y build-essential

RUN mkdir /workspace
WORKDIR /workspace

RUN git clone https://github.com/collectd/collectd.git

WORKDIR /workspace/collectd

RUN ls -ltr

RUN ./build.sh
RUN ./configure && make && make install

WORKDIR /
COPY collectd.conf /opt/collectd/etc
RUN mkdir /app
COPY pkgpower.py /app

RUN ls -ltr /app

ENTRYPOINT ["/opt/collectd/sbin/collectd", "-f"]