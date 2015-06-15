#!/bin/bash

if [ "$(find "${EASYRSA_PKI}" 2>/dev/null | wc -l)" -lt 2 ] ; then
	easyrsa init-pki
	easyrsa build-ca nopass
	easyrsa gen-dh
	easyrsa gen-crl
	openvpn --genkey --secret "${EASYRSA_PKI}/ta.key"
	easyrsa build-server-full "server" nopass
fi

mkdir -p /etc/openvpn/ccd

if [ -w "/sys" ] ; then
	mkdir -p /dev/net
	if [ ! -c /dev/net/tun ] ; then
		mknod /dev/net/tun c 10 200
	fi

	iptables -t nat -A POSTROUTING -s 192.168.255.0/24 -o eth0 -j MASQUERADE

	sed -i "s|\${EASYRSA_PKI}|${EASYRSA_PKI}|g" "/etc/openvpn/openvpn.conf"

	openvpn --config "/etc/openvpn/openvpn.conf"
else
	echo "Please run container in privileged mode!"
	exit 1
fi

