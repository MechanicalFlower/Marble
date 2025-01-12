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
  preset = presets.${system} or (throw "Unsupported system: ${system}");

  # Godot version with dot (used to store export templates)
  godot_version_folder = pkgs.lib.replaceStrings [ "-" ] [ "." ] envVars.GODOT_VERSION;
in
  pkgs.stdenv.mkDerivation {
    pname = gameName;
    version = gameVersion;

    src = ./.;

    nativeBuildInputs = [pkgs.godot_4 pkgs.makeWrapper pkgs.autoPatchelfHook];
    runtimeDependencies = [
      pkgs.vulkan-loader
      pkgs.libGL
      pkgs.xorg.libX11
      pkgs.xorg.libXcursor
      pkgs.xorg.libXinerama
      pkgs.xorg.libXext
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.xorg.libXi
      pkgs.xorg.libXfixes
      pkgs.libxkbcommon
      pkgs.alsa-lib
    ];

    patchPhase = ''
      runHook prePatch

      # TODO: ensure to patch game version
      substituteInPlace ./public/packaging/org.mechanicalflower.Marble.desktop --replace-fail 'Icon=org.mechanicalflower.Marble' '$out/share/icons/hicolor/apps/marble.png'
      substituteInPlace ./public/packaging/org.mechanicalflower.Marble.desktop --replace-fail 'Exec=marble-wrapper' 'Exec=$out/bin/${gameName}'

      godot4 --headless --script $src/plug.gd install force || true
      godot4 --headless --import

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      mkdir -p $HOME/.local/share/godot/export_templates
      ln -s "${godot}/templates" "$HOME/.local/share/godot/export_templates/${godot_version_folder}"

      mkdir -p build
      godot4 --headless --export-release "${preset}" ./build/${gameName}.x86_64
      
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -D -m 755 -t $out/share/${gameName} ./build/${gameName}.x86_64
      install -D -m 644 -t $out/share/${gameName} ./build/${gameName}.pck
      install -D -m 644 -t $out/share/applications ./public/packaging/org.mechanicalflower.Marble.desktop
      install -D -m 644 -T ./assets/icon.png $out/share/icons/hicolor/apps/marble.png
      install -d -m 755 $out/bin

      makeWrapper $out/share/${gameName}/${gameName}.x86_64 $out/bin/${gameName} \
        --add-flags "--main-pack" \
        --add-flags "$out/share/${gameName}/${gameName}.pck" \
        --add-flags "--rendering-driver opengl3"

      runHook postInstall
    '';

    # passthru.updateScript = pkgs.nix-update-script { };

    meta = {
      description = "A marble race minigame";
      homepage = "https://github.com/MechanicalFlower/Marble";
      changelog = "https://github.com/MechanicalFlower/Marble/blob/main/CHANGELOG.md";
      license = pkgs.lib.licenses.mit;
      platforms = pkgs.lib.attrNames presets;
      maintainers = [pkgs.lib.maintainers.florianvazelle];
      mainProgram = gameName;
    };
  }
