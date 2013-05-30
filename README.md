Description
===========

Installs/Configures Percona XtraBackup and sets up automated backups
of MySQL databases.

This cookbook is geared towards our AT&T infrastructure and is a wrapper
cookbook not meant for upstream release or use.

Requirements
============

* Chef 0.8+

Attributes
==========

* `default['database-backup']['user'] - User that executes the backup script (via Cron).
* `default['database-backup']['group'] - Group for executing user.
* `default['database-backup']['mysql']['user'] - User that runs the MySQL/innobackupex commands. Password is retrieved from encrypted data bag 'user_passwords'.
* `default['database-backup']['backup-dir']` - Root directory for storing database backups.
* `default['database-backup']['staas']['user'] - User for Synaptic STaaS.
* `default['database-backup']['cron']['minute'] - The minute of the hour to run backup script in Cron.
* `default['database-backup']['cron']['hour'] - The hour to run backup script in Cron.
* `default['database-backup']['number-keep-local'] - Number of backups to keep locally.

Usage
=====

```json
"run_list": [
    "recipe[database-backup]"
]
```

default
----

Installs/Configures Percona XtraBackup and adds cron jobs that backup
the MySQL databases using `innobackupex` and then rsync'ing the backups
to an offsite host.

Testing
=======

    $ bundle install
    $ bundle exec berks install
    $ bundle exec strainer test

License and Author
==================

Author:: Jay Pipes (<jaypipes@att.com>)

Copyright 2013, Jay Pipes

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and 
limitations under the License.
