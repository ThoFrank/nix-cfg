{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Setup Nextcloud virtual host to listen on ports
    virtualHosts = {

      "cloud.franks-im-web.de" = {
        ## Force HTTP redirect to HTTPS
        forceSSL = true;
        ## LetsEncrypt
        enableACME = true;
        serverAliases = ["frankcloud.firewall-gateway.com"];
      };
      "brebeck.online" = {
        forceSSL = true;
        enableACME = true;
        root = ./brebeck.online;
        serverAliases = ["www.brebeck.online"];
      };
      "_"= {
        forceSSL = false;
        enableACME = false;
        rejectSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${builtins.toString config.services.homepage-dashboard.listenPort}";
        };
      };
    };
  };
}
