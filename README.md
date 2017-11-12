# Docker image for Google Cloud Directory Sync

After `run` (or `up`) we need to get the OAuth token for the google login. Run:
```
docker-compose exec gcds /usr/local/scripts/auth.sh
```
or
```
docker exec -it gcds /usr/local/scripts/auth.sh
```
and follow the instructions. The script attempts a dry-run sync after authenticating.

The OAuth token survives a `restart` but after re-build the image the `auth.sh` script needs to be called again. 

## Volumes

| Directory | Description |
|-----------|-------------|
| `/var/log/gcds` | GCDS log output directory |
| `/assets/config` | Mount a directory containing your GCDS config xml file. This file MUST be called `gcds-config.xml`. The file will be modified by the container. |

## Environment Variables

| Var | Description | Default |
|-----------|-------------|------------|
| `HOST` | The hostname of your LDAP server | `localhost` |
| `PORT` | The port of your LDAP server |`10389` |
| `LDAP_PW` | The password of your LDAP admin user | `secret` |
| `DOMAIN` | Domain name for your GSuite | `example.com` |
| `DRY_RUN` | If `TRUE` doesn't apply changes to GSuite | `TRUE` |
| `CRON_EXP` | Cron expression for the gcds sync runs | `* * * * *` |

## Compose

```
  gcds:
    image: "nborrmann/gcds"
    environment:
      - LDAP_PW=secret
      - DOMAIN=example.com
      - HOST=ldap
      - PORT=10389
      - DRY_RUN=TRUE
      - CRON_EXP=* * * * *
    volumes:
      - ./config:/assets/config/
      - /var/log/gcds:/var/log/gcds
    links:
      - ldap:ldap
```
