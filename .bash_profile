# builds a monogame project into a zipped executable
# usage: monobuild <windows | linux | mac> [--nozip]
function monobuild() {
  # if no platform given
  if [ -z $1 ]
  then
    echo "please enter a build platform"
    echo "monobuild <windows | linux | mac> [--nozip]"
  else
    local project=${PWD##*/}  # get project name from current folder
    # windows build
    if [ $1 == "windows" ]
    then
      dotnet publish -c Release -r win-x64 /p:PublishReadyToRun=false /p:TieredCompilation=false --self-contained # publish as self-contained windows build
      # if not zipping
      if [ ! -z $2 ] && [ $2 == "--nozip" ]
      then
        open $project/bin/Release/netcoreapp3.1 # open builds folder
      # if zipping
      else
        cd $project/bin/Release/netcoreapp3.1/win-x64 # cd into windows build
        mv publish ${project} # rename publish folder to project name
        zip -r ../${project}Windows.zip ${project} # zip publish folder
        mv ${project} publish # restore publish folder name
        open .. # open builds folder
        cd ../../../../.. # return to home folder
      fi
    # linux build
    elif [ $1 == "linux" ]
    then
      dotnet publish -c Release -r linux-x64 /p:PublishReadyToRun=false /p:TieredCompilation=false --self-contained # publish as self-contained linux build
      # if not zipping
      if [ ! -z $2 ] && [ $2 == "--nozip" ]
      then
        open $project/bin/Release/netcoreapp3.1 # open builds folder
      # if zipping
      else
        cd $project/bin/Release/netcoreapp3.1/linux-x64 # cd into linux build
        mv $project ${project}Executable # rename executable to avoid naming conflicts
        mv publish $project # rename publish folder to project name
        zip -r ../${project}Linux.zip $project # zip publish folder
        mv $project publish # restore publish folder name
        mv ${project}Executable $project # restore executable name
        open .. # open builds folder
        cd ../../../../.. # return to home folder
      fi
    # mac build
    elif [ $1 == "mac" ]
    then
      dotnet publish -c Release -r osx-x64 /p:PublishReadyToRun=false /p:TieredCompilation=false --self-contained # publish as self-contained mac build
      # if not zipping
      if [ ! -z $2 ] && [ $2 == "--nozip" ]
      then
        open $project/bin/Release/netcoreapp3.1 # open builds folder
      # if zipping
      else
        cd $project/bin/Release/netcoreapp3.1/osx-x64 # cd into mac build
        mkdir -p $project.app/Contents # create .app shell
        cp -a publish $project.app/Contents # move publish folder to app contents
        cd $project.app/Contents # cd into contents folder
        mv publish MacOS # rename publish folder to MacOS
        # construct Info.plist
        touch Info.plist
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> Info.plist
        echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> Info.plist
        echo "<plist version=\"1.0\">" >> Info.plist
        echo "<dict>" >> Info.plist
        echo "    <key>CFBundleDevelopmentRegion</key>" >> Info.plist
        echo "    <string>en</string>" >> Info.plist # change development region if applicable
        echo "    <key>CFBundleExecutable</key>" >> Info.plist
        echo "    <string>$project</string>" >> Info.plist
        echo "    <key>CFBundleIconFile</key>" >> Info.plist
        echo "    <string>$project</string>" >> Info.plist # replace with path to your icon file
        echo "    <key>CFBundleIdentifier</key>" >> Info.plist
        echo "    <string>com.DefaultCompany.$project</string>" >> Info.plist # replace DefaultCompany with your identifier
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
        echo "    <string>Copyright © 2021</string>" >> Info.plist # replace year if applicable
        echo "    <key>NSPrincipalClass</key>" >> Info.plist
        echo "    <string>NSApplication</string>" >> Info.plist
        echo "</dict>" >> Info.plist
        echo "</plist>" >> Info.plist
        # finish Info.plist
        cd ../.. # return to .app main directory
        zip -r ../${project}Mac.zip $project.app # zip app
        open .. # open builds folder
        cd ../../../../.. # return to home folder
      fi
    # if given platform not windows, linux, or mac
    else
      echo "invalid build platform"
      echo "monobuild <windows | linux | mac> [--nozip]"
    fi
  fi
}
