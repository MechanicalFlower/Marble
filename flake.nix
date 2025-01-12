{
  description = "Marble flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    godot.url = "path:/home/phlowrient/projects/by-lang/nix/godot-nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    godot,
    # nixgl,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ godot.overlays.default ];
    };

  in {
    packages.x86_64-linux.default = import ./default.nix {
      inherit pkgs system;
    };

    apps.default = {
      type = "app";
      program = "${self.packages.x86_64-linux.default}/bin/Marble";
    };

    # devShells.x86_64-linux.default = pkgs.mkShell {
    #   packages = [pkgs.godot_"${envVars.GODOT_VERSION}"];
    # };
  };
}
