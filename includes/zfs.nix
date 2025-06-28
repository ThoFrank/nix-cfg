{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  # networking.hostId = "d5946d97";
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  boot.zfs.forceImportAll = true;
  boot.zfs.devNodes = "/dev/disk/by-path";
  boot.zfs.extraPools = [ "tank" ];
  
  # auto snapshots
  users.users.sanoid = {
    group = "sanoid";
    isSystemUser = true;
    extraGroups = [];
  };
  users.groups.sanoid = {};
  services.sanoid = {
    enable = true;
    templates = {
      movies = {
        daily = 30;
        monthly = 3;
        yearly = 1;
        autosnap = true;
        autoprune = true;
      };
      data = {
        hourly = 24;
        daily = 30;
        monthly = 3;
        yearly = 2;
        autosnap = true;
        autoprune = true;
      };
    };
    datasets = {
      "tank/Bilder-Thomas" = {
        use_template = [ "data" ];
        recursive = true;
      };
      "tank/Filme" = {
        use_template = [ "movies" ];
        recursive = true;
      };
      "tank/Share_Public" = {
        use_template = [ "data" ];
        recursive = true;
      };
      "tank/Shared" = {
        use_template = [ "data" ];
        recursive = true;
      };
      "tank/nextcloud" = {
        use_template = [ "data" ];
        recursive = true;
      };
      "tank/psv_vm_backup" = {
        use_template = [ "data" ];
        recursive = true;
      };
    };
    extraArgs = [ "--cache-dir" "/var/cache/sanoid" "--verbose" "--force-update" ];
  };
  
  # auto backup
  services.syncoid = {
    enable = true;
    interval = "daily";
    commands = {
      pi = {
        source = "tank";
        target = "backup";
        recursive = true;
      };
    };
    commonArgs = [ "--no-sync-snap" ];
  };

  services.smartd.enable = true;
}
