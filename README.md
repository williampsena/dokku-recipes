# Intro

[Dokku](https://dokku.com) is an open source Platform as a Service that runs on a single server. In a nutshell, we can utilize **Dokku** as our Heroku server. *Dockerfiles* and *Buildpacks* are supported by **Dokku**. There are lots of plugins available, including MongoDB, MySQL, Redis, Postgres, Elasticsearch, RabbitMQ, and more.

This repository offers an example Dokku as Container, which is an easy way to test locally. We can install directly to our host or as a Pod in Kubernetes; [installation instructions are available](https://dokku.com/docs/getting-started/installation/).
# Startup

```
docker compose up -d
```

## Set up environment

After startup container we need to setup **Dokku**, install plugins and prepare the app named `web`.

```shell
sh scripts/setup.sh all 
```
## Proxy management

**Dokku** uses NGINX at host context, so private network are not reachable, when there is no publish port, so I choose Caddy to work as proxy. **Dokku** has an available proxy list, check out.

- [Caddy](https://dokku.com/docs/networking/proxies/caddy/)
- [Traefik](https://dokku.com/docs/networking/proxies/traefik/)
- [HAProxy](https://dokku.com/docs/networking/proxies/haproxy/)
- [NGINX](https://dokku.com/docs/networking/proxies/nginx/)

# Testing application

```shell
docker compose logs -f dokku 
```

# Remember to set your 

/etc/hosts:

```
127.0.1.1       localhost     dokku.me node.dokku.me web.dokku.me
```
# Removing Dokku container

Take care! This command removes the **Dokku** container, however child containers such as MongoDB and Proxy remain running and must be removed manually.


```shell
docker compose down --rmi local
```

Child containers generate data in this place (/var/lib/dokku/), which I recommend removing before rebuilding.

```shell
sudo rm -rf /var/lib/dokku/
```