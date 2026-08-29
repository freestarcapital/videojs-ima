#!/usr/bin/env bash

BUCKET_NAME="a.pub.network/core/videojs-ima"
PRODUCTION_BRANCH="main"
FILE_NAME="videojs.ima.min.js"
CSS_FILE_NAME="videojs.ima.css"

echo "Building videojs-ima..."

npm run rollup:min

echo "Build complete."

# Get the current branch
branch=$(git rev-parse --abbrev-ref HEAD)
# Get the version from package.json
version=$(node -p "require('./package.json').version")

if [ "$branch" != "$PRODUCTION_BRANCH" ]; then
  echo "Not on production branch. Using branch name as version."
  version="$version-$branch"
fi

echo "Version: $version"

full_path="gs://$BUCKET_NAME/$version"

file_exists=$(gsutil ls $full_path/$FILE_NAME)

if [ ! -z "$file_exists" ]; then
    echo "Files already exist. Do you want to overwrite them?"
    read -r -p "[Y/N] (Default N): " response
    response=${response:-N}

    if [ "$response" = "Y" ] || [ "$response" = "y" ]; then
        echo "Overwriting the files..."
    else
        echo "Aborting upload."
        exit 0
    fi
fi

echo "Uploading files to $full_path..."
gsutil cp dist/$FILE_NAME dist/$CSS_FILE_NAME $full_path

echo "Setting ACL..."
gsutil acl ch -r -u AllUsers:R $full_path

echo "Done."