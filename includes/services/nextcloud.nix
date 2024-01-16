{ config, pkgs, ... }:
{
  imports = [ ];
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "cloud.franks-im-web.de";
    https = true;
    home = "/mnt/tank/nextcloud/nextcloud";
    phpOptions."opcache.interned_strings_buffer" = "16";
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
