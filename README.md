[![Build Status](https://travis-ci.org/V3ckt0r/nginx-crl-check.svg?branch=master)](https://travis-ci.org/V3ckt0r/docker-nginx-openssl1.0.2)

# mon-crl-check
A dockerized fork for nginx 1.12.0 customised to only check CRL leafe nodes.

## What's inside
 - Nginx 1.12.0 build from source and installed
 - Openssl 1.0.2 build from source and installed
 - Nginx http_v2_module
 - Nginx http_stub_status_module
 - Nginx http_realip_module
 - Nginx X509_V_FLAG_CRL_CHECK only, no X509_V_FLAG_CRL_CHECK_ALL included

## Purpose
This image does a number of things:
 - Compiles Openssl 1.0.2 from source.
 - Compiles Nginx 1.12.0 from source. The version compiled is default 1.12.0, however this image makes changes to the src to make Nginx only check leafe nodes for CRLs. This is required if your organisation do not issue CRLs for the root CA. Nginx expects CRLs for every CA chain, this fork makes it so it will work with just leafe nodes.

## Further information
If looking for an RPM equivalent you can find one [here](https://github.com/bbc/nginx-centos).

## Roadmap
 - There is no intention to maintain this going forwards. Rather than doing this for the long term, you should get your organisation to start issuing CRLs for Root CAs.
