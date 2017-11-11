# Docker image for Google Cloud Directory Sync

After `run` (or `up`) we need to get the OAuth token for the google login. Run:
```
docker-compose exec gcds /usr/local/scripts/auth.sh
```
and follow the instructions. Afterwards a dry-run sync is attempted.

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
      - ./gcds-config.xml:/assets/config/gcds-config.xml
    links:
      - ldap:ldap
```

Logs are written to /var/log/gcds


