FROM ubuntu:14.04

MAINTAINER tsaikd <tsaikd@gmail.com>

ENV OVPN_DATA=/openvpn
ENV EASYRSA=/usr/local/easy-rsa/easyrsa3
ENV EASYRSA_PKI=${OVPN_DATA}/pki
ENV EASYRSA_BATCH=true

RUN apt-get update
RUN apt-get install -qy openvpn iptables git
RUN git clone "https://github.com/OpenVPN/easy-rsa" "/usr/local/easy-rsa"
ADD openvpn.conf /etc/openvpn/openvpn.conf
ADD bin /usr/local/bin/
ADD docker-start.sh /usr/local/bin/

CMD docker-start.sh

