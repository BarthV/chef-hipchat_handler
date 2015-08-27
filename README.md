[![CK Version](http://img.shields.io/cookbook/v/hipchat_handler.svg)](https://supermarket.getchef.com/cookbooks/hipchat_handler) [![Build Status](https://img.shields.io/travis/BarthV/chef-hipchat_handler.svg)](https://travis-ci.org/BarthV/chef-hipchat_handler)

Description
===========

A `chef_handler` cookbook that sends reports and exceptions to Hipchat.

This cookbook is heavily based on [rackspace-cookbooks/chef-slack_handler](https://github.com/rackspace-cookbooks/chef-slack_handler).

My company (sadly) decided to abandon Slack in favor of Hipchat, and I wanted to keep the same features with it.

Have fun with it and feel free to contribute !

Requirements
============

* The `chef_handler` cookbook
* An existing Hipchat auth token
* A working room name

Usage
=====

1. Create a new auth token in Hipchat
2. Set the `room` and `auth_token` attributes above on the node/environment/etc.
3. Include this `hipchat_handler` recipe or put it on your run_list.

Attributes
==========
* `node['chef_client']['handler']['hipchat']['auth_token']` - The Auth token of you Hipchat integration
* `node['chef_client']['handler']['hipchat']['room']` - Your Hipchat room

Optional attributes

* `node['chef_client']['handler']['hipchat']['emoji_url']` - The message emoji icon url (default: nil)
* `node['chef_client']['handler']['hipchat']['detail_level']` - The level of detail in the message. Valid options are `basic`, `elapsed` (default: 'basic')
* `node['chef_client']['handler']['hipchat']['fail_only']` - Only report when runs fail as opposed to every single occurance (default: true)
* `node['chef_client']['handler']['hipchat']['timeout']` - Hipchat connector timeout in seconds (default: 10)

Credits
=======

Borrowed everything from the `slack_handler` cookbook ! Thanks to them !

License
=======

`hipchat_handler` is provided under the Apache License 2.0. See `LICENSE` for details.
