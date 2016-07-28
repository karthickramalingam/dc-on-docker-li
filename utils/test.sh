#!/bin/bash
create_network()
{

        for j in {4..8}; do
                docker inspect leaf${j} > /dev/null
		if [ $? = 0 ]; then
			echo "PASS"
			declare var="leaf${j}"
			echo $var
			declare $var="$(docker inspect -f '{{.State.Pid}}' leaf${j})"
			echo "Test --->".${!var}."<----"
		fi
	done
}
show_network()
{
	for j in {4..8}; do
		echo $leaf${j}
	done
}
create_network
show_network
