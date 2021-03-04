# vcontrold-docker
Docker image for https://github.com/openv/vcontrold/

## docker-compose

```
services:
  vcontrold:
    image: clemens321/vcontrold:latest
    command:
      - "--device"
      - "vi2wifi:23"
    volumes:
      - ./etc/vito.xml:/etc/vcontrold/vito.xml:ro
    restart: unless-stopped
```

## command line interface
To access the command line interface of vcontrold just execute `cli` inside the container.

```
$ docker-compose exec vcontrold cli
```

You can also just telnet to the vcontrold Port (3002 by default).

Be aware that vcontrold does not accept multiple client connections simultaniously.
If you have for example a vi2mqtt running, you have to stop that before.
