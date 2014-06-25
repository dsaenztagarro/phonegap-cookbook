#
# Cookbook Name:: phonegap
# Recipe:: default
#
# Copyright (C) 2014 Redradix
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

# Backend

# Not valid for phonegap development
# Install OpenJDK
# execute 'install_open_jdk' do
#   command <<-EOH
#     apt-get install -y default-jre
#     apt-get install -y default-jdk
#     apt-get install -y ant
#   EOH
# end

execute 'install_java' do
  command <<-EOH
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java7-installer
  EOH
end

# TODO: refactor to execute only if android command doesnt exist
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
    touch .adt-bundle-linux-installed
    source ~/.bashrc
    android update sdk -u
  EOH
end

node.default['nodejs']['version'] = '0.10.28'
include_recipe 'nodejs'

execute 'install_js_utils' do
  command <<-EOH
    npm install -g grunt-cli bower phonegap
  EOH
end
