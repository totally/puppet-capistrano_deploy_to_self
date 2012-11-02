define code_environment ($app = $name) {

    # Load ssh-agent and run cap deploy:setup on localhost
    exec { "cap_setup_$app":
            command     => "/bin/sh -xc 'eval `ssh-agent`; ssh-add; cap HOSTS=localhost deploy:setup'; ssh-add -D;",
            path        => ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
            creates     => "/var/www/apps/${app}",
            logoutput   => true,
            cwd         => "/root/capistrano/${app}",
            onlyif      => "ls /root/capistrano/${app}",
            require     => [Class['capistrano'],Class['apache2']]
    }

    # puppet execute capistrano deploy.  we could use upstart script, but then 
    # we'd miss the exit status
    exec { "cap_deploy_$app":
            command     => "/bin/sh -xc 'eval `ssh-agent`; ssh-add; cap HOSTS=localhost deploy'; ssh-add -D",
            path        => ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
            creates     => "/var/www/apps/${app}/current",
            logoutput   => true,
            cwd         => "/root/capistrano/${app}",
            onlyif      => "ls /root/capistrano/${app}",
            require     => [Exec["cap_setup_${app}"],Class['apache2'],Class['capistrano']]
    }

    # Upstart file
    file {  "/etc/init/deploy_${app}_to_self.conf":
        content     => template('code_environment/deploy_to_self.upstart.erb'),
        owner       => 'root',
        group       => 'root',
        mode        => '644',
    }
}
