#!/sbin/sh

# Functions & variables
tmp_path=/tmp/dynamic

arch=$(cat /system/build.prop | grep -m 1 "ro.product.cpu.abi=")

build_char=$(cat /system/build.prop | grep -m 1 "ro.build.characteristics=")

# FaceLock
if (echo "$arch" | grep -qi "armeabi"); then
  cp -rf $tmp_path/FaceLock/arm/* /system
  cp -rf $tmp_path/FaceLock/vendor/* /system/vendor
elif (echo "$arch" | grep -qi "arm64"); then
  cp -rf $tmp_path/FaceLock/arm64/* /system
fi

# GoogleCamera
if (echo "$arch" | grep -qi "armeabi"); then
  cp -rf $tmp_path/GoogleCamera/arm/* /system
elif (echo "$arch" | grep -qi "arm64"); then
  cp -rf $tmp_path/GoogleCamera/arm64/* /system
fi

# Hangouts
if (echo "$arch" | grep -qi "armeabi"); then
  cp -rf $tmp_path/Hangouts/arm/* /system
elif (echo "$arch" | grep -qi "arm64"); then
  cp -rf $tmp_path/Hangouts/arm64/* /system
fi

# Libs
if (echo "$arch" | grep -qi "armeabi"); then
  cp -rf $tmp_path/Libs/lib/* /system/lib
elif (echo "$arch" | grep -qi "arm64"); then
  cp -rf $tmp_path/Libs/lib64/* /system/lib64
fi

# PrebuiltBugle
if (echo "$build_char" | grep -qiv "tablet"); then
  if (echo "$arch" | grep -qi "armeabi"); then
    cp -rf $tmp_path/PrebuiltBugle/arm/* /system
  elif (echo "$arch" | grep -qi "arm64"); then
    cp -rf $tmp_path/PrebuiltBugle/arm64/* /system
  fi
fi

# PrebuiltGmsCore
if (echo "$arch" | grep -qi "armeabi"); then
  cp -rf $tmp_path/PrebuiltGmsCore/arm/* /system
elif (echo "$arch" | grep -qi "arm64"); then
  cp -rf $tmp_path/PrebuiltGmsCore/arm64/* /system
fi

# SetupWizard
if (echo "$build_char" | grep -qi "tablet"); then
  cp -rf $tmp_path/SetupWizard/tablet/* /system
else
  cp -rf $tmp_path/SetupWizard/phone/* /system
fi

# Velvet
if (echo "$arch" | grep -qi "armeabi"); then
  cp -rf $tmp_path/Velvet/arm/* /system
elif (echo "$arch" | grep -qi "arm64"); then
  cp -rf $tmp_path/Velvet/arm64/* /system
fi

# Make required symbolic links
if (echo "$arch" | grep -qi "armeabi"); then
  mkdir -p /system/app/FaceLock/lib/arm
  mkdir -p /system/app/LatinIME/lib/arm
  ln -sfn /system/lib/libfacelock_jni.so /system/app/FaceLock/lib/arm/libfacelock_jni.so
  ln -sfn /system/lib/libjni_keyboarddecoder.so /system/app/LatinIME/lib/arm/libjni_keyboarddecoder.so
  ln -sfn /system/lib/libjni_latinime.so /system/app/LatinIME/lib/arm/libjni_latinime.so
  ln -sfn /system/lib/libjni_latinimegoogle.so /system/app/LatinIME/lib/arm/libjni_latinimegoogle.so
elif (echo "$arch" | grep -qi "arm64"); then
  mkdir -p /system/app/FaceLock/lib/arm64
  mkdir -p /system/app/LatinIME/lib/arm64
  ln -sfn /system/lib64/libfacelock_jni.so /system/app/FaceLock/lib/arm64/libfacelock_jni.so
  ln -sfn /system/lib64/libjni_keyboarddecoder.so /system/app/LatinIME/lib/arm64/libjni_keyboarddecoder.so
  ln -sfn /system/lib64/libjni_latinime.so /system/app/LatinIME/lib/arm64/libjni_latinime.so
  ln -sfn /system/lib64/libjni_latinimegoogle.so /system/app/LatinIME/lib/arm64/libjni_latinimegoogle.so
fi
