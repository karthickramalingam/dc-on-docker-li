# DC on Docker with [OpenSwitch](http://www.openswitch.net)

[![Build Status](https://travis-ci.org/keinohguchi/dc-on-docker.svg)](https://travis-ci.org/keinohguchi/dc-on-docker)
[![Buildtime trend](https://buildtimetrend.herokuapp.com/badge/keinohguchi/dc-on-docker/latest)](https://buildtimetrend.herokuapp.com/dashboard/keinohguchi/dc-on-docker/)
[![Stories in Ready](https://badge.waffle.io/keinohguchi/dc-on-docker.png?label=ready&title=ready)](https://waffle.io/keinohguchi/dc-on-docker)

Creating your own data-center (DC) on your laptop with Ansible and
Docker-Compose in a snap!

[![asciicast](https://asciinema.org/a/49164.png)](https://asciinema.org/a/49164)

## Requirements

### Control machine

Ansible 2.1 or above on your control machine, as OpenSwitch ansible roles,
e.g.  [ops switch role](http://github.com/keinohguchi/ops-switch-role),
uses Ansible 2.1 modules.

### Docker host

Docker 1.9 or above, as `dc-on-docker` uses new docker networking stack.

### Vagrant sandbox

You can create a completely sandboxed `dc-on-docker` environment by
[Vagrant](http://vagrantup.com), though that's not the requirement to.
Please refer to [README.Vagrant.md](README.Vagrant.md) for more detail
if you want to go that path.

## Topology


## Setup

### Topology setup

Single playbook to setup the above topology.  It's basically
It's primarily the `docker-compose` with the new `docker networking`
stuff, with additional tweaks for OpenSwitch interfaces:

```
  $ ansible-playbook utils/setup.yaml
```

#### Single docker topology

You can also create a smaller topology, say single docker topology,
primaliry for the testing purpose, as demonstrated on the
[asciinema](https://asciinema.org/a/44984).  Here is the example
how to create a single docker instance topology:

```
  $ ansible-playbook --limit fabrics:docker --extra-vars "docker_compose_file=docker-compose1.yaml docker_network_script=docker-network1.sh" utils/setup.yaml
```

After this, you can run the test file, say `tests/test_switch.yml`, as below:

```
  $ ansible-playbook tests/test_switch.yml
```

### Switch health

You can check the switch reachability by running the `utils/ping.yaml`
playbook, as below:

```
  $ ansible-playbook utils/ping.yaml
```

## Play

Now, you're ready for play, and of course, it's called `site.yaml`:

```
  $ ansible-playbook site.yaml
```

### Specific play

You can only run the specific host by using the `--limit` option
as below:

```
  $ ansible-playbook --limit fabrics site.yaml
```

for example, to run only against the [fabric switches](hosts).

### Test

You can run the test locally as simple as one liner.  We embrace the
TDD philosophy here, too.

```
  $ ansible-playbook tests/test_bridge.yml
```

Here is the [asciicast](https://asciinema.org/a/44717), as test in action.

## Tear down

Teardown the topology, after the party.

```
  $ ansible-playbook utils/teardown.yaml
```

## Asciicast

You can watch the asciicast locally on you laptop, once you install [asciinema](https://asciinema.org/docs/installation), with:

```
  $ asciinema play asciicast-june-2016.json
```

Enjoy and happy hacking!
