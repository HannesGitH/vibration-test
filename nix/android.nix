{ androidenv }:

androidenv.composeAndroidPackages {
  toolsVersion = "26.1.1";
  platformToolsVersion = "34.0.5";
  buildToolsVersions = [ "30.0.0"  "30.0.3" "31.0.0" ];
  includeEmulator = true;
  emulatorVersion = "34.1.9";
  platformVersions = [ "31" "33" ];
  includeSources = false;
  includeSystemImages = true;
  systemImageTypes = [ "google_apis_playstore" ];
  abiVersions = [ "x86_64" "armeabi-v7a" "arm64-v8a" ];
  cmakeVersions = [ "3.10.2" "3.18.1" ];
  includeNDK = true;
  ndkVersions = [ "23.1.7779620" "22.0.7026061" ];
  useGoogleAPIs = false;
  useGoogleTVAddOns = false;
  #avdmanager
  extraLicenses = [
      "android-sdk-preview-license"
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  # extras = ["extras;google;gcm"];
}

# androidenv.androidPkgs_9_0