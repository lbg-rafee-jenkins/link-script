link() {
folderToCreateLocalPackage=""
folderToInstallLocalPackage=$(basename "$PWD")
isDevDependency=false
while getopts ":D" opt; do
          case $opt in
            D)
              isDevDependency=true
              ;;
          esac
        done
if [ "$isDevDependency" = true ] ;
then
    folderToCreateLocalPackage="$2"
else
    folderToCreateLocalPackage="$1"
fi
if [ "$folderToCreateLocalPackage" = "" ] ;
then
    echo "Missing folder name to create local package"
    return 1
fi
rm -rf *.tgz 2>/dev/null
cd ../"$folderToCreateLocalPackage"
package=$(node -p "require('./package.json').name")
if [ "$package" = "" ] ;
then
    echo "Hmm... this doesn't look like a npm project. Check if you have a package.json in the root and try again"
    return 1
fi
npm pack
pathToParentRepo="../"
pathToInstallLocalPackage=$pathToParentRepo$folderToInstallLocalPackage
mv *.tgz ${pathToInstallLocalPackage}
cd "$pathToInstallLocalPackage"
if [ "$isDevDependency" = true ] ;
then
    npm uninstall "$package" && npm i -D *.tgz
else
    npm uninstall "$package" && npm i -S *.tgz
fi
}
