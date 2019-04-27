FROM alpine:3.9

MAINTAINER tsaikd <tsaikd@gmail.com>

ENV OVPN_DATA=/openvpn
ENV EASYRSA=/usr/share/easy-rsa
ENV EASYRSA_PKI=${OVPN_DATA}/pki
ENV EASYRSA_VARS_FILE ${OVPN_DATA}/vars
ENV EASYRSA_BATCH=true

RUN apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator && \
	ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
	rm -rf /var/cache/apk/*
ADD openvpn.conf /etc/openvpn/openvpn.conf
ADD bin /usr/local/bin/
ADD docker-start.sh /usr/local/bin/

CMD docker-start.sh
