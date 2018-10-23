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
      # uuuuugh
      buildCommand = ''
        mkdir -p $out/build-tools
        cd $out/build-tools
        unzip $src
        mv android-* ${version}

        ${super.lib.optionalString (super.hostPlatform.system == "i686-linux" || super.hostPlatform.system == "x86_64-linux")
          ''
            cd ${version}

            ln -s ${self.ncurses.out}/lib/libncurses.so.5 `pwd`/lib64/libtinfo.so.5

            find . -type f -print0 | while IFS= read -r -d "" file
            do
              type=$(file "$file")
              ## Patch 64-bit binaries
              if grep -q "ELF 64-bit" <<< "$type"
              then
                if grep -q "interpreter" <<< "$type"
                then
                  patchelf --set-interpreter ${self.stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 "$file"
                fi
                patchelf --set-rpath `pwd`/lib64:${self.stdenv.cc.cc.lib.out}/lib:${self.zlib.out}/lib:${self.ncurses.out}/lib "$file"
              ## Patch 32-bit binaries
              elif grep -q "ELF 32-bit" <<< "$type"
              then
                if grep -q "interpreter" <<< "$type"
                then
                  patchelf --set-interpreter ${self.stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 "$file"
                fi
                patchelf --set-rpath ${self.stdenv_32bit.cc.cc.lib.out}/lib:${self.zlib_32bit.out}/lib:${self.ncurses_32bit.out}/lib "$file"
              fi
            done
          ''}

          patchShebangs .
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
