#!/bin/sh

# This script is used to download built UI assets from the "influxdata/ui"
# repository. The built UI assets are attached to a release in "influxdata/ui",
# which is linked here.
# 
# The master branch of "influxdata/influxdb" (this repository) downloads from the
# release tagged as "OSS-Master" in "influxdata/ui". That release is kept up-to-date
# with the most recent changes in "influxdata/ui". 
# 
# Feature branches of "influxdata/influxdb" (2.0, 2.1, etc) download from their
# respective releases in "influxdata/ui" (OSS-2.0, OSS-2.1, etc). Those releases
# are updated only when a bug fix needs included for the UI of that OSS release.

set -e

# Download the SHA256 checksum attached to the release. To verify the integrity
# of the download, this checksum will be used to check the download tar file
# containing the built UI assets.
curl -Ls https://github.com/influxdata/ui/releases/download/OSS-Master/sha256.txt --output sha256.txt

# Download the tar file containing the built UI assets.
curl -L https://github.com/influxdata/ui/releases/download/OSS-Master/build.tar.gz --output build.tar.gz

# Verify the checksums match; exit if they don't.
echo "$(cat sha256.txt)" | sha256sum --check -- \
    || { echo "Checksums did not match for downloaded UI assets!"; exit 1; }

# Extract the assets and clean up.
tar -xzf build.tar.gz -C ui
rm sha256.txt
rm build.tar.gz
