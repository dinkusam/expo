with (import ../. {});

mkShell {
  LANG="en_US.UTF-8";
  LANGUAGE="en_US:en";
  LC_ALL="en_US.UTF-8";
  JVM_OPTS="-Xmx3200m";
  JAVA_HOME=openjdk8;
  ANDROID_HOME="${androidenv.ourSDK}/libexec";
  ANDROID_NDK_HOME="${androidenv.androidndk_10e}/libexec/android-ndk-r10e";
  nativeBuildInputs = [
    androidenv.ourSDK
    nodejs-8_x
    openjdk8
  ];
}
