#docker network create --driver=overlay traefik
#docker network create --driver overlay --subnet=10.20.0.0/16 --gateway=10.20.0.2 --opt com.docker.network.mtu=1200 traefik

docker service create \
    --name traefik \
    --constraint=node.role==manager \
    --publish 80:80 --publish 8080:8080 --publish 443:443 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --mount type=bind,source=/gfs_mount/dswarm_services/TRAFIK/traefik.toml,target=/etc/traefik/traefik.toml \
    --mount type=bind,source=/gfs_mount/dswarm_services/TRAFIK/CERTS,target=/home/user/traefik/ssl \
    -l traefik.enable=true \
    -l traefik.frontend.passHostHeader=true \
    -l traefik.frontend.rule=Host:traefik.vlekh.net \
    -l traefik.backend=traefik \
    -l traefik.docker.network=traefik \
    -l traefik.entryPoint=https \
    -l traefik.port=8080 \
    --network traefik \
    traefik \
    --logLevel=DEBUG \
    --web \
    --web.metrics.prometheus \
    --web.metrics.prometheus.buckets="0.1,0.3,1.2,5.0" \
    --docker \
    --docker.swarmmode \
    --docker.domain=lekh.net \
    --docker.domain=vlekh.net \
    --docker.watch \
    --api
