sed -i -e "s/MASTER0_IP/${MASTER0_IP}/g" \
       -e "s/WORKER0_IP/${WORKER0_IP}/g" \
       -e "s/CLUSTER_NAME/${CLUSTER_NAME}/g" \
       -e "s/DOMAIN_NAME/${DOMAIN_NAME}/g" \
       -e "s/BOOTSTRAP_IP/${BOOTSTRAP_IP}/g" \
       -e "s/LB_IP/${LB_IP}/g" \
       ${COREDNS_DIRECTORY}/db.${DOMAIN_NAME}
