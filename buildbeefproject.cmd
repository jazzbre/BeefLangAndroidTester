@echo off

set BEEF_DIR=d:\Projects\Research\beef\Beef

echo Building ARM
%BEEF_DIR%/IDE\dist\BeefBuild -config=Debug -platform=armv7-none-linux-androideabi23 -workspace=BeefProject
echo Building ARM64
%BEEF_DIR%/IDE\dist\BeefBuild -config=Debug -platform=aarch64-none-linux-android23 -workspace=BeefProject
echo Building x86
%BEEF_DIR%/IDE\dist\BeefBuild -config=Debug -platform=i686-none-linux-android23 -workspace=BeefProject
echo Building x86_64
%BEEF_DIR%/IDE\dist\BeefBuild -config=Debug -platform=x86_64-none-linux-android23 -workspace=BeefProject

echo All done!
pause