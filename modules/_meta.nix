{ lib, ... }:
{
  options.meta = {
    username = lib.mkOption {
      type = lib.types.singleLineStr;
      readOnly = true;
      default = "thomas";
    };
    homeDir = lib.mkOption {
      type = lib.types.singleLineStr;
      readOnly = true;
      # default = "/home/${config.username}";
    };
    gitUserName = lib.mkOption {
      type = lib.types.singleLineStr;
      readOnly = true;
      default = "Thomas Frank";
    };
    gitUserEmail = lib.mkOption {
      type = lib.types.singleLineStr;
      readOnly = true;
      default = "thomas@franks-im-web.de";
    };
  };
}
