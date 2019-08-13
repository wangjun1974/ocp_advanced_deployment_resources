export BIOSMODE="bios"
export VOLID=$(isoinfo -d -i ${NGINX_DIRECTORY}/rhcos-${RHCOSVERSION}-x86_64-installer.iso | awk '/Volume id/ { print $3 }')
TEMPDIR=$(mktemp -d)

cd ${TEMPDIR}
# Extract the ISO content using guestfish (to avoid sudo mount)
guestfish -a ${NGINX_DIRECTORY}/rhcos-${RHCOSVERSION}-x86_64-installer.iso \
  -m /dev/sda tar-out / - | tar xvf -

# Helper function to modify the config files
modify_cfg(){
  for file in "EFI/fedora/grub.cfg" "isolinux/isolinux.cfg"; do
    # Append the proper image and ignition urls
    sed -e '/coreos.inst=yes/s|$| coreos.inst.install_dev=sda coreos.inst.image_url='"${URL}"'\/rhcos-'"${RHCOSVERSION}"'-x86_64-metal-'"${BIOSMODE}"'.raw.gz coreos.inst.ignition_url='"${URL}"'\/'"${NODE}"'.ign ip='"${IP}"'::'"${GATEWAY}"':'"${NETMASK}"':'"${FQDN}"':'"${NET_INTERFACE}"':none nameserver='"${DNS}"'|' ${file} > $(pwd)/${NODE}_${file##*/}
    # Boot directly in the installation
    sed -i -e 's/default vesamenu.c32/default linux/g' -e 's/timeout 600/timeout 10/g' $(pwd)/${NODE}_${file##*/}
  done
}

# BOOTSTRAP
TYPE="bootstrap"
NODE="bootstrap"
IP=${BOOTSTRAP_IP}
FQDN="${CLUSTER_NAME}-bootstrap.${DOMAIN_NAME}"
modify_cfg

# MASTERS
TYPE="master"
# MASTER-0
NODE="master-0"
IP=${MASTER0_IP}
FQDN="${CLUSTER_NAME}-${NODE}.${DOMAIN_NAME}"
modify_cfg

TYPE="master"
# MASTER-1
NODE="master-1"
IP=${MASTER1_IP}
FQDN="${CLUSTER_NAME}-${NODE}.${DOMAIN_NAME}"
modify_cfg

TYPE="master"
# MASTER-2
NODE="master-2"
IP=${MASTER2_IP}
FQDN="${CLUSTER_NAME}-${NODE}.${DOMAIN_NAME}"
modify_cfg

# WORKERS
TYPE="worker"
# WORKER-0
NODE="worker-0"
IP=${WORKER0_IP}
FQDN="${CLUSTER_NAME}-${NODE}.${DOMAIN_NAME}"
modify_cfg

# Generate the images, one per node as the IP configuration is different...
# https://github.com/coreos/coreos-assembler/blob/master/src/cmd-buildextend-installer#L97-L103
for node in master-0 master-1 master-2 worker-0 bootstrap; do
  # Overwrite the grub.cfg and isolinux.cfg files for each node type
  for file in "EFI/fedora/grub.cfg" "isolinux/isolinux.cfg"; do
    cp $(pwd)/${node}_${file##*/} ${file}
  done
  # As regular user!
  genisoimage -verbose -rock -J -joliet-long -volset ${VOLID} \
    -eltorito-boot isolinux/isolinux.bin -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -efi-boot images/efiboot.img -no-emul-boot \
    -o ${NGINX_DIRECTORY}/${node}.iso .
done
