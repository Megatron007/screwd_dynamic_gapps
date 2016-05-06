#!/bin/bash

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

# Pretty ascii art
echo ".+-+.+-+.+-+.+-+.+-+.+-+.+-+.+-+.+-+";
echo ".|P|.|u|.|r|.|e|.|N|.|e|.|x|.|u|.|s|";
echo ".+-+.+-+.+-+.+-+.+-+.+-+.+-+.+-+.+-+";
echo ".|D|.|y|.|n|.|a|.|m|.|i|.|c|........";
echo ".+-+.+-+.+-+.+-+.+-+.+-+.+-+........";
echo ".|G|.|A|.|p|.|p|.|s|................";
echo ".+-+.+-+.+-+.+-+.+-+................";

# Define paths && variables
APPDIRS="dynamic/FaceLock/arm/app/FaceLock
         dynamic/GoogleCamera/arm/app/GoogleCamera
         dynamic/GoogleCamera/arm64/app/GoogleCamera
         dynamic/Hangouts/arm/app/Hangouts
         dynamic/Hangouts/arm64/app/Hangouts
         dynamic/Photos/arm/app/Photos
         dynamic/Photos/arm64/app/Photos
         dynamic/PrebuiltBugle/arm/app/PrebuiltBugle
         dynamic/PrebuiltBugle/arm64/app/PrebuiltBugle
         dynamic/PrebuiltGmsCore/arm/priv-app/PrebuiltGmsCore
         dynamic/PrebuiltGmsCore/arm64/priv-app/PrebuiltGmsCore
         dynamic/SetupWizard/phone/priv-app/SetupWizard
         dynamic/SetupWizard/tablet/priv-app/SetupWizard
         dynamic/Velvet/arm/priv-app/Velvet
         dynamic/Velvet/arm64/priv-app/Velvet
         system/app/CalendarGooglePrebuilt
         system/app/Chrome
         system/app/ChromeBookmarksSyncAdapter
         system/app/GoogleContactsSyncAdapter
         system/app/GoogleTTS
         system/app/PrebuiltDeskClockGoogle
         system/app/talkback
         system/priv-app/GoogleBackupTransport
         system/priv-app/GoogleFeedback
         system/priv-app/GoogleLoginService
         system/priv-app/GoogleOneTimeInitializer
         system/priv-app/GooglePartnerSetup
         system/priv-app/GoogleServicesFramework
         system/priv-app/HotwordEnrollment
         system/priv-app/Phonesky"
TOOLSDIR=$(realpath .)/tools
GAPPSDIR=$(realpath .)/files
FINALDIR=$(realpath .)/out
ZIPNAMETITLE=PureNexus_Dynamic_GApps
ZIPNAMEVERSION=6.x.x
ZIPNAMEDATE=$(date +%-m-%-e-%-y)
ZIPNAME="$ZIPNAMETITLE"_"$ZIPNAMEVERSION"_"$ZIPNAMEDATE".zip

dcapk() {
TARGETDIR=$(realpath .)
TARGETAPK=$TARGETDIR/$(basename "$TARGETDIR").apk
  unzip -q -o "$TARGETAPK" -d "$TARGETDIR" "lib/*"
  zip -q -d "$TARGETAPK" "lib/*"
  cd "$TARGETDIR"
  zip -q -r -D -Z store -b "$TARGETDIR" "$TARGETAPK" "lib/"
  rm -rf "${TARGETDIR:?}"/lib/
  mv -f "$TARGETAPK" "$TARGETAPK".orig
  zipalign -f -p 4 "$TARGETAPK".orig "$TARGETAPK"
  rm -rf "$TARGETAPK".orig
}

# Define beginning time
BEGIN=$(date +%s)

# Begin the magic
export PATH=$TOOLSDIR:$PATH

for dirs in $APPDIRS; do
  cd "$GAPPSDIR/${dirs}";
  dcapk 1> /dev/null 2>&1;
done

cd "$GAPPSDIR"
7za a -tzip -r "$ZIPNAME" ./* 1> /dev/null 2>&1
mv -f "$ZIPNAME" "$TOOLSDIR"
cd "$TOOLSDIR"
java -Xmx2048m -jar signapk.jar -w testkey.x509.pem testkey.pk8 "$ZIPNAME" "$ZIPNAME".signed
rm -f "$ZIPNAME"
zipadjust "$ZIPNAME".signed "$ZIPNAME".fixed 1> /dev/null 2>&1
rm -f "$ZIPNAME".signed
java -Xmx2048m -jar minsignapk.jar testkey.x509.pem testkey.pk8 "$ZIPNAME".fixed "$ZIPNAME"
rm -f "$ZIPNAME".fixed
mv -f "$ZIPNAME" "$FINALDIR"

# Define ending time
END=$(date +%s)

# All done
echo " "
echo "All done creating GApps!"
echo "Total time elapsed: $(echo $(($END-$BEGIN)) | awk '{print int($1/60)"mins "int($1%60)"secs "}') ($(echo "$END - $BEGIN" | bc) seconds)"
echo "Completed GApps zip located in the '$FINALDIR' directory"
cd
