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

default['database-backup']['mysql']['user'] = 'mysqlbackup'
default['database-backup']['backup-dir'] = '/var/backups'
default['database-backup']['staas']['account'] = 'silverlining'
default['database-backup']['staas']['subtenant'] = '2468cc9edc67443584efd34622fac02e'
default['database-backup']['staas']['userid'] = 'backup'
default['database-backup']['staas']['directory'] = '<ZONE>'
default['database-backup']['cron']['minute'] = 0
default['database-backup']['cron']['hour'] = '*'
default['database-backup']['number-keep-local'] = 6
