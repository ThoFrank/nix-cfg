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
  };
}
