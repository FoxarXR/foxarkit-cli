#!/bin/bash

# Foxar CLI Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/FoxarXR/foxarkit-cli/main/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="/usr/local/bin"
BINARY_NAME="foxar"
REPO="FoxarXR/foxarkit-cli"

echo -e "${BLUE}🦊 Installing Foxar CLI...${NC}"

# Check macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: Foxar CLI currently only supports macOS${NC}"
    exit 1
fi

# Check architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    echo -e "${RED}Error: Foxar CLI currently only supports Apple Silicon (arm64)${NC}"
    exit 1
fi

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download binary
echo "Downloading latest version..."
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/bin/foxar" -o "$TMP_DIR/foxar"
chmod +x "$TMP_DIR/foxar"

# Install
echo "Installing to $INSTALL_DIR..."
if [[ -w "$INSTALL_DIR" ]]; then
    mv "$TMP_DIR/foxar" "$INSTALL_DIR/$BINARY_NAME"
else
    sudo mv "$TMP_DIR/foxar" "$INSTALL_DIR/$BINARY_NAME"
fi

# Verify
if command -v foxar &> /dev/null; then
    VERSION=$(foxar --version 2>/dev/null || echo "installed")
    echo -e "${GREEN}✅ Foxar CLI installed successfully!${NC}"
    echo -e "   Version: $VERSION"
    echo ""
    echo "Run 'foxar --help' to get started."
else
    echo -e "${RED}Installation failed. Please try again or install manually.${NC}"
    exit 1
fi
