{ config, pkgs, ... }:
{
  imports = [ ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "thomas@franks-im-web.de";
  };
}
