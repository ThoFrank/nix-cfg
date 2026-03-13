{ inputs, ... }:
{
  flake.modules.nixpkgs.overlays = [(
    final: prev: {
      unstable = import inputs.unstable { system = final.stdenv.hostPlatform.system; config.allowUnfree = true;};
    }
  )];
}

