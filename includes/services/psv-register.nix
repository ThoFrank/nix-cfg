{ config, pkgs, ... }:
{
  services.psv-registration-wa = {
    enable = true;
    smtp-password-file = "/.secret/psv.smtp.pass";
    nginx = {
      enable = true;
      hostNames = ["amwa.bogen-psv.de" "anmeldung.bogen-psv.de" "wa.psv-register.franks-im-web.de"];
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

  };services.psv-registration-feld = {
    enable = true;
    smtp-password-file = "/.secret/psv.smtp.pass";
    nginx = {
      enable = true;
      hostNames = [ "amfeld.bogen-psv.de" "feld.psv-register.franks-im-web.de" ];
    };
    settings = {
      port = 3002;
      mail_server = {
        smtp_server = "alfa3023.alfahosting-server.de";
        smtp_username = "web1218p6";
        smtp_password = "t0p_secret";
      };
      mail_message = {
        sender_name = "Thomas Frank";
        sender_address = "sport@bogen-psv.de";
        subject = "Anmeldebestätigung Vereinsmeisterschaft Feld";
      };
    };

  };
}
