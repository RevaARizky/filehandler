#!/bin/bash

is_wsl() {
    if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null; then
        return 0
    else
        return 1
    fi
}

get_os() {
    os_type=$(uname)

    if [ "$os_type" == "Darwin" ]; then
        echo "mac"

    elif [ "$os_type" == "Linux" ]; then
        if is_wsl; then
            echo "wsl"
        else 
            echo "linux"
        fi
    else
        echo $os_type
    fi
}

fixedpath="~/Desktop/GAIA/Clients"
pathshortcut="~/Desktop/GAIA/Clients/temps"
# rm -R $pathshortcut/short/*
for i in $(find $fixedpath -name $1); do # Not recommended, will break on whitespace
    result=$(echo "$i" | sed "s|$fixedpath||g")
    result=$(echo "$result" | sed "s|/|_|g")
    newfolder="$pathshortcut/short/$result"
    mkdir $newfolder

    if [ "$(get_os)" = "mac" ]; then
        osascript -e "
        set originalFolderAlias to POSIX file $i as alias
        set destinationFolderAlias to POSIX file $newfolder as alias
        tell application \"Finder\"
            make new alias to originalFolderAlias at destinationFolderAlias
        end tell
        "
    elif ["$(get_os)" = "wsl"]; then
        ln -s $i $newfolder
    fi
done

if [ "$(get_os)" = "mac" ]; then
    open $pathshortcut/short

elif [ "$(get_os)" = "linux" ]; then
    cd $pathshortcut/short

elif [ "$(get_os)" = "wsl" ]; then
    explorer.exe `wslpath -w "$pathshortcut/short"`
fi