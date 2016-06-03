# rossigee-puppetmaster

#### Table of Contents

1. [Description](#description)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Provides an Apache2-driven puppetmaster service, and a webhook service for triggering an update.

An update involves refreshing the puppet configuration from the configured (secure/authenticated) git repository, and re-running librarian-puppet to pull in or update third-party modules.

You can do this using Puppet in your own environment, or there is also a Dockerfile provided which wraps it all up in a container for easier hosting.

## Usage

Example 'hiera' configuration...

```
profile:
    puppetmaster:
        hostname: puppet.yourdomain.com
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

## Reference

Use the source and the above example for now. Sorry, life's too short.

## Limitations

The only limits are those you make for yourself.

## Development

PRs on github preferred.

