{ config, pkgs, ... }:
{
  imports = [ ];
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "cloud.franks-im-web.de";
    https = true;
    home = "/mnt/tank/nextcloud/nextcloud";
    phpOptions."opcache.interned_strings_buffer" = "16";
    config = {
      adminuser = "admin";
      adminpassFile = "/.secret/nextcloud.admin.pass";

      # db
      dbtype = "mysql";
      dbuser = "nextcloud";
      dbname = "nextcloud";
      dbpassFile = "/.secret/db.nextcloud.pass";
      dbhost = "localhost:${builtins.toString config.services.mysql.settings.mysqld.port}";
    };

    settings = {
      trusted_domains = [ "frankcloud.firewall-gateway.com" ];
      default_phone_region = "DE";
    };
  };
}
