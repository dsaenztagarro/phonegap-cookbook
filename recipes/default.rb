#
# Cookbook Name:: phonegap
# Recipe:: default
#
# Copyright (C) 2014 David Saenz Tagarro
#
# All rights reserved - Do Not Redistribute
#

# Added android sdk tools to PATH environment
cookbook_file 'copy_bashrc' do
  path '/home/vagrant/.bashrc'
  source 'bashrc'
  owner 'vagrant'
  group 'vagrant'
  action :create
end

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
