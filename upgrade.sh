#!/bin/sh

VERSION_FILE='./version.json'
VERSION_KEY='version'

version=`jq ".$VERSION_KEY" $VERSION_FILE | tr -d '"'`

CURRENT_VERSION=( ${version//./ } )
UPDATE_VERSION=( ${version//./ } )

while getopts ":Mmp" Option
do
  case $Option in
    M ) major=true;;
    m ) minor=true;;
    p ) patch=true;;
  esac
done

shift $(($OPTIND - 1))


if [ ! -z $major ]
then
  ((UPDATE_VERSION[0]++))
  UPDATE_VERSION[1]=0
  UPDATE_VERSION[2]=0
elif [ ! -z $minor ]
then
  ((UPDATE_VERSION[1]++))
  UPDATE_VERSION[2]=0
elif [ ! -z $patch ]
then
  ((UPDATE_VERSION[2]++))
else
  echo "usage: $(basename $0) [-Mmp]"
  exit 1
fi

CUR_VERSION="${CURRENT_VERSION[0]}.${CURRENT_VERSION[1]}.${CURRENT_VERSION[2]}"
NEW_VERSION="${UPDATE_VERSION[0]}.${UPDATE_VERSION[1]}.${UPDATE_VERSION[2]}"

echo "updating $CUR_VERSION to $NEW_VERSION in $VERSION_FILE"
tmpFile=$(mktemp)

jq ".$VERSION_KEY=\"$NEW_VERSION\"" $VERSION_FILE > "$tmpFile"
mv "$tmpFile" "$VERSION_FILE"
