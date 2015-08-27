# Attributes for Hipchat intergration
# (default attributes are set inside handler)
## required attributes
default['chef_client']['handler']['hipchat']['auth_token'] = nil
default['chef_client']['handler']['hipchat']['room'] = nil
## Optional attributes
default['chef_client']['handler']['hipchat']['emoji_url'] = nil
default['chef_client']['handler']['hipchat']['detail_level'] = nil
default['chef_client']['handler']['hipchat']['report_success'] = nil
default['chef_client']['handler']['hipchat']['timeout'] = nil
