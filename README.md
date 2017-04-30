docker-openvpn
==============

OpenVPN server in a Docker container complete with an EasyRSA PKI CA.

## Quick Start

* Prepare data storage in host folder

```
mkdir -p /data/openvpn
```

* Start OpenVPN server container

```
docker run \
	--name OPENVPN
	--cap-add NET_ADMIN \
	-p 1194:1194 \
	-v "/data/openvpn:/openvpn" \
	tsaikd/docker-openvpn
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

## Reference

* https://github.com/kylemanna/docker-openvpn
