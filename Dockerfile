FROM kalilinux/kali-rolling

CMD ["bash"]
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt install -y wget gnupg
RUN wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add
RUN echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" | tee /etc/apt/sources.list
RUN apt install -y golang git curl  kali-tools-top10

# RUN apt-get update && apt-get install -y autoconf automake curl cmake git libtool make \
#    && git clone --depth=1 https://github.com/tsl0922/ttyd.git /ttyd \
#    && cd /ttyd && env BUILD_TARGET=x86_64 WITH_SSL=true ./scripts/cross-build.sh
RUN sudo apt-get install -y build-essential cmake git libjson-c-dev libwebsockets-dev \
    && git clone https://github.com/tsl0922/ttyd.git \
    && cd ttyd && mkdir build && cd build \
    && cmake .. \
    && make && make install

#FROM ubuntu:18.04
# COPY --from=0 /ttyd/build/ttyd /usr/bin/ttyd

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini

EXPOSE 7681
WORKDIR /root

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "bash"]
