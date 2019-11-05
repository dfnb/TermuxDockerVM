ARCH=$(uname -m)
ALPINELINUXARCH=""
if [ "$ARCH" = "armv7l" ]; then
	echo "armv7"
	ALPINELINUXARCH="armv7"
elif [ "$ARCH" = "aarch64" ]; then
	echo "aarch64"
	ALPINELINUXARCH="aarch64"
else
	echo "armhf"
	ALPINELINUXARCH="armhf"
fi

INITRAMFS=http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/$ALPINELINUXARCH/netboot-3.10.3/initramfs-vanilla
VMLINUZ=http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/$ALPINELINUXARCH/netboot-3.10.3/vmlinuz-vanilla

if [ ! -f initramfs-vanilla ]; then
	wget "$INITRAMFS"
fi

if [ ! -f vmlinuz-vanilla ]; then
	wget "$VMLINUZ"
fi

if [ ! -f run.sh ]; then
if [ "$ARCH" = "aarch64" ]; then
        echo '                                                                
        qemu-system-aarch64 \                                                     
                -M virt \                                                                                
                -m 512M \                                                                                
                -cpu cortex-a53 \                                                                        
                -kernel vmlinuz-vanilla \                                                                
                -netdev user,id=user0 -device virtio-net-device,netdev=user0 \                           
                -initrd initramfs-vanilla \                                                              
                -append "console=ttyAMA0 ip=dhcp alpine_repo=http://dl-cdn.alpinelinux.org/alpine/edge/ma
                -nographic                                                                               
        ' >> run.sh 
else
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
fi
