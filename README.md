# uMap project container

[uMap](https://github.com/umap-project/umap) lets you create maps with OpenStreetMap layers in a minute and embed them in your site.

* Python3.8 slim based image
* uMap 1.2.3

# Supported tags and respective `Dockerfile` links

-	[`1.2.3`](https://git.nethuis.nl/pommi/docker-umap/src/branch/master/Dockerfile)

# Usage

## Environment variables

| Key | Format | Description |
| --- | --- | --- |
| DATABASE_URL | `postgis://postgres@postgis/postgres` | Postgis endpoint |
| REDIS_URL | `redis://redis:6379/0` | Redis endpoint |
| SECRET_KEY |  | Used by Django to secure signed data |
| ALLOWED_HOSTS | `*` | The host/domain names that this Django site can serve |
| SITE_URL | `https://umap.example.tld/` | Where this Django site is located |
| LEAFLET_STORAGE_ALLOW_ANONYMOUS | `True` | Allow non authenticated people to create maps |

## docker-compose

```
version: '3'
services:
  postgis:
    image: postgis/postgis:12-3.3
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
    volumes:
      - postgis:/var/lib/postgresql/data

  redis:
    image: redis:latest

  umap:
    image: pommib/umap:1.2.3
    ports:
      - "8000:80"
    environment:
      - DATABASE_URL=postgis://postgres@postgis/postgres
      - REDIS_URL=redis://redis:6379/0
      - SECRET_KEY=some-long-and-weirdly-unrandom-secret-key
      - ALLOWED_HOSTS=*
      - SITE_URL=https://umap.example.tld/
      - LEAFLET_STORAGE_ALLOW_ANONYMOUS=True
    depends_on:
      - postgis
      - redis

volumes:
  postgis:
  uploads:
```
