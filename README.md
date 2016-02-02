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
The following platforms have been tested:

- Ubuntu 14.04.
- CentOS 6.4.
- CentOS 7.1.

Cookbook Dependencies
---------------------
- chef-vault
- ntp
- postfix
- rsyslog
- sudo
- ubuntu
- users

Recipes Overview
-------

This cookbook provides the following recipes:

- *basic_packages*: installs a list of some packages which are important for us to
  have in our servers.
- *postfix*: installs Postfix and configures it as a smarthost to use another
  server as a relay. Useful to receive server notifications.
- *users*: creates system users with root privileges using sudo.

There is another recipe in this cookbook:

- *setup*: includes all the recipes above along with apt, locale, ntp and rsyslog.
  It also configures the timezone.

Usage
-----
Place a dependency on the mw_server_base cookbook in your cookbook's
metadata.rb:

```ruby
depends 'mw_server_base', '~> 0.1'
```

Then, include in your node's run list each recipe you'd like to use or apply
mw_server_base::setup.

License & Authors
-----------------

* Author:: Leandro Di Tommaso (<leandro.ditommaso@mikroways.net>)

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
