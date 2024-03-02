{
  description = "Flutter Vibration App";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkg-opts = {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };
        pkgs = import nixpkgs { inherit (pkg-opts) system config;};
        pkgs-stable = import nixpkgs-stable { inherit (pkg-opts) system config; };
        mympv = pkgs-stable.mpv;
      in {
        devShells.default =
          let 
            java = pkgs.jdk17;
            android = pkgs-stable.callPackage ./nix/android.nix { };
          in pkgs.mkShell {
            buildInputs = with pkgs; [
              git 

              #  myflutter 
              # (flutter.override { channel = "master"; })
              flutter

              # flutter web:
              google-chrome

              # java and android
              java
              #  glibc
              android.androidsdk
              # android-studio #prinzipiell nicht nötig wenn avdmanager läuft

              # linux 
              clang
              cmake
              ninja
              pkg-config
              gtk3
              pkgs-stable.glib
              # pkgs-stable.pcre.dev
              libepoxy.dev
            ];

            ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
            JAVA_HOME = java;
            ANDROID_AVD_HOME = (toString ./.) + "/.android/avd";
            #  ANDROID_AVD_HOME = "$HOME/.config/.android/avd";
            ANDROID_SDK_ROOT = "${android.androidsdk}/libexec/android-sdk";
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android.androidsdk}/libexec/android-sdk/build-tools/31.0.0/aapt2";
            CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";

            #  LD_LIBRARY_PATH= "${pkgs.alsa-lib}/lib:${pkgs.libdrm}/lib:${pkgs.libGL}/lib:${pkgs.libepoxy}/lib:${pkgs.pulseaudio}/lib:${pkgs.mesa}/lib:${pkgs.xorg.libX11}/lib:$LD_LIBRARY_PATH";
            LD_LIBRARY_PATH= "${mympv}/lib:${pkgs.libass}/lib:$LD_LIBRARY_PATH"; #for media kit linux build

            #  PATH = "$PATH:${pkgs.flutter}/bin/cache/dart-sdk";
            FLUTTER_ROOT = "${pkgs.flutter}";

            #  LD_LIBRARY_PATH= "${libepoxy}/lib";
          
              # yes | flutter doctor --android-licenses
            shellHook = ''
              export PATH=$PATH:${pkgs.flutter}/bin/cache/dart-sdk/bin
            '';
          };
      });
}
