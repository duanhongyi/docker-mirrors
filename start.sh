mkdir -p `pwd`/tmp
ip=$(ifconfig eth0 | grep "inet" | awk '{print $2}')
cp -rf  `pwd`/rootfs/etc/sniproxy.tpl `pwd`/rootfs/etc/sniproxy.conf
sed -i "s/gcr-registry-mirrors:5000/$ip:5000/g" `pwd`/rootfs/etc/sniproxy.conf
sed -i "s/quay-registry-mirrors:5000/$ip:5001/g" `pwd`/rootfs/etc/sniproxy.conf

docker run -d -p 5000:5000 --restart=always --name gcr-registry-mirrors \
-v `pwd`/tmp/gcr:/var/lib/registry \
-e STANDALONE=false \
-e REGISTRY_PROXY_REMOTEURL=https://gcr.io \
-e ENABLE_DOCKER_REGISTRY_CACHE=true \
registry

docker run -d -p 5001:5000 --restart=always --name quay-registry-mirrors \
-v `pwd`/tmp/quay:/var/lib/registry \
-e STANDALONE=false \
-e REGISTRY_PROXY_REMOTEURL=https://quay.io \
-e ENABLE_DOCKER_REGISTRY_CACHE=true \
registry

docker run -d -p 80:80 -p 443:443 --restart=always --name sniproxy \
-v `pwd`/rootfs/etc/sniproxy.conf:/etc/sniproxy.conf \
uucin/sniproxy:latest
