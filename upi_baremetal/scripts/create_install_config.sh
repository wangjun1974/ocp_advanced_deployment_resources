cat > ~/ocp-clusters/${CLUSTER_NAME}-install-config.yaml << EOF
apiVersion: v1
baseDomain: ${DOMAIN_NAME}
compute:
- name: worker
  replicas: 0
controlPlane:
  name: master
  replicas: 3
metadata:
  name: ${CLUSTER_NAME}
networking:
  clusterNetworks:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
pullSecret: |
  ${PULL_SECRET}
sshKey: |
  ${SSH_KEY}
EOF

cp ~/ocp-clusters/${CLUSTER_NAME}-install-config.yaml \
   ~/ocp-clusters/${CLUSTER_NAME}/install-config.yaml
