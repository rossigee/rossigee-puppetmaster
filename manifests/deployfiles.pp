class puppetmaster::deployfiles {
    $_config = hiera('profile')
    $config = $_config['puppetmaster']
    $netrc = $config['netrc']
    
    #require apache2
    
    # This script runs as 'puppet' user and listens on port 8641
    file { '/usr/local/bin/puppetmaster-webhook':
        mode   => 755,
        owner  => root,
        group  => root,
        source => "puppet:///modules/puppetmaster/puppetmaster-webhook",
    }
    
    # This script is run by webhook, sudo'ed as 'root', to refresh/deploy
    file { '/usr/local/bin/puppetmaster-deployfiles':
        mode   => 755,
        owner  => root,
        group  => root,
        source => "puppet:///modules/puppetmaster/puppetmaster-deployfiles",
    }
    
    # Puppet needs to sudo to run the deploy script, and only the deploy script
    sudo::conf { 'puppet':
        ensure  => present,
        content => 'puppet ALL=NOPASSWD: /usr/local/bin/puppetmaster-deployfiles',
    }
    
    # This script runs as 'puppet' user and listens on port 8641
    file { '/etc/puppetmaster.conf':
        mode   => 644,
        owner  => root,
        group  => root,
        content => template("puppetmaster/puppetmaster.conf.erb"),
    }
    
    # Puppet needs git details for the clone
    file { '/root/.netrc':
        mode   => 400,
        owner  => root,
        group  => root,
        content => template("puppetmaster/netrc.erb"),
    }
    
    # The webhook needs to be running at all times
    service { 'puppetmaster-webhook':
        ensure => running,
        provider => 'upstart',
        require => Exec['refresh-puppetmaster-webhook-init'],
    }
    file { "/etc/init/puppetmaster-webhook.conf":
        mode   => 644,
        owner  => root,
        group  => root,
        content => template("puppetmaster/puppetmaster-webhook.upstart.erb"),
        notify => Service['puppetmaster-webhook'],
    }
    exec { 'refresh-puppetmaster-webhook-init':
        path => "/sbin:/usr/sbin:/bin:/usr/bin",
        command => "initctl reload-configuration",
        require => File['/etc/init/puppetmaster-webhook.conf'],
        unless => "initctl list | grep puppetmaster-webhook",
    }

}

