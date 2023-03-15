{ config, pkgs, ... }:
{
  services.psv-registration-wa = {
    enable = true;
    smtp-password-file = "/.secret/psv.smtp.pass";
    nginx = {
      enable = true;
      hostNames = ["anmeldung.bogen-psv.de" "wa.psv-register.franks-im-web.de"];
    };
    settings = {
      port = 3001;
      mail_server = {
        smtp_server = "alfa3023.alfahosting-server.de";
        smtp_username = "web1218p6";
        smtp_password = "t0p_secret";
      };
      mail_message = {
        sender_name = "Thomas Frank";
        sender_address = "sport@bogen-psv.de";
        subject = "Anmeldebestätigung Vereinsmeisterschaft WA";
      };
    };

  };
}
