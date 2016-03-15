#!/sbin/sh

#    This file contains parts from the scripts taken from the TK GApps Project by TKruzze and osmOsis.
#
#    The TK GApps scripts are free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    These scripts are distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

file_getprop() { grep "^$2" "$1" | cut -d= -f2; }

rom_build_prop=/system/build.prop

device_architecture="$(file_getprop $rom_build_prop "ro.product.cpu.abilist=")"

# If the recommended field is empty, fall back to the deprecated one
if [ -z "$device_architecture" ]; then
  device_architecture="$(file_getprop $rom_build_prop "ro.product.cpu.abi=")"
fi

# Functions
set_metadata_recursive() {
  dir="$1";
  shift;
  until [ ! "$2" ]; do
    case $1 in
      uid) chown -R $2 $dir;;
      gid) chown -R :$2 $dir;;
      dmode) find "$dir" -type d -exec chmod $2 {} +;;
      fmode) find "$dir" -type f -exec chmod $2 {} +;;
      capabilities) ;;
      selabel)
        for i in /system/bin/toybox /system/toolbox /system/bin/toolbox; do
          find "$dir" -exec LD_LIBRARY_PATH=/system/lib $i chcon -h $2 {} +;
          find "$dir" -exec LD_LIBRARY_PATH=/system/lib $i chcon $2 {} +;
        done;
        find "$dir" -exec chcon -h $2 '{}' +;
        find "$dir" -exec chcon $2 '{}' +;
      ;;
      *) ;;
    esac;
    shift 2;
  done;
}

# Change pittpatt folders to root:shell per Google Factory Settings
if (echo "$device_architecture" | grep -i "armeabi" | grep -qiv "arm64"); then
find "/system/vendor/pittpatt" -type d -exec chown 0.2000 '{}' \;
fi

# Set metadata
set_metadata_recursive "/system/addon.d" "/system/app" "/system/etc/permissions" "/system/etc/preferred-apps" "/system/etc/sysconfig" "system/etc/updatecmds" "/system/framework" "/system/lib" "/system/lib64" "/system/priv-app" "/system/usr/srec";

# Set system/vendor metadata
if (echo "$device_architecture" | grep -i "armeabi" | grep -qiv "arm64"); then
set_metadata_recursive "/system/vendor/pittpatt";
fi
