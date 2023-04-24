# Startup

```
docker-compose up -d
```

## Set up environment

After startup container we need to setup Dokku, install plugins and prepare the app named `web`.

```shell
sh scripts/setup.sh all 
```
## Proxy management

Dokku uses NGINX at host context, so private network are not reachable, when there is no publish port, so I choose Caddy to work as proxy. Dokku has an available proxy list, check out.

- [Caddy](https://dokku.com/docs/networking/proxies/caddy/)
- [Traefik](https://dokku.com/docs/networking/proxies/traefik/)
- [HAProxy](https://dokku.com/docs/networking/proxies/haproxy/)
- [NGINX](https://dokku.com/docs/networking/proxies/nginx/)

# Testing application

```shell
docker-compose logs -f app 
```

# Remember to set your 

/etc/hosts:

```
127.0.1.1       localhost     dokku.me node.dokku.me web.dokku.me
```
# Removing Dokku container

Take care! This command removes the Dokku container, however child containers such as MongoDB and Proxy remain running and must be removed manually.


```shell
docker-compose down --rmi local
```