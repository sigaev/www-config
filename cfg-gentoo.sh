# run as root

[[ $1 ]] || exit 1

cd /
wget s3.amazonaws.com/sigaev/linux/$1 || exit 1
wget -qO- s3.amazonaws.com/sigaev/linux/unsquashfs.txz | tar xJC media || exit 1
media/lib/ld-2* --library-path media/lib:media/usr/lib \
	media/usr/bin/unsquashfs -f -d mnt $1 || exit 1

cat >media/init <<EOF
#!/bin/bash

old() {
	echo Starting \\[init~ "\$@"\\] >&2
	exec sbin/init~ "\$@"
}

if [[ -e proc/uptime ]]; then
	ut=\`tr . \\  < proc/uptime | cut -d\\  -f1\`
	echo Uptime: \$ut >&2
	if [ 99 -lt \$ut ]; then
		old "\$@"
	fi
else
	old "\$@"
fi

if [[ ! -h mnt/lib/modules ]]; then
	echo FATAL: previous attempt to move Gentoo files failed >&2
	exit 1
fi

mount -nworemount .
rm -f mnt/lib/modules
mv lib/modules mnt/lib/
mv etc/ssh/ssh_host_* mnt/etc/ssh/
mv home/ec2-user/.awssecret dev/shm/
chown 1000 dev/shm/.awssecret

rm -fr mnt/{dev,proc,sys,mnt} \`ls | egrep -v 'lost.found|dev|proc|sys|mnt'\`
mnt/lib/ld-2* --library-path mnt/lib mnt/bin/mv mnt/* .

echo Starting \\[init "\$@"\\] >&2
exec sbin/init "\$@"
EOF

chmod 755 media/init
mv -bf media/init sbin/
setsid nohup sh -c 'sleep 3 && reboot &' </dev/null >/dev/null 2>&1
