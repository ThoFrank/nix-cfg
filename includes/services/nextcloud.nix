{ config, pkgs, ... }:
{
  imports = [ ];
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "cloud.franks-im-web.de";
    https = true;
    # home = "/mnt/tank/nextcloud/nextcloud";
    home = "/mnt/tank/services/nextcloud/nextcloud";
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

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
    extraAppsEnable = true;

    settings = {
      trusted_domains = [ "frankcloud.firewall-gateway.com" ];
      default_phone_region = "DE";
    };
  };

  services.nginx.virtualHosts."cloud.franks-im-web.de" = {
    ## Force HTTP redirect to HTTPS
    forceSSL = true;
    ## LetsEncrypt
    enableACME = true;
    serverAliases = ["frankcloud.firewall-gateway.com"];
  };

  users.users.nextcloud.extraGroups = [ "Bilder" ];
}
