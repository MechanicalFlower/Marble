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

  # Export presets by Arch/OS
  presets = {"x86_64-linux" = "Linux/X11";};

  # Parse plug.gd file and dynamically create addon derivations
  addons = let
    sources = builtins.fromJSON (pkgs.lib.strings.fileContents ./.godot-deps.json);
  in
    builtins.map(u: pkgs.godotpkgs.mkPlug {
      inherit (u) owner repo hash;
      rev = u.commit;
    }) sources.addons;
in pkgs.godotpkgs."${envVars.GODOT_VERSION}".mkGodot rec {
  inherit addons;

  pname = envVars.GAME_NAME;
  version = envVars.GAME_VERSION;
  src = ./.;
  preset = presets.${system} or (throw "Unsupported system: ${system}");

  preBuildPhase = ''
    # TODO: ensure to patch game version
    substituteInPlace ./public/packaging/org.mechanicalflower.Marble.desktop --replace-fail 'Icon=org.mechanicalflower.Marble' '$out/share/icons/hicolor/apps/marble.png'
    substituteInPlace ./public/packaging/org.mechanicalflower.Marble.desktop --replace-fail 'Exec=marble-wrapper' 'Exec=$out/bin/${pname}'
  '';

  preInstallPhase = ''
    install -D -m 644 -t $out/share/applications ./public/packaging/org.mechanicalflower.Marble.desktop
    install -D -m 644 -T ./assets/icon.png $out/share/icons/hicolor/apps/marble.png
  '';
}
