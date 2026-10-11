# picapport

[PicApport](https://www.picapport.de/) (headless server) in a small Alpine-based container. PicApport is a web-based photo server that indexes your photo folders and lets you browse, search and share them in the browser.

Fork of [whatever4711/picapport](https://github.com/whatever4711/picapport) by Marcel Grossmann, rebuilt regularly with current security patches.

- **Image:** `gerald77/picapport`
- **Tags:** `latest`
- **Source:** https://github.com/geraldpublic/picapport
- **Platform:** `linux/amd64`
- **Base:** Alpine Linux + OpenJDK 8 JRE, `tini` as init
- **Port:** `80` (web interface, configurable)
- **Not affiliated** with the PicApport authors. This is an unofficial community image.

## Quick start

```shell
docker run -d \
    --name picapport \
    -p 8080:80 \
    -v /path/to/your/photos:/srv/photos \
    gerald77/picapport:latest
```

Then open http://localhost:8080.

## Volumes

| Path in container | Purpose |
| :-- | :-- |
| `/srv/photos` | Your photo folder (default root path scanned by PicApport) |
| `/opt/picapport/.picapport` | Configuration and PicApport data (`picapport.properties`, databases, ...) |
| `/srv/cache` | Optional cache for generated image files (see configuration below) |

```shell
docker run -d \
    --name picapport \
    -p 8080:80 \
    -v $PWD/config:/opt/picapport/.picapport \
    -v /path/to/photos:/srv/photos \
    -v /path/to/cache:/srv/cache \
    gerald77/picapport:latest
```

## Environment variables

| Variable | Default | Description |
| :-- | :-- | :-- |
| `PICAPPORT_PORT` | `80` | Port used inside the container for the default configuration |
| `XMS` | `256m` | Initial Java heap size |
| `XMX` | `1024m` | Maximum Java heap size |
| `DTRACE` | `WARNING` | Log level (`DEBUG`, `INFO`, `WARNING`, ...) |
| `LC_ALL` | - | Optional locale, e.g. `de_DE.UTF-8` |

Increase `XMX` for large photo libraries.

## Configuration

PicApport is configured with a `picapport.properties` file in the mounted configuration folder. All options are described in the [PicApport server guide](http://wiki.picapport.de/display/PIC/PicApport-Server+Guide). A minimal example:

```
server.port=80
robot.root.0.path=/srv/photos
foto.jpg.usecache=2
foto.jpg.cache.path=/srv/cache
```

If you mount an empty folder, create the file there first. Without a mounted configuration the image uses a built-in default (port, `/srv/photos` as photo root, cache enabled).

## Docker Compose

```yaml
volumes:
  cache:

services:
  picapport:
    image: gerald77/picapport:latest
    container_name: picapport
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - XMS=512m
      - XMX=1g
      - DTRACE=WARNING
      - TZ=Europe/Vienna
      - LC_ALL=de_DE.UTF-8
    volumes:
      - /path/to/your/configuration:/opt/picapport/.picapport
      - /path/to/your/photos:/srv/photos
      - cache:/srv/cache
```

Start with `docker compose up -d`.

## Notes

- Put PicApport behind a reverse proxy with HTTPS (e.g. Nginx Proxy Manager) if you expose it to the internet, and use PicApport's own user management.
- The PicApport program itself (`picapport-headless.jar`) is downloaded from the official PicApport website when the image is built.
- Mount your photos read-only (`:ro`) if PicApport should not modify them, and keep your own backups.
- The image is rebuilt automatically on every push to the source repository; pull regularly for security updates.

## License

The Docker-related files of this project (Dockerfile, scripts, configuration) are licensed under the **GNU General Public License v3.0** (GPL-3.0). See the [LICENSE](https://github.com/geraldpublic/picapport/blob/master/LICENSE) file in the source repository.

**PicApport itself is proprietary software** by its respective authors and is **not** covered by this license. It is subject to its own license and terms of use; please read them on https://www.picapport.de/ before using it. Other included software (Alpine Linux, OpenJDK, tini and others) is under its respective licenses; see `/usr/share/licenses` and `/usr/share/doc` inside the container.

Original image project: https://github.com/whatever4711/picapport (Marcel Grossmann).

## Disclaimer

THIS IMAGE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR MAINTAINERS BE LIABLE FOR ANY CLAIM, DAMAGES, DATA LOSS OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE IMAGE OR ITS USE.

PicApport and this image are not affiliated with or endorsed by each other's authors. Use at your own risk. You are responsible for securing your deployment (network access, HTTPS, users and passwords, updates) and for backing up your photos and the PicApport configuration and database.
