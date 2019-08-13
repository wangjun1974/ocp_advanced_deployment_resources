#!/bin/bash

source ~/vars

for i in 139 140 143 144 141
do
  ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" core@10.66.208.$i 'sudo dd if=/dev/zero of=/dev/sda bs=1024k count=100'
done

rm -rf ~/ocp-clusters/${CLUSTER_NAME}
mkdir -p ~/ocp-clusters/${CLUSTER_NAME}

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

openshift-install create ignition-configs --dir=$(readlink -f ~/ocp-clusters/${CLUSTER_NAME})
cp ~/ocp-clusters/${CLUSTER_NAME}/*.ign ${NGINX_DIRECTORY}

sh ~/update_ignition.sh

pushd ${NGINX_DIRECTORY}
for i in bootstrap master-0 master-1 master-2 worker-0
do
  cp $i.ign $i.ign.json
  cp $i.ign.orig $i.ign
done

sed -i 's|"storage":{"files":\[|"storage":{"files":\[{"filesystem":"root","path":"/etc/hostname","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,Y2x1c3Rlci0wMDAxLWJvb3RzdHJhcC5yaGNuc2Eub3JnCg==","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/sysconfig/network-scripts/ifcfg-ens3","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,REVWSUNFPWVuczMKQk9PVFBST1RPPW5vbmUKT05CT09UPXllcwpORVRNQVNLPTI1NS4yNTUuMjU1LjAKSVBBRERSPTEwLjY2LjIwOC4xMzkKR0FURVdBWT0xMC42Ni4yMDguMjU0ClBFRVJETlM9bm8KRE5TMT0xMC42Ni4yMDguMTM3CklQVjZJTklUPW5vCg==","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/NetworkManager/conf.d/hostname-mode.conf","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,W21haW5dCmhvc3RuYW1lLW1vZGU9bm9uZQo=","verification":{}},"mode":420},|' bootstrap.ign

sed -i 's|"storage":{}|"storage":{"files":\[{"filesystem":"root","path":"/etc/hostname","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,Y2x1c3Rlci0wMDAxLW1hc3Rlci0wLnJoY25zYS5vcmcK","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/sysconfig/network-scripts/ifcfg-ens3","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,REVWSUNFPWVuczMKQk9PVFBST1RPPW5vbmUKT05CT09UPXllcwpORVRNQVNLPTI1NS4yNTUuMjU1LjAKSVBBRERSPTEwLjY2LjIwOC4xNDAKR0FURVdBWT0xMC42Ni4yMDguMjU0ClBFRVJETlM9bm8KRE5TMT0xMC42Ni4yMDguMTM3CklQVjZJTklUPW5vCg==","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/NetworkManager/conf.d/hostname-mode.conf","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,W21haW5dCmhvc3RuYW1lLW1vZGU9bm9uZQo=","verification":{}},"mode":420}\]}|' master-0.ign

sed -i 's|"storage":{}|"storage":{"files":\[{"filesystem":"root","path":"/etc/hostname","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,Y2x1c3Rlci0wMDAxLW1hc3Rlci0xLnJoY25zYS5vcmcK","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/sysconfig/network-scripts/ifcfg-ens3","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,REVWSUNFPWVuczMKQk9PVFBST1RPPW5vbmUKT05CT09UPXllcwpORVRNQVNLPTI1NS4yNTUuMjU1LjAKSVBBRERSPTEwLjY2LjIwOC4xNDMKR0FURVdBWT0xMC42Ni4yMDguMjU0ClBFRVJETlM9bm8KRE5TMT0xMC42Ni4yMDguMTM3CklQVjZJTklUPW5vCg==","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/NetworkManager/conf.d/hostname-mode.conf","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,W21haW5dCmhvc3RuYW1lLW1vZGU9bm9uZQo=","verification":{}},"mode":420}\]}|' master-1.ign

sed -i 's|"storage":{}|"storage":{"files":\[{"filesystem":"root","path":"/etc/hostname","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,Y2x1c3Rlci0wMDAxLW1hc3Rlci0yLnJoY25zYS5vcmcK","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/sysconfig/network-scripts/ifcfg-ens3","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,REVWSUNFPWVuczMKQk9PVFBST1RPPW5vbmUKT05CT09UPXllcwpORVRNQVNLPTI1NS4yNTUuMjU1LjAKSVBBRERSPTEwLjY2LjIwOC4xNDQKR0FURVdBWT0xMC42Ni4yMDguMjU0ClBFRVJETlM9bm8KRE5TMT0xMC42Ni4yMDguMTM3CklQVjZJTklUPW5vCg==","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/NetworkManager/conf.d/hostname-mode.conf","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,W21haW5dCmhvc3RuYW1lLW1vZGU9bm9uZQo=","verification":{}},"mode":420}\]}|' master-2.ign

sed -i 's|"storage":{}|"storage":{"files":\[{"filesystem":"root","path":"/etc/hostname","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,Y2x1c3Rlci0wMDAxLXdvcmtlci0wLnJoY25zYS5vcmcK","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/sysconfig/network-scripts/ifcfg-ens3","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,REVWSUNFPWVuczMKQk9PVFBST1RPPW5vbmUKT05CT09UPXllcwpORVRNQVNLPTI1NS4yNTUuMjU1LjAKSVBBRERSPTEwLjY2LjIwOC4xNDEKR0FURVdBWT0xMC42Ni4yMDguMjU0ClBFRVJETlM9bm8KRE5TMT0xMC42Ni4yMDguMTM3CklQVjZJTklUPW5vCg==","verification":{}},"mode":420},{"filesystem":"root","path":"/etc/NetworkManager/conf.d/hostname-mode.conf","user":{"name":"root"},"contents":{"source":"data:text/plain;charset=utf-8;base64,W21haW5dCmhvc3RuYW1lLW1vZGU9bm9uZQo=","verification":{}},"mode":420}\]}|' worker-0.ign

popd

cd ~

sh -x ~/modify-iso.sh


for i in `seq 139 144`
do
  ssh-keygen -R 10.66.208.$i
done

mkdir -p ~/.kube/
cp ~/ocp-clusters/${CLUSTER_NAME}/auth/kubeconfig ~/.kube/config


ssh root@10.66.208.60 '/bin/bash -x ~/download.sh'
ssh root@10.66.208.60 '/bin/bash -x ~/upload.sh'
