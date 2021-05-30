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
    else
      echo "invalid build platform"
      echo "monobuild <windows | linux | mac>"
    fi
  fi
}
