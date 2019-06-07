Vagrant.configure(2) do |config|
    config.vm.box = 'bento/ubuntu-16.04-i386'
    config.vm.hostname = 'casebox.org'
    config.vm.network 'private_network', ip: '192.168.33.3'

    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder './provision', '/var/provision', :nfs => { :mount_options => ['fmode=666'] }

    config.ssh.forward_agent = true

    config.vm.provider 'virtualbox' do |vb|
        vb.name = 'casebox'
        vb.memory = '5048'
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    end

    config.vm.provision 'shell', inline: <<-SHELL, privileged: true
        echo "================================================================================";
        echo "Installing common software (ansible, git, nano, wget, curl etc.)...";
        echo "================================================================================";
        chmod +x /var/provision/bash/preinstall.sh
        source /var/provision/bash/preinstall.sh
    SHELL

    config.vm.provision 'shell', inline: <<-SHELL, privileged: false
        echo "================================================================================";
        echo "Installing (core software) Nginx, PHP, MySQL, LibreOffice etc...";
        echo "================================================================================";
        ansible-playbook -i "localhost," -c local /var/provision/ansible/default.yml
    SHELL

    config.vm.provision 'shell', inline: <<-SHELL, privileged: false
        echo "================================================================================";
        echo "Installing Casebox Admin UI...";
        echo "================================================================================";
        ansible-playbook -i "localhost," -c local /var/provision/ansible/dashboard.yml
    SHELL

    config.vm.provision 'shell', run: 'always', inline: <<-SHELL, privileged: false
        echo "================================================================================";
        echo "Starting Casebox Admin UI services...";
        echo "================================================================================";
        ansible-playbook -i "localhost," -c local /var/provision/ansible/services.yml
    SHELL

    config.vm.provision 'shell', run: 'always', inline: <<-SHELL, privileged: false

        if [ -f "/home/vagrant/.reload" ]; then
                echo "================================================================================";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo "In order to apply software and security configurations,";
                echo "please run command: vagrant reload";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo "================================================================================";
                rm /home/vagrant/.reload
            else
                echo "================================================================================";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo "Launch Casebox Admin UI: http://192.168.33.3:8000";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo " ";
                echo "================================================================================";
        fi

    SHELL
end
