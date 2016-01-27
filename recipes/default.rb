#
# Cookbook Name:: hipchat_handler
# Recipe:: default
#
# Copyright (C) 2015 Barthelemy Vessemont
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'chef_handler'

chef_gem 'hipchat'

cookbook_file File.join(node['chef_handler']['handler_path'], 'hipchat_handler.rb') do
  source 'hipchat_handler.rb'
  mode '0600'
  action :create
end

chef_handler 'Chef::Handler::Hipchat' do
  source File.join(node['chef_handler']['handler_path'], 'hipchat_handler.rb')
  arguments [
    node['chef_client']['handler']['hipchat']
  ]
end
