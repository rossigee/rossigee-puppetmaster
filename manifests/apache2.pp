class puppetmaster::apache2 {
    $_config = hiera_hash('profile')
    $config = $_config['puppetmaster']
    $puppetmaster_hostname = $config['hostname']

    $pkgs = [
        'apache2',
        'puppetmaster-passenger',
        'libapache2-mod-passenger',
    ]
    package { $pkgs:
        ensure => installed,
    }
    
    # Apache site setup
    service { 'apache2':
        ensure => running,
    }
    file { "/etc/apache2/sites-available/puppetmaster.conf":
        owner => root,
        group => root,
        mode => 644,
        content => template("puppetmaster/apache2/puppetmaster.conf.erb"),
        require => Package['apache2'], 
        notify => Service['apache2'],
    }
    file { '/etc/apache2/sites-enabled/puppetmaster.conf':
        ensure => 'link',
        target => '/etc/apache2/sites-available/puppetmaster.conf',
        notify => Service["apache2"],
        require => File['/etc/apache2/sites-available/puppetmaster.conf']
    }
}
