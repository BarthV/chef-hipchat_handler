Description
===========

A `chef_handler` cookbook that sends reports and exceptions to Hipchat.

This cookbook is heavily based on [rackspace-cookbooks/chef-slack_handler](https://github.com/rackspace-cookbooks/chef-slack_handler).

My company (sadly) decided to abandon Slack in favor of Hipchat, and I wanted to keep the same features with it.

Requirements
============

* The `chef_handler` cookbook
* An existing Hipchat auth token
* In option, a room name

Usage
=====

1. Create a new auth token in hipchat (https://slack.com/services/new/incoming-webhook)
2. Set the `room` and `api_key` attributes above on the node/environment/etc.
3. Include this `hipchat_handler` recipe.

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
