#
# Cookbook Name:: phonegap
# Recipe:: default
#
# Copyright (C) 2014 Redradix
#
# All rights reserved - Do Not Redistribute
#

include_recipe "my-environment"

include_recipe "my-environment::permissions"

# Backend

node.default['nodejs']['version'] = '0.10.28'
include_recipe 'nodejs'

execute "install_js_utils" do
  command <<-EOH
    npm install -g grunt-cli bower phonegap
  EOH
end
