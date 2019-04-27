#!/bin/bash

# Where you want to 'install' Zilf
destination=~/Documents

# Install dependencies (mono for running .NET and frotz as a z-machine interpreter)
if [[ $(command -v brew) == "" ]]; then
    echo "To automatically install dependencies, you will need to install Homebrew: https://brew.sh/"
    read -p "Install it now? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        exit 1
    fi
fi

echo "Installing dependencies..."
brew install mono frotz

# Download and unzip Zilf
echo "Downloading Zilf..."
cd "$destination"
version=$(curl -s "https://api.bitbucket.org/2.0/repositories/jmcgrew/zilf/downloads" | /usr/bin/python -c 'import json,sys;obj=json.load(sys.stdin);print(obj["values"][0]["name"]);print(obj["values"][0]["links"]["self"]["href"])')
set -f && set -- $version && set +f

# Make sure we aren't going to clobber anything
dirname="${1%.*}"
if [ -d "$dirname" ]; then
    echo "${dirname} already exists. You'll have to remove it manually."
    exit 1
fi

# Download for real
curl -s -O -L "$2" || exit 1
unzip -qq "$1" || exit 1
rm "$1"

# Create mono wrappers
cd "${dirname}/bin"
echo "mono ${destination}/${dirname}/bin/zilf.exe \"\$@\"" > zilf
echo "mono ${destination}/${dirname}/bin/zapf.exe \"\$@\"" > zapf
chmod u+x zilf zapf

# Copy to /usr/local/bin so we can use zilf and zapf anywhere
if [ -f /usr/local/bin/zilf ]; then
rm /usr/local/bin/zilf && rm /usr/local/bin/zapf
fi
ln -s "${destination}/${dirname}/bin/zilf" /usr/local/bin/zilf
ln -s "${destination}/${dirname}/bin/zapf" /usr/local/bin/zapf

echo "Done! ${dirname} is ready to go."
