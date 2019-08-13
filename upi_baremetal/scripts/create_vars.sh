cat > ~/vars << EOF
# RHCOS and OCP4 versions
# From https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.1/
export RHCOSVERSION="4.1.8"
# From https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/
export OCPVERSION="4.1.8"

# Where to store the required files
export NGINX_DIRECTORY="/home/ocp/containers/nginx"
export HAPROXY_DIRECTORY="/home/ocp/containers/haproxy"
export COREDNS_DIRECTORY="/home/ocp/containers/coredns"

# Network details
export DOMAIN_NAME="rhcnsa.org"
export CLUSTER_NAME="cluster-0001"
export GATEWAY="10.66.208.254"
export NETMASK="255.255.255.0"
export DNSFORWARDER="10.66.208.138"

# Hosts
export BOOTSTRAP_IP="10.66.208.139"
export MASTER0_IP="10.66.208.140"
export MASTER1_IP="10.66.208.143"
export MASTER2_IP="10.66.208.144"
export WORKER0_IP="10.66.208.141"

# We will use a single interface for the OCP4 cluster network traffic (same one in all hosts)
export NET_INTERFACE="ens3"

# We will use this host as DNS, static assets server and haproxy
export MY_IP="10.66.208.138"
export DNS="\${MY_IP}"
export URL="http://\${MY_IP}:8001"
export LB_IP="\${MY_IP}"

# Required to extract the ISO content with guestfish without any virtualization stuff installed
export LIBGUESTFS_BACKEND=direct

export SSH_KEY=\$(cat ~/.ssh/id_rsa.pub)
# This may not work until the pull_secret is created
export PULL_SECRET=\$(cat ~/ocp-clusters/pull_secret.json)
EOF
