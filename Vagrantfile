#/**
# * TangoMan Vagrant
# *
# * @version 0.1.0
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @licence MIT
# * @link    https://github.com/TangoMan75/vagrant-boilerplate
# */

require 'yaml'

#/**
# * Load config file
# *
# * config is loaded from './config/vagrant.yaml'
# */
begin
    vagrant_config = YAML::load(File.read(File.dirname(__FILE__) + '/config/vagrant.yaml'))
rescue
    raise "Config file not found, run `make config` to create one\n"
end

Vagrant.configure('2') do |config|
    vagrant_config.each do |(box_name, parameters)|
        config.vm.define box_name do |default|

            #/**
            # * Boxes
            # *
            # * @link https://app.vagrantup.com/boxes/search
            # * @link https://www.vagrantup.com/docs/multi-machine
            # */
            if parameters['box_type']
                default.vm.box = parameters['box_type']
            else
                raise "parameter `box_type` cannot be empty\n"
            end

            #/**
            # * Virtual box configuration
            # */
            config.vm.provider 'virtualbox' do |v|
                if box_name and box_name != 'default'
                    v.name = box_name
                end

                if parameters['show_gui']
                    v.gui = parameters['show_gui']
                end

                if parameters['video_memory_mo'] and parameters['show_gui']
                    v.customize = ['modifyvm', :id, '--vram', parameters['video_memory_mo']]
                end

                if parameters['memory_limit_mo'] and parameters['memory_limit_mo'] != 'default'
                    v.memory = parameters['memory_limit_mo']
                end

                if parameters['cpu_number'] and parameters['cpu_number'] != 'default'
                    v.cpus = parameters['cpu_number']
                end
            end

            #/**
            # * Network
            # *
            # * @link https://www.vagrantup.com/docs/networking
            # * @link https://www.vagrantup.com/docs/networking/private_network.html
            # * @note type: 'dhcp' setting doesn't seem to work too well
            # */
            if parameters['host_only_ip']
                default.vm.network 'private_network', ip: parameters['host_only_ip']
            else
                raise "parameter `host_only_ip` cannot be empty\n"
            end

            #/**
            # * VirtualBox internal network
            # *
            # * @link https://www.vagrantup.com/docs/virtualbox/networking.html
            # * @note seems to cause vm to be unable to boot for some reason
            # */
            if parameters['intnet_ip']
                default.vm.network 'private_network', ip: parameters['intnet_ip'], virtualbox__intnet: true
            end

            #/**
            # * Bridge
            # *
            # * @link https://www.vagrantup.com/docs/networking/public_network.html
            # */
            if parameters['public_ip']
                default.vm.network 'public_network', ip: parameters['public_ip'], bridge: parameters['bridge']
            end

            #/**
            # * SSH
            # *
            # * @note agent forwarding: use the key pair from host machine
            # * @link https://www.vagrantup.com/docs/vagrantfile/ssh_settings.html
            # */
            default.ssh.forward_agent = true
            default.ssh.insert_key = false

            #/**
            # * Shares
            # *
            # * @link https://www.vagrantup.com/docs/synced-folders/basic_usage.html
            # * @note For enhanced performances you may want to use NFS
            # * @note NFS requires a host-only network to be created
            # * @note fmode = file mode; dmode = directory mode
            # * @note `create: true` create folder on local machine when not found
            # */
            if parameters['host_shared_folder']
                if parameters['nfs_share']
                    default.vm.synced_folder parameters['host_shared_folder'], parameters['guest_shared_folder'], type: 'nfs'
                else
                    default.vm.synced_folder parameters['host_shared_folder'], parameters['guest_shared_folder'], mount_options: ['dmode=777','fmode=666']
                end
            end

            #/**
            # * Provisioning
            # */
            if ! parameters['provisions'].kind_of?(Array)
                parameters['provisions'] = [parameters['provisions']]
            end

            parameters['provisions'].each do |provision|

                #/**
                # * Shell Provisioner
                # *
                # * @note `privileged: false` will run command as "vagrant" user (default is "root")
                # * @link https://www.vagrantup.com/docs/provisioning
                # * @link https://www.vagrantup.com/docs/provisioning/shell.html
                # */
                if provision == 'shell'
                    # apply with root identity
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/network/config_known_ssh_hosts.sh', privileged: false, keep_color: true
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/system/config_bash_aliases.sh',     privileged: false, keep_color: true

                    # apply with vagrant identity
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/update.sh',                 keep_color: true
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/ide/install_vim.sh',        keep_color: true
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/dev/install_git.sh',        keep_color: true
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/dev/install_make.sh',       keep_color: true
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/network/install_curl.sh',   keep_color: true
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/system/config_keyboard.sh', keep_color: true
                    default.vm.provision 'shell', inline: '/vagrant/bin/provisions/clean.sh',                  keep_color: true
                end

                #/**
                # * Ansible Provisioner
                # *
                # * @link https://www.vagrantup.com/docs/provisioning/ansible_intro.html
                # * @link https://www.vagrantup.com/docs/provisioning/ansible.html
                # */
                if provision == 'ansible'
                    config.vm.provision 'ansible' do |ansible|
                        ansible.playbook = 'bin/ansible/playbook.yaml'
                    end
                end

                #/**
                # * Ansible Local Provisioner
                # *
                # * @link https://www.vagrantup.com/docs/provisioning/ansible_local.html
                # */
                if provision == 'ansible_local'
                    config.vm.provision 'ansible_local' do |ansible_local|
                        ansible_local.playbook = 'bin/ansible/playbook.yaml'
                        ansible_local.install_mode = 'pip'
                        ansible_local.version = '2.2.1.0'
                    end
                end

                #/**
                # * Docker Provisioner
                # *
                # * @link https://www.vagrantup.com/docs/provisioning/docker.html
                # */
                if provision == 'docker'
                    config.vm.provision 'docker' do |docker|
                        docker.build_image 'bin/docker'
                    end
                end

                #/**
                # * Docker-compose Provisioner
                # */
                if provision == 'docker_compose'
                    config.vm.provision 'docker_compose' do |docker_compose|
                        docker_compose.rebuild = true
                        docker_compose.yml = '/vagrant/bin/docker-compose/docker-compose.yaml'
                    end
                end
            end
        end
    end
end
