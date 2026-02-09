#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

INSTALL_DIR="$HOME/.dev-env"
REPO_URL="https://github.com/IFAKA/dev-env.git"

echo "Installing dev-env..."
echo ""

# Parse arguments
WITH_VIMZAP=false
for arg in "$@"; do
  if [[ "$arg" == "--with-vimzap" ]]; then
    WITH_VIMZAP=true
  fi
done

# Clone or update the repo
if [[ -d "$INSTALL_DIR/.git" ]]; then
  echo -e "${YELLOW}Updating existing installation...${NC}"
  cd "$INSTALL_DIR"
  git pull origin main
else
  echo -e "${GREEN}Cloning dev-env repository...${NC}"
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

echo ""

# Run the setup script
cd "$INSTALL_DIR"
if $WITH_VIMZAP; then
  ./setup.sh install --with-vimzap
else
  ./setup.sh install
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "To check status:   cd $INSTALL_DIR && ./setup.sh status"
echo "To uninstall:      cd $INSTALL_DIR && ./setup.sh uninstall"
