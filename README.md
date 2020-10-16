TangoMan Vagrant Boilerplate
============================

**TangoMan Vagrant Boilerplate** is a fast and handy way to deploy virtual machines for development.

Step 1: Install Dependencies
----------------------------

If your using Ubuntu or OSX, and you don't have `Vagrant` and `VirtualBox` installed on your local machine, run following command:

```bash
$ make install
```
This will install the necessary software on your local machine (host):

- mokutils
- nfs-common
- nfs-kernel-server

### Ansible

- [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)

### Vagrant

- [Vagrant 2.1.2](https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb)
- [Vagrant 2.2.6](https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb)
- [Vagrant 2.2.10](https://releases.hashicorp.com/vagrant/2.2.10/vagrant_2.2.10_x86_64.deb)

### VirtualBox

- [VirtualBox 5.2 (bionic)](https://download.virtualbox.org/virtualbox/5.2.44/virtualbox-5.2_5.2.44-139111~Ubuntu~bionic_amd64.deb)
- [VirtualBox 6.0 (bionic)](https://download.virtualbox.org/virtualbox/6.0.24/virtualbox-6.0_6.0.24-139119~Ubuntu~bionic_amd64.deb)
- [VirtualBox 6.0 (eoan/focal)](https://download.virtualbox.org/virtualbox/6.1.14/virtualbox-6.1_6.1.14-140239~Ubuntu~eoan_amd64.deb)
- [VirtualBox 6.1 bionic](https://download.virtualbox.org/virtualbox/6.1.14/virtualbox-6.1_6.1.14-140239~Ubuntu~bionic_amd64.deb)
- [VirtualBox 6.1 (eoan/focal)](https://download.virtualbox.org/virtualbox/6.1.14/virtualbox-6.1_6.1.14-140239~Ubuntu~eoan_amd64.deb)

**NOTE 1**: You will be asked for your password during `mokutils` installation on Ubuntu or OSX.

**NOTE 2**: You would have to install required software manually on *Windows* machine. Make sure you use above versions as Vagrant 2 is incompatible with VirtualBox 6.

**NOTE 3**: NFS share would probably not work on windows machine.

Step 2: Build Virtual Machine
-----------------------------

Following command will walk you through all the steps necessary to create new guest machine.

```bash
$ make create
```

You should then be able to start and connect to new virtual machine with following command:

```bash
$ make connect
```

**NOTE**: First launch of `vagrant up` may take some time.

If you get disconnected or close terminal accidentally you can reconnect to the guest virtual machine with following command:

```bash
$ vagrant ssh
# or
$ make connect
```

Optional: Change Configuration
------------------------------

Find vagrant images here: images [public Vagrant box catalog](https://app.vagrantup.com/boxes/search)

You can configure guest machines via the `config/vagrant.yaml` file:

```bash
$ vim config/vagrant.yaml
# and
$ make restart
```

or with the command

```bash
$ make config
$ make stop
$ make rebuild
```

### box_type

Some examples of valid `box_type` option are:

#### Server images
- hashicorp/bionic64 (18.04 LTS - recommended)
- ubuntu/bionic64  (18.04 LTS)
- ubuntu/xenial64  (16.04 LTS)
- ubuntu/trusty64  (14.04 LTS)
- ubuntu/precise64 (12.04 LTS)
- debian/jessie64

#### Pentesting
- kalilinux/rolling
- Sliim/metasploitable2
- rapid7/metasploitable3-ub1404
- rapid7/metasploitable3-win2k8

#### Other OS
- npalm/mint17-amd64-cinnamon
- Microsoft/EdgeOnWindows10
- AndrewDryga/vagrant-box-osx
- https://vagrant-osx.nyc3.digitaloceanspaces.com/osx-sierra-0.3.1.box

```yaml
bionic:
    # virtual box name
    box_name: bionic

    # virtual box type, see images availlable here: https://app.vagrantup.com/boxes/search
    box_type: ubuntu/bionic64

    # show virtual box gui
    show_gui: false

    # vram amount (in mo)
    video_memory_mo: 128

    # vm disk size, virtualbox default size is 10GB
    disk_size: default

    # vm allocated memory (in mo)
    memory_limit_mo: 4090

    # vm cpu number
    cpu_number: 2

    # vm private ip address (choose carefully as it may cause conflicts)
    host_only_ip: 10.10.10.10

    # virtual box internal network ip address (allowing to share between virtual machines)
    intnet_ip: 192.168.1.1

    # public ip address (public network ip)
    public_ip: 192.168.0.50

    # public network host interface, valid options are: enp0s31f6, wlp2s0
    bridge: ['enp0s31f6', 'wlp2s0']

    # local folder to be shared with vm
    host_shared_folder: /home/`whoami`/shared/`box_name`/

    # synced guest folder
    guest_shared_folder: /shared/

    # enable nfs file sharing
    nfs_share: false

    # provisioning
    provisions: ['shell', 'ansible_local', 'ansible', 'docker', 'docker-compose']
```

Some Windows images are available from Microsoft: [https://developer.microsoft.com/en-us/microsoft-edge/tools/vms](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms)

Some MacOSX images are available: [https://vagrant-osx.nyc3.digitaloceanspaces.com/osx-sierra-0.3.1.box](https://vagrant-osx.nyc3.digitaloceanspaces.com/osx-sierra-0.3.1.box)

Local /etc/hosts
----------------

You need to modify your `/etc/hosts` to redirect it towards your VM via its private IP address (by default `10.10.10.10`):

```bash
$ sudo cat /etc/hosts 10.10.10.10 tangoman.local
```

NOTES
-----

- `./bin/host` :  Contains scripts to be executed on host machine (local)
- `./bin/guest` : Contains scripts to be executed on guest machine
- `./bin/tools` : Contains some script tools, you probably won't need this

Usage
-----

Run `make` to print help

```bash
$ make [command] 
```

Valid commands are: help start stop shell restart validate status clean up init config hosts reset update destroy install install-bin uninstall check download-win7 add-win7 download-osx add-osx

Commands
--------

#### help
```
$ make help
```
Print this help

### Vagrant
#### start
```
$ make start
```
Start vagrant

#### stop
```
$ make stop
```
Stop vagrant

#### shell
```
$ make shell
```
Open bash shell into guest

#### restart
```
$ make restart
```
Restart vagrant

#### validate
```
$ make validate
```
Validate Vagrantfile syntax

#### status
```
$ make status
```
List running vagrant boxes

#### clean
```
$ make clean
```
Remove stale vagrant boxes

### Vagrant Guest
#### up
```
$ make up
```
Start and ssh into vagrant guest

#### init
```
$ make init
```
Create vagrant guest

#### config
```
$ make config
```
Init configuration

#### hosts
```
$ make hosts
```
Set hosts

#### reset
```
$ make reset
```
Rebuild vagrant guest forcing provisioners

#### update
```
$ make update
```
Update guest provisioners

#### destroy
```
$ make destroy
```
Destroy guest

### Vagrant Host
#### install
```
$ make install
```
Install vagrant host (Ansible, VirtualBox)

#### install-bin
```
$ make install-bin
```
Install vagrant host (Ansible, VirtualBox) from sh files

#### uninstall
```
$ make uninstall
```
Uninstall all

#### check
```
$ make check
```
Check installation

### Vagrant Images
#### download-win7
```
$ make download-win7
```
Download Windows7 image from microsoft

#### add-win7
```
$ make add-win7
```
Extract and add downloaded Windows7 image from microsoft

#### download-osx
```
$ make download-osx
```
Download Mac OSX image from Vagrant

#### add-osx
```
$ make add-osx
```
Extract and add downloaded Windows7 image from microsoft

License
-------

Copyrights (c) 2020 &quot;Matthias Morin&quot; &lt;mat@tangoman.io&gt;

[![License](https://img.shields.io/badge/Licence-MIT-green.svg)](LICENCE)
Distributed under the MIT license.

If you like **TangoMan Vagrant Boilerplate** please star, follow or tweet:

[![GitHub stars](https://img.shields.io/github/stars/TangoMan75/vagrant-boilerplate?style=social)](https://github.com/TangoMan75/vagrant-boilerplate/stargazers)
[![GitHub followers](https://img.shields.io/github/followers/TangoMan75?style=social)](https://github.com/TangoMan75)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Fvagrant-boilerplate)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Fvagrant-boilerplate)

... And check my other cool projects.

[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=morinmatthias)](https://www.linkedin.com/in/morinmatthias)
