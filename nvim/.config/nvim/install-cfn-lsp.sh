#!/bin/bash
# Installs the AWS CloudFormation language server standalone bundle into
# ~/.local/share/cfn-lsp. Re-run any time to pick up a newer release.
set -euo pipefail

REPO="aws-cloudformation/cloudformation-languageserver"
INSTALL_DIR="$HOME/.local/share/cfn-lsp"

case "$(uname -s)" in
  Linux) os=linux ;;
  Darwin) os=darwin ;;
  *) echo "unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

case "$(uname -m)" in
  x86_64|amd64) arch=x64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) echo "unsupported arch: $(uname -m)" >&2; exit 1 ;;
esac

asset_url=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -oE '"browser_download_url": *"[^"]+"' \
  | cut -d'"' -f4 \
  | grep -E -- "-${os}-${arch}-node[0-9]+\.zip$" \
  | head -1)

if [ -z "$asset_url" ]; then
  echo "could not find a release asset for ${os}-${arch}" >&2
  exit 1
fi

echo "Downloading $asset_url"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -sL -o "$tmp/cfn-lsp.zip" "$asset_url"

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -q "$tmp/cfn-lsp.zip" -d "$INSTALL_DIR"

echo "Installed to $INSTALL_DIR"
