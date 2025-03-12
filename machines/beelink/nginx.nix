{ ... }:
{
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedZstdSettings = true;
    recommendedProxySettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    
    virtualHosts = {
      "_" = {
        default = true;
        forceSSL = false;
        enableACME = false;
        rejectSSL = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
