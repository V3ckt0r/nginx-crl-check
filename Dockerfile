FROM debian:jessie
Maintainer V3ckt0r
LABEL Vendor="Nginx http2 openssl1.0.2j ALPN"

# Install packages
RUN apt-get update && apt-get install -y ca-certificates build-essential wget libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libperl-dev curl

#Compile openssl
ENV OPENSSL_VERSION ${OPENSSL_VERSION:-1_0_2j}
RUN wget https://github.com/openssl/openssl/archive/OpenSSL_${OPENSSL_VERSION}.tar.gz \
  && tar -xvzf OpenSSL_${OPENSSL_VERSION}.tar.gz \
  && cd openssl-OpenSSL_${OPENSSL_VERSION} \
  && ./config \
    --prefix=/usr \
    --openssldir=/usr/ssl \
  && make && make install \
  && ./config shared \
    --prefix=/usr/local \
    --openssldir=/usr/local/ssl \
  && make clean \
&& make && make install

#Install and compile nginx
#ENV NGINX_VERSION ${NGINX_VERSION:-1.11.1}

# keep below for when BBC start issuing CRLs for Root CAs and back to master NGINX
#RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
#  && tar -xzvf nginx-${NGINX_VERSION}.tar.gz

# build from source
COPY source/nginx-1.12.0.tar.gz .
RUN tar -xzvf nginx-1.12.0.tar.gz

# keep below for when BBC start issuing CRLs for Root CAs and back to master NGINX
#COPY conf /nginx-${NGINX_VERSION}/auto/lib/openssl/
COPY conf /nginx-1.12.0/auto/lib/openssl/
COPY ngx_event_openssl.c /nginx-1.12.0/src/event/ngx_event_openssl.c

#add nginxx user and group
RUN addgroup nginx \
  && adduser --system --no-create-home --disabled-login --disabled-password --group nginx

# keep below for when BBC start issuing CRLs for Root CAs and back to master NGINX
#RUN cd nginx-${NGINX_VERSION} \
RUN cd nginx-1.12.0 \
  && ./configure \
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-openssl=/usr \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-ipv6 \
    --with-http_perl_module=dynamic \
  && make \
&& make install

RUN apt-get purge build-essential -y \
&& apt-get autoremove -y

# redirect nginx logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN rm -rf /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx"]
