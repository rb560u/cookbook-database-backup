#
# Cookbook Name:: database-backup
# Recipe:: default
#
# Copyright 2013, Jay Pipes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node["platform_family"]
when "debian"
  include_recipe "apt"

  apt_repository "percona" do
    uri "http://repo.percona.com/apt"
    distribution node["lsb"]["codename"]
    components ["main"]
    keyserver "keys.gnupg.net"
    key "1C4CBDCDCD2EFD2A"
    action :add
    notifies :run, "execute[apt-get update]", :immediately
  end
  
  # Pin this repo as to avoid conflicts with others
  apt_preference "00percona" do
    package_name "*"
    pin " release o=Percona Development Team"
    pin_priority "1001"
  end
  
  # install dependent package
  package "libmysqlclient-dev" do
    options "--force-yes"
  end

when "rhel"
  include_recipe "yum"
  yum_key "RPM-GPG-KEY-percona" do
    url "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
    action :add
  end

  yum_repository "percona" do
    name "CentOS-Percona"
    url "http://repo.percona.com/centos/#{node["platform_version"].split('.')[0]}/os/#{node["kernel"]["machine"]}/"
    key "RPM-GPG-KEY-percona"
    action :add
  end
end

case node["platform_family"]
when "debian"
  package "xtrabackup"
when "rhel"
  package "percona-xtrabackup"
end

group node['database-backup']['group'] do
  action :create
end

user node['database-backup']['user'] do
  gid node['database-backup']['group']
  shell "/bin/bash"
  home "/home/#{node['database-backup']['user']}"
  action :create
end

directory node['database-backup']['backup-dir'] do
  owner node['database-backup']['user']
  group node['database-backup']['group']
  mode 00700
end

gem_package "synaptic4r" do
  action :install
end

mysql_user = node['database-backup']['mysql']['user']
key_path = "/etc/chef/encrypted_data_bag_secret"
secret = ::Chef::EncryptedDataBagItem.load_secret key_path
mysql_pass = ::Chef::EncryptedDataBagItem.load('user_passwords', mysql_user, secret)[mysql_user]
staas_secret = ::Chef::EncryptedDataBagItem.load('secrets', 'staas_secret', secret)['staas_secret']

template "/home/#{node['database-backup']['user']}/.synaptic4r" do
  source ".synaptic4r.erb"
  owner node['database-backup']['user']
  group node['database-backup']['group']
  mode   00600
  variables(
    "staas_secret" => staas_secret
  )
end

template "#{node['database-backup']['backup-dir']}/backup_databases" do
  source "backup_databases.bash.erb"
  owner node['database-backup']['user']
  group node['database-backup']['group']
  mode   00700  # The script has the backup MySQL user password, so only owner should read.
  variables(
    "mysql_pass" => mysql_pass
  )
end

cron_d "backup_databases" do
  minute node['database-backup']['cron']['minute']
  hour node['database-backup']['cron']['hour']
  command "/opt/scripts/backup_databases"
  user node['database-backup']['user']
end
