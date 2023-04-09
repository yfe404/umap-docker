FROM python:3.8-slim

RUN set -eux && \
    mkdir -p /srv/umap /etc/umap /srv/umap/data /srv/umap/uploads && \
    useradd -N umap -d /srv/umap/ -s /bin/bash && \
    chown -R umap:users /etc/umap /srv/umap && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3-virtualenv \
        build-essential \
        libpq-dev \
        python3.9-dev \
        gdal-bin \
        uwsgi \
        uwsgi-plugin-python3 \
    && \
    su - umap -c "virtualenv /srv/umap/venv --python=/usr/bin/python3.9" && \
    su - umap -c "source /srv/umap/venv/bin/activate; pip install umap-project django-environ==0.9.0 django-redis==4.7.0" && \
    sed -i 's/ value="{{ q|default:"" }}"//' /srv/umap/venv/lib/python3.9/site-packages/umap/templates/umap/search_bar.html && \
    apt-get purge -y build-essential libpq-dev python3.9-dev && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/must_revalidate/no_cache/' /srv/umap/venv/lib/python3.9/site-packages/umap/urls.py

ADD umap.conf /etc/umap/umap.conf
ADD uwsgi.ini /srv/umap/uwsgi.ini
ADD drop-privileges.sh /srv/umap/drop-privileges.sh
ADD docker-entrypoint.sh /srv/umap/docker-entrypoint.sh

EXPOSE 80/tcp

# Add Tini
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--"]

CMD ["/srv/umap/docker-entrypoint.sh"]
