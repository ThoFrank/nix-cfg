{pkgs, ...}:
{
  users.groups.psv-backup = {};
  users.users.psv-backup = {
    isNormalUser = true;
    home = "/var/empty";
    group = "psv-backup";
    openssh.authorizedKeys.keys = [
      ''command="${pkgs.rrsync}/bin/rrsync /mnt/tank/psv_vm_backup/",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlzwP2KAQ3bCi2CIrd80/jKipfJ+YGCn8iAWhwmtN7d''
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlzwP2KAQ3bCi2CIrd80/jKipfJ+YGCn8iAWhwmtN7d psv@vmd152122"
    ];
  };
}
