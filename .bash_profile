# builds a monogame project into a zipped executable
# usage: monobuild <windows | linux | mac>
function monobuild() {
  if [ -z $1 ]
  then
    echo "please enter a build platform"
    echo "monobuild <windows | linux | mac>"
  else
    local project=${PWD##*/}  # get project name from current folder
    # windows build
    if [ $1 == "windows" ]
    then
      dotnet publish -c Release -r win-x64 /p:PublishReadyToRun=false /p:TieredCompilation=false --self-contained
      cd $project/bin/Release/netcoreapp3.1/win-x64
      mv publish ${project}
      zip -r ../${project}Windows.zip ${project}
      mv ${project} publish
      open ..
      cd ../../../../..
    # linux build
    elif [ $1 == "linux" ]
    then
      dotnet publish -c Release -r linux-x64 /p:PublishReadyToRun=false /p:TieredCompilation=false --self-contained
      cd $project/bin/Release/netcoreapp3.1/linux-x64
      mv $project ${project}Runnable
      mv publish $project
      zip -r ../${project}Linux.zip $project
      mv $project publish
      mv ${project}Runnable $project
      open ..
      cd ../../../../..
    # mac build
    elif [ $1 == "mac" ]
    then
      dotnet publish -c Release -r osx-x64 /p:PublishReadyToRun=false /p:TieredCompilation=false --self-contained
      cd $project/bin/Release/netcoreapp3.1/osx-x64
      mkdir -p $project.app/Contents
      cp -a publish $project.app/Contents
      cd $project.app/Contents
      mv publish MacOS
      touch Info.plist
      echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> Info.plist
      echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> Info.plist
      echo "<plist version=\"1.0\">" >> Info.plist
      echo "<dict>" >> Info.plist
      echo "    <key>CFBundleDevelopmentRegion</key>" >> Info.plist
      echo "    <string>en</string>" >> Info.plist
      echo "    <key>CFBundleExecutable</key>" >> Info.plist
      echo "    <string>$project</string>" >> Info.plist
      echo "    <key>CFBundleIconFile</key>" >> Info.plist
      echo "    <string>$project</string>" >> Info.plist
      echo "    <key>CFBundleIdentifier</key>" >> Info.plist
      echo "    <string>com.DefaultCompany.$project</string>" >> Info.plist
      echo "    <key>CFBundleInfoDictionaryVersion</key>" >> Info.plist
      echo "    <string>6.0</string>" >> Info.plist
      echo "    <key>CFBundleName</key>" >> Info.plist
      echo "    <string>$project</string>" >> Info.plist
      echo "    <key>CFBundlePackageType</key>" >> Info.plist
      echo "    <string>APPL</string>" >> Info.plist
      echo "    <key>CFBundleShortVersionString</key>" >> Info.plist
      echo "    <string>1.0</string>" >> Info.plist
      echo "    <key>CFBundleSignature</key>" >> Info.plist
      echo "    <string>FONV</string>" >> Info.plist
      echo "    <key>CFBundleVersion</key>" >> Info.plist
      echo "    <string>1</string>" >> Info.plist
      echo "    <key>LSApplicationCategoryType</key>" >> Info.plist
      echo "    <string>public.app-category.games</string>" >> Info.plist
      echo "    <key>LSMinimumSystemVersion</key>" >> Info.plist
      echo "    <string>10.13</string>" >> Info.plist
      echo "    <key>NSHumanReadableCopyright</key>" >> Info.plist
      echo "    <string>Copyright © 2021</string>" >> Info.plist
      echo "    <key>NSPrincipalClass</key>" >> Info.plist
      echo "    <string>NSApplication</string>" >> Info.plist
      echo "</dict>" >> Info.plist
      echo "</plist>" >> Info.plist
      cd ../..
      zip -r ../${project}Mac.zip $project.app
      open ..
      cd ../../../../..
    else
      echo "invalid build platform"
      echo "monobuild <windows | linux | mac>"
    fi
  fi
}
