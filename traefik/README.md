# Traefik documentation

## Installation guide

1. `cp .env.dist .env`
2. In .env file :
   1. Add project email for letsencrypt
   2. Add project domain (ex: hellovisio.staging.agily.fr)
   3. Add usr and pwd for the dashboard
3. `docker-compose up -d`

## Configuration of a service with traefik

1. Copy this code bloc for each service

   ```yml
   # Enable Traefik to listen to the docker socket
   labels:
      # General traefik settings
      - "traefik.enable=true" # <== Enabling traefik to manage this container
      - "traefik.docker.network=${TRAEFIK_NETWORK_NAME}" # <== The network traefik will operate on the docker network named traefik-net
      # HTTP to HTTPS settings
      - "traefik.http.routers.SERVICE_NAME-secure.entrypoints=websecure" # <== The entrypoint HTTPS
      - "traefik.http.routers.SERVICE_NAME-secure.rule=Host(`${DOMAIN_NAME}`)" # <== The rule to match the request
      # Let's Encrypt settings
      - "traefik.http.routers.SERVICE_NAME-secure.tls=true" # Enable TLS
      - "traefik.http.routers.SERVICE_NAME-secure.tls.certresolver=lets-encrypt" # <== The certificate resolver to use
      # # Create middleware
      # - "traefik.http.routers.SERVICE_NAME-secure.middlewares=SERVICE_NAME-compress" # Create traefik-compress middleware
      # - "traefik.http.routers.SERVICE_NAME-secure.middlewares=SERVICE_NAME-header" # Create traefik-header middleware
      # Traefik compress settings
      - "traefik.http.middlewares.SERVICE_NAME-compress.compress=true" # <== Enable compression
      # Traefik header settings
      ## SSL settings
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.sslRedirect=true" # <== Enabling SSL redirection
      ## STS settings
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.stsSeconds=31536000" # <== Setting STS seconds
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.stsIncludeSubdomains=true" # <== Enabling STS include subdomain
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.stsPreload=true" # <== Enabling STS preload
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.forceSTSHeader=true" # <== Enabling force STS header
      ## Security settings
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.framedeny=true" # <== Preventing clickjacking
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.browserxssfilter=true" # <== Preventing XSS
      # - "traefik.http.middlewares.SERVICE_NAME-header.headers.contentTypeNosniff=true" # <== Preventing MIME sniffing
      - "traefik.http.middlewares.SERVICE_NAME-header.headers.referrerPolicy=same-origin" # <== Preventing Referrer leakage
      ## Cache settings
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.maxTtl=300" # <== Setting the max TTL time
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.maxAge=300" # <== Setting the max age time
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.maxStale=300" # <== Setting the max stale time
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.minFresh=300" # <== Setting the min fresh time
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.sharedMaxAge=300" # <== Setting the shared max age time
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.noCache=false" # <== Enabling cache
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.noStore=false" # <== Enabling store
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.noTransform=false" # <== Enabling transform
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.mustRevalidate=true" # <== Enabling revalidation
      - "traefik.http.middlewares.SERVICE_NAME-header.plugin.httpCache.proxyRevalidate=true" # <== Enabling proxy revalidation
      # Traefik loadbalancer settings
      - "traefik.http.services.SERVICE_NAME-secure.loadbalancer.server.port=PORT_NUMBER" # <== The port to use
      # Traefik basic auth settings
      - "traefik.http.middlewares.SERVICE_NAME-auth.basicauth.users=${BASIC_AUTH_USR}:${BASIC_AUTH_PWD}" # <== Enabling basic auth
   ```

2. Replace each **SERVICE_NAME** with the name of your service (ex: back, front, ...)
3. Replace **PORT_NUMBER** by your service port (ex: 34001, 34002, ...)
4. Add this network to docker-compose.yml

    ```yml
    networks:
      traefik-net:
         name: ${TRAEFIK_NETWORK_NAME}
         external: true
   ```

5. Add to each network service the following code:

    ```yml
    networks:
      - traefik-net
    ```

6. Add `TRAEFIK_NETWORK_NAME=traefik-net` to your .env file
7. Add `DOMAIN_NAME=YOUR_DOMAIN_NAME` to your .env file if needed
8. (Optional) You can add basic auth in your service, set `BASIC_AUTH_USR` and `BASIC_AUTH_PWD` to your .env file, don't forget to set a user and password
   1. To create a new user and password, install the following command `sudo apt install apache2-utils` (or use `brew install apache2-utils`)
   2. Use this command to create a new user and password, `htpasswd -nB test` (you can change the 'test' and define another username)
   3. /!\ Don't forget to double $ !!! /!\\
9. (Optional) You can add an subdomain to your service (ex: `${SUBDOMAIN}.${DOMAIN_NAME}`)
