docker run -d -p 5000:5000 --restart=always --name gcr-registry-mirrors \
-v `pwd`/gcr:/var/lib/registry \
-e STANDALONE=false \
-e REGISTRY_PROXY_REMOTEURL=https://gcr.io \
-e ENABLE_DOCKER_REGISTRY_CACHE=true \
registry

docker run -d -p 5001:5000 --restart=always --name quay-registry-mirrors \
-v `pwd`/quay:/var/lib/registry \
-e STANDALONE=false \
-e REGISTRY_PROXY_REMOTEURL=https://quay.io \
-e ENABLE_DOCKER_REGISTRY_CACHE=true \
registry


BASEPATH=$(cd `dirname $0`; pwd)
${BASEPATH}/caddy --conf ${BASEPATH}/Caddyfile
