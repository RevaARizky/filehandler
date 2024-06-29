#!/bin/bash

# "~/Desktop/GAIA/Clients/"

is_wsl() {
    if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null; then
        return 0
    else
        return 1
    fi
}

fixedpath="/mnt/d/dev/test/Clients"
pathshortcut="/mnt/d/dev/test2"
# if find $fixedpath -name $1 -type d
# then
# mkdir "$pathshortcut"/short
rm -R $pathshortcut/short/*
for i in $(find $fixedpath -name $1); do # Not recommended, will break on whitespace
    result=$(echo "$i" | sed "s|$fixedpath||g")
    result=$(echo "$result" | sed "s|/|_|g")
    echo "$result"
    newfolder="$pathshortcut/short/$result"
    mkdir $newfolder

    osascript -e "
    set originalFolderAlias to POSIX file $i as alias
    set destinationFolderAlias to POSIX file $newfolder as alias
    tell application \"Finder\"
       make new alias to originalFolderAlias at destinationFolderAlias
    end tell
    "
done
os_type=$(uname)

if [ "$os_type" == "Darwin" ]; then
    echo "Running on macOS"
    open $pathshortcut/short
    # macOS-specific commands here

elif [ "$os_type" == "Linux" ]; then
    if is_wsl; then
        explorer.exe `wslpath -w "$pathshortcut/short"`
    else 
        cd $pathshortcut/short
    # Linux-specific commands here

else
    echo "Unknown Operating System: $os_type"
    # Other OS-specific commands here
fi
explorer.exe `wslpath -w "$pathshortcut/short"`
cd "$pathshortcut/short"
# fi


# if [[ $# -ne 2 ]]; then
#     echo "mkalias: specify 'from' and 'to' paths" >&2
#     exit 1
# fi

# from="$(realpath $1)"
# todir="$(dirname $(realpath $2))"
# toname="$(basename $(realpath $2))"
# if [[ -f "$from" ]]; then
#     type="file"
# elif [[ -d "$from" ]]; then
#     type="folder"
# else
#     echo "mkalias: invalid path or unsupported type: '$from'" >&2
#     exit 1
# fi