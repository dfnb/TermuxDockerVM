INITRAMFS=http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/armhf/netboot-3.10.3/initramfs-vanilla
VMLINUZ=http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/armhf/netboot-3.10.3/vmlinuz-vanilla

if [ ! -f initramfs-vanilla ]; then
	wget "$INITRAMFS"
fi

if [ ! -f vmlinuz-vanilla ]; then
	wget "$VMLINUZ"
fi

if [ ! -f run.sh ]; then
	echo '
	qemu-system-arm \
		-M virt \
		-m 512M \
		-cpu cortex-a15 \
		-kernel vmlinuz-vanilla \
		-netdev user,id=user0 -device virtio-net-device,netdev=user0 \
		-initrd initramfs-vanilla \
		-append "console=ttyAMA0 ip=dhcp alpine_repo=http://dl-cdn.alpinelinux.org/alpine/edge/main/" \
		-nographic
	' >> run.sh
fi
