{ config, pkgs, ... }:
{
  imports = [ ];
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ config.services.nextcloud.config.dbname ];
    ensureUsers = [
      rec {
        name = config.services.nextcloud.config.dbuser;
        ensurePermissions."${name}.*" = "ALL PRIVILEGES";
      }
    ];
    settings.mysqld = {
      innodb_file_per_table = true;
    };
  };

  services.mysqlBackup = {
    enable = true;
    singleTransaction = true;
    user = config.services.nextcloud.config.dbuser;
    databases = [ config.services.nextcloud.config.dbname ];
    location = "/mnt/tank/nextcloud/db_backup";
  };
}
