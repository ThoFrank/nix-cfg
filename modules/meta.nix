{ lib, ... }:
{
  options.username = lib.mkOption {
    type = lib.types.singleLineStr;
    readOnly = true;
    default = "thomas";
  };
  options.homeDir = lib.mkOption {
    type = lib.types.singleLineStr;
    default = "/home/thomas";
  };
  options.gitUserName = lib.mkOption {
    type = lib.types.singleLineStr;
    readOnly = true;
    default = "Thomas Frank";
  };
  options.gitUserEmail = lib.mkOption {
    type = lib.types.singleLineStr;
    readOnly = true;
    default = "thomas@franks-im-web.de";
  };
}
