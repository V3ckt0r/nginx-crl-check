[![Build Status](https://travis-ci.org/V3ckt0r/docker-nginx-openssl1.0.2.svg?branch=master)](https://travis-ci.org/V3ckt0r/docker-nginx-openssl1.0.2)

# mon-bbc-nginx
Docker image for nginx 1.11.1 with openssl 1.0.2f and http2 module support

## What's inside
 - Nginx 1.9.6 build from source and installed
 - Openssl 1.0.2 build from source and installed
 - Nginx http_v2_module
 - Nginx http_stub_status_module
 - Nginx http_realip_module

## Purpose
This image does a number of things:
 - Compiles Openssl 1.0.2 from source.
 - Compiles Nginx 1.12.0 from source. The version compiled is default 1.12.0, however this image makes changes to the src to make Nginx only check leafe nodes for CRLs. This is required because the BBC currently do not issue CRLs for the root CA. Trying to set up CRL checking with master branch Nginx will fail for this reason, as nginx expects CRLs for every CA chain.

## Further information
If looking for an RPM equivalent you can find one [here](https://github.com/bbc/nginx-centos)

## Roadmap
 - This image will only be maintained until 2018, as this will not be an issue by then and the master branch Nginx can be used.
