# mikafouenski/supysonic
Dockerize [Supysonic](https://github.com/spl0k/supysonic)

## Usage

```
docker create \
    --name supysonic\
    -p 8000:8000 \
    -e PUID=<UID> -e PGID=<GID> \
    -e WORKERS=<nbthread> \ 
    -e WATCHER=0 \ 
    -v </path/to/appdata>:/config \
    -v <path/to/music>:/music:ro \
    mikafouenski/supysonic
```

* `-p 8000` - the port supysonic webinterface
* `-v /config` - database and supysonic configs
* `-v /music` - location of music library on disk (ro = readonly)
* `-e PGID` for for GroupID, default 2000 - see below for explanation
* `-e PUID` for for UserID, default 2000 - see below for explanation
* `-e WORKERS` for the number of threads, default 4
* `-e WATCHER` start the supysonic watcher processus to refresh librairy automaticaly. default = 1 (run it !)

Docker-compose exemple :
```
  supysonic:
    image: 'mikafouenski/supysonic'
    container_name: 'supysonic'
    restart: 'unless-stopped'
    environment:
      - PUID=<UID>
      - PGID=<GID>
    volumes:
      - '</path/to/appdata>:/config'
      - '<path/to/music>:/music'
    ports:
      - 8000:8000
```

It is based on alpine 3.7 with [S6 overlay](http://skarnet.org/software/s6/index.html).

## Supysonic init

Once the container is running we can create users with the client interface :
```
docker exec -it supysonic supysonic-cli
```

Ex: 
* Create an admin user: `user add -a <username>`
* Add a folder and scan it: `folder add Music /music` and then `folder scan Music`

The documentation of theses commands can be found on the supysonic project ([here](https://github.com/spl0k/supysonic/blob/master/docs/cli.md)).

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" <sup>TM</sup>.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
Access the webui at `<your-ip>:8000`.

