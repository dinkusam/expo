self: super:

{
  androidenv = super.androidenv // rec {

    androidndk_10e = super.androidenv.androidndk_10e.override { fullNDK=true; };

    # prefer consistency with react-native submodule even over updates?
    buildTools = super.androidenv.buildTools.overrideAttrs (oldAttrs: rec {
      version = "27.0.3";
      name = "android-build-tools-r${version}";
      src = if (super.hostPlatform.system == "i686-linux" || super.hostPlatform.system == "x86_64-linux")
      then super.fetchurl {
        url = "https://dl.google.com/android/repository/build-tools_r27.0.3-linux.zip";
        sha256 = "15vbkvf0vcba3437am2r16a7vrdj7c8cryan1h9dw4rz432ly7sy";
      }
      else if super.hostPlatform.system == "x86_64-darwin" then super.fetchurl {
        url = "https://dl.google.com/android/repository/build-tools_r27.0.3-macosx.zip";
        sha256 = "1mvhsvl0hgbxkkj78f2wc4al7nxjm5x4i98wc63rnsz78fqs8f0j";
      }
      else throw "System ${super.hostPlatform.system} not supported!";
      # Copied in full from upstream package, so ${version} is interpolated correctly
      buildCommand = oldAttrs.buildCommand + ''
        cd ..
        mv ${oldAttrs.version} ${version}
      '';
    });

    ourSDK = self.androidenv.androidsdk {
      inherit buildTools;
      platformVersions = [ "26" "27" ];
      abiVersions = [ "x86" "x86_64"];
      useGoogleAPIs = true;
      useExtraSupportLibs = true;
      useGooglePlayServices = true;
      useInstantApps = true;
    };
  };
}
