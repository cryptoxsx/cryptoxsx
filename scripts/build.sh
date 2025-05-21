#!/usr/bin/env bash
set -euo pipefail

# Prerequisite: the 'zip' utility must be installed.

export ARTIFACT_NAME="yazi-$1"
export YAZI_GEN_COMPLETIONS=1

# Build for the target
git config --global --add safe.directory "*"
cargo build --release --locked --target "$1"

# Create the artifact
mkdir -p "$ARTIFACT_NAME/completions"
cp "target/$1/release/ya" "$ARTIFACT_NAME"
cp "target/$1/release/yazi" "$ARTIFACT_NAME"
cp yazi-cli/completions/* "$ARTIFACT_NAME/completions"
cp yazi-boot/completions/* "$ARTIFACT_NAME/completions"
cp README.md LICENSE "$ARTIFACT_NAME"

# Zip the artifact
# NOTE: The 'zip' command must be available. If it's missing, hint how to
# install it using the detected package manager and exit with an error.
if ! command -v zip >/dev/null 2>&1; then
    echo "Error: 'zip' is required to create release archives." >&2
    if command -v apt-get >/dev/null 2>&1; then
        echo "Install it using: sudo apt-get install zip" >&2
    elif command -v dnf >/dev/null 2>&1; then
        echo "Install it using: sudo dnf install zip" >&2
    elif command -v yum >/dev/null 2>&1; then
        echo "Install it using: sudo yum install zip" >&2
    elif command -v pacman >/dev/null 2>&1; then
        echo "Install it using: sudo pacman -S zip" >&2
    elif command -v brew >/dev/null 2>&1; then
        echo "Install it using: brew install zip" >&2
    elif command -v zypper >/dev/null 2>&1; then
        echo "Install it using: sudo zypper install zip" >&2
    else
        echo "Please install the 'zip' package using your system's package manager." >&2
    fi
    exit 1
fi
zip -r "$ARTIFACT_NAME.zip" "$ARTIFACT_NAME"
