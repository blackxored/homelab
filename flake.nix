{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };
  inputs.talhelper.url = "github:budimanjojo/talhelper";

  outputs = {
    nixpkgs,
    flake-utils,
    talhelper,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            (pkgs.python313.withPackages (p: [
              p.pipx
            ]))
            pkgs.mise
            pkgs.talosctl
            pkgs.kubectl
            pkgs.k9s
            pkgs.age
            pkgs.cue
            pkgs.cloudflared
            pkgs.go-task
            pkgs.makejinja
            pkgs.fluxcd
            pkgs.jq
            pkgs.sops
            pkgs.kubeconform
            pkgs.kustomize
            talhelper.packages.${system}.default
          ];
          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
          ];
        };
      }
    );
}
