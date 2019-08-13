mkdir -p ${HAPROXY_DIRECTORY}

cat > ${HAPROXY_DIRECTORY}/haproxy.cfg << EOF
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          300s
    timeout server          300s
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 20000

# Useful for debugging, dangerous for production
listen stats
    bind :9000
    mode http
    stats enable
    stats uri /

frontend openshift-api-server
    bind *:6443
    default_backend openshift-api-server
    mode tcp
    option tcplog

backend openshift-api-server
    balance source
    mode tcp
    server bootstrap ${BOOTSTRAP_IP}:6443 check
    server master-0 ${MASTER0_IP}:6443 check
    server master-1 ${MASTER1_IP}:6443 check
    server master-2 ${MASTER2_IP}:6443 check

frontend machine-config-server
    bind *:22623
    default_backend machine-config-server
    mode tcp
    option tcplog

backend machine-config-server
    balance source
    mode tcp
    server bootstrap ${BOOTSTRAP_IP}:22623 check
    server master-0 ${MASTER0_IP}:22623 check
    server master-1 ${MASTER1_IP}:22623 check
    server master-2 ${MASTER2_IP}:22623 check

# As we are using rootless containers, we will bind to the 8080/tcp port in the host
# so we can map 1:1 (and then firewalld will perform the redirection)
frontend ingress-http
    bind *:8080
    default_backend ingress-http
    mode tcp
    option tcplog

backend ingress-http
    balance source
    mode tcp
    server worker-0 ${WORKER0_IP}:80 check

# As we are using rootless containers, we will bind to the 8443/tcp port in the host
# so we can map 1:1 (and then firewalld will perform the redirection)   
frontend ingress-https
    bind *:8443
    default_backend ingress-https
    mode tcp
    option tcplog

backend ingress-https
    balance source
    mode tcp
    server worker-0 ${WORKER0_IP}:443 check
EOF
