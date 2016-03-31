MW Server Base Cookbook
=======================

[![Build Status](https://travis-ci.org/Mikroways/mw_server_base.svg?branch=master)](https://travis-ci.org/Mikroways/mw_server_base)

This cookbook has some recipes to set up the minimal configuration we need to
have on every server.

Requirements
------------

- Chef 12 or higher.
- Network accessible package repositories.

Platform Support
----------------

The following platforms have been tested with Test Kitchen:

- Debian 7.
- Ubuntu 12.04.
- Ubuntu 14.04.
- CentOS 6.4.
- CentOS 7.1.

Cookbook Dependencies
---------------------

- apt
- chef-vault
- fail2ban
- locale
- ntp
- openssh
- postfix
- rsyslog
- simple_iptables
- sudo
- timezone_lwrp
- users
- yum-epel

Recipes Overview
----------------

This cookbook provides the following recipes:

- **basic_packages**: installs a list of some packages which are important for
  us to have in our servers.
- **default**: includes ```setup``` and ```postfix``` recipes.
- **postfix**: installs Postfix and configures it as a smarthost to use another
  server as a relay. Useful to receive server notifications.
- **security**: sets up OpenSSH with some customizations for better security and
  installs Fail2ban. This recipe is the only one that is not included when using
  default recipe.
- **setup**: includes ```basic_packages``` and ```users``` recipes, along with 
  *apt*, *locale*, *ntp* and *rsyslog*. It also configures the timezone.
- **users**: creates system users with root privileges using sudo.

Usage
-----

Place a dependency on the mw_server_base cookbook in your cookbook's
metadata.rb:

```ruby
depends 'mw_server_base', '~> 0.1'
```

After that, if you are setting up a regular server, include in your run list
```mw_server_base```. If the server is a mailserver, then you should put
```mw_server_base::setup``` in your run list instead, which excludes ```postfix```
recipe.
If you need to apply the security customizations, then explicitly include
```mw_server_base::security``` as it's not included by any other recipe.

About mirrors
-------------

Mirrors are not configured within this cookbook because the would normally be
implemented in the machine template used. That being not the case, you could
easily add debian or ubuntu cookbook to set the mirrors.

License & Authors
-----------------

- Author:: Leandro Di Tommaso (<leandro.ditommaso@mikroways.net>)

```text
Copyright:: 2016 Mikroways

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
