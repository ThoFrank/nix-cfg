{ config, pkgs, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nixnas
      netbios name = nixnas
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.2. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      "Bilder" = {
        path = "/mnt/tank/Bilder-Thomas";
        browsable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "force user" = "thomas";
        "force group" = "bilder";
      };
      "Filme" = {
        path = "/mnt/tank/Filme";
        browsable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "force user" = "thomas";
        "force group" = "users";
      };
      "Time Machine" = {
        path = "/mnt/tank/Backup/TM";
        "valid users" = "thomas";
        public = "no";
        writeable = "yes";
        "force user" = "thomas";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };
}
