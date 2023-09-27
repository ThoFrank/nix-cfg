# DDNS with inadyn

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.inadyn;
in {
  options.services.inadyn = with types; {
    enable = mkEnableOption "Nameserver updates with inadyn";
    interval = mkOption {
      default = "*-*-* *:*:00";
      type = str;
    };
    configFile = mkOption {
      type = path;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.inadyn = {
      description = "Update nameservers with inadyn";
      startAt = cfg.interval;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.inadyn}/bin/inadyn -f ''${CREDENTIALS_DIRECTORY}/config --cache-dir /var/cache/inadyn -1 --foreground -l debug'';
        LoadCredential = "config:${cfg.configFile}";
        CacheDirectory = "inadyn";

        DynamicUser = true;
        UMask = "0177";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectProc = "invisible";
        ProtectHome = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
        CapabilityBoundingSet = "";
      };
    };
  };

}

