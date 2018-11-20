user nobody

pidfile /var/run/sniproxy.pid

resolver {
    nameserver 8.8.8.8 8.8.4.4
}

listen 80 {
    proto http
    table http_hosts
}

listen 443 {
    proto tls
    table https_hosts
}

table http_hosts {
    gcr.io gcr-registry-mirrors:5000
    quay.io quay-registry-mirrors:5000
    .* *:80
}

table https_hosts {
    .* *:443
}
