#
# Cookbook Name:: phonegap
# Recipe:: default
#
# Copyright (C) 2014 David Saenz Tagarro
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'my-environment'
include_recipe 'my-environment::permissions'
include_recipe 'my-environment::gui'

# Added android sdk tools to PATH environment
cookbook_file 'copy_bashrc' do
  path '/home/vagrant/.bashrc'
  source 'bashrc'
  owner 'vagrant'
  group 'vagrant'
  action :create
end

include_recipe 'my-environment::locales'

# Backend

node.default['java']['install_flavor'] = 'oracle'
node.default['java']['jdk_version'] = '7'
node.default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java'

# This package contains runtime libraries for the ia32/i386 architecture,
# configured for use on an amd64 or ia64 Debian system running a 64-bit kernel.
execute 'add_runtime_libraries_i386' do
  command <<-EOH
    sudo apt-get install -y ia32-libs
  EOH
end

# http://developer.android.com/sdk/index.html
# Download for other platforms | Adt bundle
execute 'install_android_bundle' do
  user "vagrant"
  group "vagrant"
  cwd "/home/vagrant"
  environment ({'HOME' => '/home/vagrant', 'USER' => 'vagrant'})
  command <<-EOH
    mkdir -p ~/Development/android
    cd ~/Development/android
    wget http://dl.google.com/android/adt/22.6.2/adt-bundle-linux-x86_64-20140321.zip
    unzip adt-bundle-linux-x86_64-20140321.zip
    touch .adt-bundle
    source ~/.bashrc
    android update sdk --no-ui
  EOH
  not_if do ::File.exists?('/home/vagrant/Development/android/.adt-bundle') end
end

# Added android sdk tools to PATH environment
cookbook_file 'copy_bashrc' do
  path '/home/vagrant/.bashrc'
  source 'bashrc'
  owner 'vagrant'
  group 'vagrant'
  action :create
end

node.default['nodejs']['version'] = '0.10.28'
include_recipe 'nodejs'

execute 'install_js_utils' do
  command <<-EOH
    npm install -g grunt-cli bower phonegap
  EOH
end

# Project settings

execute 'install_node_utils' do
  command <<-EOH
    npm install -g express-generator
  EOH
end

execute 'install_mongodb' do
  command <<-EOH
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    sudo apt-get update
    sudo apt-get install mongodb-org
    apt-get install mongodb-org=2.6.3 mongodb-org-server=2.6.3 mongodb-org-shell=2.6.3 mongodb-org-mongos=2.6.3 mongodb-org-tools=2.6.3
  EOH
end

execute 'pin_version_mongodb' do
  command <<-EOH
    echo "mongodb-org hold" | sudo dpkg --set-selections
    echo "mongodb-org-server hold" | sudo dpkg --set-selections
    echo "mongodb-org-shell hold" | sudo dpkg --set-selections
    echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
    echo "mongodb-org-tools hold" | sudo dpkg --set-selections
  EOH
end
