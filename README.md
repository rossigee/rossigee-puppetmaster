# Puppet module for a puppetmaster based on Apache2 with git-based updates

## Example hiera config

```
profile:
    puppetmaster:
        netrc:
            machine: (git server hostname)
            login: (git user login)
            password: (git user password)
        gitrepo: https://www.yourserver.com/git/puppet
        webhook:
            bindip: 0.0.0.0
            bindport: 8141
            token: asdfghjkl;
        modules:
            - puppetlabs/mysql
            - puppetlabs/ntp
            - saz/sudo
            - saz/timezone

```


