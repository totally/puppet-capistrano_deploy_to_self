class code_environment::deploy_to_self_on_boot {

    file {  '/etc/init/deploy_to_self.conf':
        ensure  => absent,
    }

}
