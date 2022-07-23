{ config, pkgs, ... }:
{
  imports = [ ];
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24;
    hostName = "cloud.franks-im-web.de";
    https = true;
    config = {
      adminuser = "admin";
      adminpassFile = "/.secret/nextcloud.admin.pass";

      extraTrustedDomains = [ "frankcloud.firewall-gateway.com" ];

      # db
      dbtype = "mysql";
      dbuser = "nextcloud";
      dbname = "nextcloud";
      dbpassFile = "/.secret/db.nextcloud.pass";
      dbport = builtins.toString config.services.mysql.settings.mysqld.port;
    };
  };
}
