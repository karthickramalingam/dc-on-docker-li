#! /bin/bash

count=0
systemctl stop restd
systemctl stop ops-ntpd.service
for i in {1..48}; do
	ip link set eth${i} > /dev/null
	if [ $? = 0 ]; then
		ip netns exec swns ip link delete ${i}
		ip link set eth${i} down
		ip link set eth${i} name ${i}
		ip link set ${i} netns swns
		count=$(expr $count + 1)
	fi
done

# always returns success.
# Need to take care of the idempotence, though
exit 0
