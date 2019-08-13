cat > ${COREDNS_DIRECTORY}/db.${DOMAIN_NAME} << 'EOF'
$ORIGIN DOMAIN_NAME.
$TTL 10800      ; 3 hours
@       3600 IN SOA helper.DOMAIN_NAME. ocp.DOMAIN_NAME. (
                                2019010101 ; serial
                                7200       ; refresh (2 hours)
                                3600       ; retry (1 hour)
                                1209600    ; expire (2 weeks)
                                3600       ; minimum (1 hour)
                                )

helper.DOMAIN_NAME.                                  A                LB_IP
_etcd-server-ssl._tcp.CLUSTER_NAME.DOMAIN_NAME. 8640 IN    SRV 0 10 2380 etcd-0.CLUSTER_NAME.DOMAIN_NAME.

api.CLUSTER_NAME.DOMAIN_NAME.                        A                LB_IP
api-int.CLUSTER_NAME.DOMAIN_NAME.                    A                LB_IP
CLUSTER_NAME-master-0.DOMAIN_NAME.                   A                MASTER0_IP
CLUSTER_NAME-worker-0.DOMAIN_NAME.                   A                WORKER0_IP
CLUSTER_NAME-bootstrap.DOMAIN_NAME.                  A                BOOTSTRAP_IP
etcd-0.CLUSTER_NAME.DOMAIN_NAME.                     IN  CNAME CLUSTER_NAME-master-0.DOMAIN_NAME.

$ORIGIN apps.CLUSTER_NAME.DOMAIN_NAME.
*                                                    A                LB_IP
EOF
