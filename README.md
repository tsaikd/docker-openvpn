docker-openvpn
==============

OpenVPN server (or client) in a Docker container complete with an EasyRSA PKI CA.

## Quick Start VPN server

* Prepare data storage in host folder

```
mkdir -p /data/openvpn
```

* Start OpenVPN server container

```
docker run \
	--name OPENVPN \
	--cap-add NET_ADMIN \
	-e OPENVPN_PROTO=tcp \
	-p 1194:1194 \
	-v "/data/openvpn:/openvpn" \
	tsaikd/openvpn
```

* Generate a client certificate without a passphrase

```
docker exec "OPENVPN" easyrsa build-client-full CLIENTNAME nopass
```

* Retrieve the client configuration with embedded certificates
	* PROTO: tcp | udp
	* IP: openvpn server IP, used for connection of client
	* PORT: openvpn server port, used for connection of client

```
docker exec "OPENVPN" ovpn_getclient CLIENTNAME PROTO IP PORT > CLIENTNAME.ovpn
```

* Revoke the client certificate

```
docker exec "OPENVPN" ovpn_revoke CLIENTNAME
```

## Issues

* CRL expired
```
TCP connection established with [AF_INET]XXX.XXX.XXX.XXX:XXXXX
TLS: Initial packet from [AF_INET]XXX.XXX.XXX.XXX:XXXXX, sid=XXXXXXXX XXXXXXXX
VERIFY ERROR: depth=0, error=CRL has expired: CN=XXXXX
OpenSSL: error:140360B2:SSL routines:ACCEPT_SR_CERT:no certificate returned
TLS_ERROR: BIO read tls_read_plaintext error
TLS Error: TLS object -> incoming plaintext read error
TLS Error: TLS handshake failed
```

> run the following command to regenerate easyrsa CRL
```
docker exec "OPENVPN" easyrsa gen-crl
```

## Reference

* https://github.com/kylemanna/docker-openvpn

## OpenVPN client mode

* Create client docker container

```
docker run \
	--name VPNCLIENT \
	--cap-add NET_ADMIN \
	--device /dev/net/tun \
	-v "/data/CLIENTNAME.ovpn:/openvpn/client.ovpn" \
	tsaikd/openvpn \
	openvpn --config /openvpn/client.ovpn
```

* Use VPN in other containers

```
docker run \
	--net=container:VPNCLIENT \
	alpine:3.7

$ apk add --no-cache curl
$ curl http://ifconfig.io
```

