#! /usr/bin/env bash

# Docker picks the default network based on the network name
# in the alphabetical order.  We put this prefix to all the
# network names so that those networks won't to be picked
# as the default networks.
#
# https://github.com/docker/docker/issues/21741
net_prefix="znet"

create_network_namespace()
{
	$(mkdir /var/run/netns/)
        for i in {5..8}; do
                pid="$(docker inspect -f '{{.State.Pid}}' fab0${i})"
                $(ln -s /proc/${pid}/ns/net /var/run/netns/${pid})
	done
	for i in {1..8}; do
                pid="$(docker inspect -f '{{.State.Pid}}' csw0${i})"
	        $(ln -s /proc/${pid}/ns/net /var/run/netns/${pid})
	done
        for i in {1..4}; do
                pid="$(docker inspect -f '{{.State.Pid}}' asw0${i})"
                $(ln -s /proc/${pid}/ns/net /var/run/netns/${pid})
        done
        for i in {1..2}; do
                pid="$(docker inspect -f '{{.State.Pid}}' host${i})"
                $(ln -s /proc/${pid}/ns/net /var/run/netns/${pid})
        done
}

# create fabric networks
create_fabric_networks()
{
        for i in {1..4}; do
                docker network inspect ${net_prefix}41${i} > /dev/null
                if [ $? != 0 ]; then
                        docker network create  \
                                --subnet=10.0.4${i}.0/24 \
                                --gateway=10.0.4${i}.254 ${net_prefix}41${i}
                fi
        done

}

# create leaf networks
create_leaf_networks()
{
        for i in {1..4}; do
                docker network inspect ${net_prefix}51${i} > /dev/null
                if [ $? != 0 ]; then
                        docker network create  \
                                --subnet=10.0.5${i}.0/24 \
                                --gateway=10.0.5${i}.254 ${net_prefix}51${i}
                fi
        done

}

# connect fabric switch
connect_fabric_switches()
{

        for j in {5..8}; do
                docker inspect fab0${j} > /dev/null
		declare cswPortID="eth$(expr ${j} - 4)"
                if [ $? = 0 ]; then
                        declare fabPID="$(docker inspect -f '{{.State.Pid}}' fab0${j})"
                        for i in {1..8}; do
				docker inspect csw0${i} > /dev/null
                                if [ $? = 0 ]; then
					declare fabPortID="eth$(expr ${i} + 1)"
					declare cswPID="$(docker inspect -f '{{.State.Pid}}' csw0${i})"
				        ip link add ${fabPortID}A type veth peer name ${cswPortID}B
					ip link set ${fabPortID}A netns ${fabPID}
					ip netns exec ${fabPID} ip link set ${fabPortID}A name  ${fabPortID}
					ip netns exec ${fabPID} ip link set ${fabPortID} up
                                        ip link set ${cswPortID}B netns ${cswPID}
                                        ip netns exec ${cswPID} ip link set ${cswPortID}B name  ${cswPortID}
                                        ip netns exec ${cswPID} ip link set ${cswPortID} up	
				fi
                        done
                fi
        done
}

# connect spine switch
connect_spine_switches()
{

        for j in {1..4}; do
                docker inspect csw0${j} > /dev/null
                declare aswPortID="eth$(expr ${j} + 1)"
                if [ $? = 0 ]; then
                        declare cswPID="$(docker inspect -f '{{.State.Pid}}' csw0${j})"
                        for i in {1..2}; do
                                docker inspect asw0${i} > /dev/null
                                if [ $? = 0 ]; then
                                        declare cswPortID="eth$(expr ${i} + 4)"
                                        declare aswPID="$(docker inspect -f '{{.State.Pid}}' asw0${i})"
                                        ip link add ${cswPortID}A type veth peer name ${aswPortID}B
                                        ip link set ${cswPortID}A netns ${cswPID}
                                        ip netns exec ${cswPID} ip link set ${cswPortID}A name  ${cswPortID}
                                        ip netns exec ${cswPID} ip link set ${cswPortID} up
                                        ip link set ${aswPortID}B netns ${aswPID}
                                        ip netns exec ${aswPID} ip link set ${aswPortID}B name  ${aswPortID}
                                        ip netns exec ${aswPID} ip link set ${aswPortID} up        
                                fi
                        done
                fi
        done
        for j in {5..8}; do
                docker inspect csw0${j} > /dev/null
                declare aswPortID="eth$(expr ${j} - 3)"
                if [ $? = 0 ]; then
                        declare cswPID="$(docker inspect -f '{{.State.Pid}}' csw0${j})"
                        for i in {3..4}; do
                                docker inspect asw0${i} > /dev/null
                                if [ $? = 0 ]; then
                                        declare cswPortID="eth$(expr ${i} + 2)"
                                        declare aswPID="$(docker inspect -f '{{.State.Pid}}' asw0${i})"
                                        ip link add ${cswPortID}A type veth peer name ${aswPortID}B
                                        ip link set ${cswPortID}A netns ${cswPID}
                                        ip netns exec ${cswPID} ip link set ${cswPortID}A name  ${cswPortID}
                                        ip netns exec ${cswPID} ip link set ${cswPortID} up
                                        ip link set ${aswPortID}B netns ${aswPID}
                                        ip netns exec ${aswPID} ip link set ${aswPortID}B name  ${aswPortID}
                                        ip netns exec ${aswPID} ip link set ${aswPortID} up        
                                fi
                        done
                fi
        done

}


# connect servers to fabric networks
connect_servers_to_fabric_networks()
{
	docker inspect host1 > /dev/null
	if [ $? = 0 ]; then
                docker network connect ${net_prefix}411 fab05
                docker network connect ${net_prefix}412 fab06
                docker network connect ${net_prefix}413 fab07
                docker network connect ${net_prefix}414 fab08
		docker network connect ${net_prefix}411 host1
                docker network connect ${net_prefix}412 host1
                docker network connect ${net_prefix}413 host1
                docker network connect ${net_prefix}414 host1
        fi
}

# connect servers to leaf networks
connect_servers_to_leaf_networks()
{
	docker inspect host2 > /dev/null
        if [ $? = 0 ]; then
                docker network connect ${net_prefix}511 asw01
                docker network connect ${net_prefix}512 asw02
                docker network connect ${net_prefix}513 asw03
                docker network connect ${net_prefix}514 asw04
                docker network connect ${net_prefix}511 host2
                docker network connect ${net_prefix}512 host2
                docker network connect ${net_prefix}513 host2
                docker network connect ${net_prefix}514 host2
        fi
}

# main
create_network_namespace
create_fabric_networks
create_leaf_networks
connect_servers_to_fabric_networks
connect_servers_to_leaf_networks
connect_fabric_switches
connect_spine_switches
