(self: super: {
  octoprint = super.octoprint.override {
    packageOverrides = pyself: pysuper: {
      octoprint-M73ETAOverride = pyself.buildPythonPackage rec {
        pname = "M73ETAOverride";
        version = "1.0.4";
        src = self.fetchFromGitHub {
          owner = "gdombiak";
          repo = "OctoPrint-${pname}";
          rev = "${version}";
          sha256 = "sha256-sp9Ux4JfP0oM+PkxCz2H8n6LRjoUE1xsiAfMe8EFLa8=";
        };
        propagatedBuildInputs = [ pysuper.octoprint ];
        doCheck = false;
      };
    };
  };
})
