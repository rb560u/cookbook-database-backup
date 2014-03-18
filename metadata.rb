name             "database-backup"
maintainer       "Jay Pipes"
maintainer_email "jaypipes@att.com"
license          "Apache 2.0"
description      "Installs/Configures Percona XtraBackup and sets up automated backup of MySQL databases"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.2"

recipe           "database-backup", "Installs Percona XtraBackup and sets up backups"

supports         "ubuntu", ">= 12.04"

depends "apt"
depends "yum"
