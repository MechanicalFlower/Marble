{
  pkgs ? import <nixpkgs> {},
  system ? builtins.currentSystem,
}: let
  # Parse .env file into a key-value pair
  envVars = builtins.listToAttrs (map (line: let
    # Split the line by the first '=' to separate key and value
    parts = pkgs.lib.strings.splitString "=" line;
  in {
    name = builtins.elemAt parts 0;
    value = builtins.elemAt parts 1;
  }) (
    builtins.filter
    (line: (builtins.match ".+=.+" line) != null)
    (pkgs.lib.strings.splitString "\n" (builtins.readFile ./.env))
  ));

  # Godot Editor
  godot = pkgs.godotpkgs."${envVars.GODOT_VERSION}";

  # Game data
  gameName = envVars.GAME_NAME;
  gameVersion = envVars.GAME_VERSION;

  # Export preset by Arch/OS
  presets = {"x86_64-linux" = "Linux/X11";};

  # TODO: create these derivations dynamically by parsing `plug.gd`
  godot-debug-menu =  pkgs.mkPlug {
    repo = "godot-extended-libraries/godot-debug-menu";
    rev = "3211673efc9d1e41f94bbd74705eaed2d2b8bdd7";
    hash = "sha256-1vUBulNYW0y58KOyBCyhPSa19v2HfUmvxncsSb1XxgQ=";
  };
  godot-universal-fade = pkgs.mkPlug {
    repo = "KoBeWi/Godot-Universal-Fade";
    rev = "f091514bba652880f81c5bc8809e0ee4498988ea";
    hash = "sha256-hAbrZuGrlQxth6oIfpU6vKFqv1iI2hiFrQo2BiY5ElI=";
  };
in pkgs.mkGodot {
  pname = gameName;
  version = gameVersion;
  src = ./.;
  addons = [godot-debug-menu godot-universal-fade];
  preset = presets.${system} or (throw "Unsupported system: ${system}");
  exportTemplates = "${godot}/templates";
}
