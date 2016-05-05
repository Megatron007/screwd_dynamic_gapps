#!/sbin/sh

# This file contains parts from the scripts taken from the Open GApps Project by mfonville.
#
# The Open GApps scripts are free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# These scripts are distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# Functions & variables
tmp_path=/tmp/dynamic

file_getprop() { grep "^$2" "$1" | cut -d= -f2; }

rom_build_prop=/system/build.prop

arch=$(file_getprop $rom_build_prop "ro.product.cpu.abi=")

build_char=$(file_getprop $rom_build_prop "ro.build.characteristics")

# FaceLock
if (echo "$arch" | grep -qi "armeabi"); then
  cp -rf $tmp_path/FaceLock/arm/* /system
  cp -rf $tmp_path/FaceLock/vendor/* /system/vendor
elif (echo "$arch" | grep -qi "arm64"); then
  cp -rf $tmp_path/FaceLock/arm/* /system
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
  ln -sfn /system/lib/libjni_latinime.so /system/app/LatinIME/lib/arm/libjni_latinime.so
  ln -sfn /system/lib/libjni_latinimegoogle.so /system/app/LatinIME/lib/arm/libjni_latinimegoogle.so
elif (echo "$arch" | grep -qi "arm64"); then
  mkdir -p /system/app/FaceLock/lib/arm64
  mkdir -p /system/app/LatinIME/lib/arm64
  ln -sfn /system/lib64/libfacelock_jni.so /system/app/FaceLock/lib/arm64/libfacelock_jni.so
  ln -sfn /system/lib64/libjni_latinime.so /system/app/LatinIME/lib/arm64/libjni_latinime.so
  ln -sfn /system/lib64/libjni_latinimegoogle.so /system/app/LatinIME/lib/arm64/libjni_latinimegoogle.so
fi
