# Using Vagrant

You can use [vagrant](http://vagrantup.com) to create a sandboxed Ansible
control machine, if you want to test it out, though this is actually not
a requirement.  But if you do, here is some tips to set the vagrant
environment up.

## Proxy setup

If you're behind a proxy, make sure you have `http_proxy` and `https_proxy`
available as environment variables if you are under a web proxy;

* On Windows

```
set http_proxy=%WEB_PROXY_URL%
set https_proxy=%WEB_PROXY_URL%
```

* On Linux or OSX

```
export http_proxy=$WEB_PROXY_URL
export https_proxy=$WEB_PROXY_URL
```

## Virtualbox

Download and install Virtualbox 5.0.16 from [virtualbox.org](https://www.virtualbox.org/wiki/Downloads);

## Vagrant

Download and install Vagrant 1.8.1 from [vagrantup.com](https://releases.hashicorp.com/vagrant/1.8.1);

Optionary, you can install required vagrant plugins:

```
$ vagrant plugin install vagrant-proxyconf vagrant-vbguest
```

## Vagrant up

All you have to do is just `vagrant up` inside `dc-on-docker`:

```
$ vagrant up
```

and then just `vagrant ssh` to ssh into the vagrant guest:

```
$ vagrant ssh
```
