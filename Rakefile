task :write_machine do
    sh 'echo "{ hostname = \"$(hostname)\"; username = \"$(whoami)\"; homedir = \"$HOME\"; operatingSystem = \"$(uname -v | awk \'{ print $1 }\' | sed \'s/#.*-//\')\"; }" > machine.nix'
end

task :common do
    sh "mkdir -p $HOME/.config/nixpkgs"
    sh "rm $HOME/.config/nixpkgs/config.nix"
    sh "ln -s $(pwd)/config.nix $HOME/.config/nixpkgs/config.nix"
    sh "rm $HOME/.config/nixpkgs/home.nix"
    sh "ln -s $(pwd)/home.nix $HOME/.config/nixpkgs/home.nix"
end

task mac: [:common] do
    sh "rm $HOME/.nixpkgs/darwin-configuration.nix"
    sh "ln -s $(pwd)/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix"
end

task nixos: [:common] do
    # todo
end
