#!/bin/bash
# ================================================================================
#                     OBLITERATE EVERYTHING 3 OFFLINE EDITION
#                             LINUX INSTALLER SCRIPT
# ================================================================================
set -e

# ANSI Color Codes for premium look
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Clear terminal screen
clear

echo -e "${CYAN}====================================================================${NC}"
echo -e "${CYAN} ${BOLD}Obliterate Everything 3 (OE3) - Linux Offline Installer${NC}"
echo -e "${CYAN}====================================================================${NC}"
echo ""

# 1. Dependency Checks & Auto-installation
echo -e "${BLUE}[1/5] Checking system dependencies...${NC}"
DEPENDENCIES=("python3" "unzip" "tar" "curl")
MISSING_DEPS=()

for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "${YELLOW}Missing required packages: ${BOLD}${MISSING_DEPS[*]}${NC}"
    echo "Attempting to install missing dependencies automatically..."
    
    if command -v apt-get &> /dev/null; then
        echo -e "${GRAY}Running apt-get package manager...${NC}"
        sudo apt-get update && sudo apt-get install -y python3 unzip tar curl
    elif command -v dnf &> /dev/null; then
        echo -e "${GRAY}Running dnf package manager...${NC}"
        sudo dnf install -y python3 unzip tar curl
    elif command -v pacman &> /dev/null; then
        echo -e "${GRAY}Running pacman package manager...${NC}"
        sudo pacman -S --noconfirm python3 unzip tar curl
    else
        echo -e "${RED}Error: Unsupported package manager.${NC}"
        echo -e "Please manually install the following packages using your system tools:"
        echo -e "  ${BOLD}${MISSING_DEPS[*]}${NC}"
        exit 1
    fi
    echo -e "${GREEN}Dependencies installed successfully!${NC}\n"
else
    echo -e "${GREEN}All required system packages are already installed.${NC}\n"
fi

# 2. Setup Directory Structure
INSTALL_DIR="$HOME/OE3-Offline"
echo -e "${BLUE}[2/5] Setting up game directory...${NC}"
echo -e "Target Folder: ${CYAN}${INSTALL_DIR}${NC}"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
echo -e "${GREEN}Directory created and prepared.${NC}\n"

# 3. Download and Extract standard game release
echo -e "${BLUE}[3/5] Fetching latest game release from GitHub...${NC}"
# Attempting to fetch from GitHub Releases API
API_URL="https://api.github.com/repos/DoctorQwack/Obliterate-Everything-3-Offline/releases/latest"
RELEASE_URL=""

# Query Releases API
if command -v curl &> /dev/null; then
    RELEASE_URL=$(curl -s "$API_URL" | grep "browser_download_url" | grep -v "Legacy" | grep "zip" | cut -d '"' -f 4 || true)
fi

# Fallback URL if API limits or errors occur
if [ -z "$RELEASE_URL" ]; then
    RELEASE_URL="https://github.com/DoctorQwack/Obliterate-Everything-3-Offline/releases/latest/download/OE3_Offline_Release.zip"
fi

echo -e "Downloading release zip file..."
curl -L -o release.zip "$RELEASE_URL"

echo "Extracting assets to game directory..."
unzip -o release.zip
rm release.zip
echo -e "${GREEN}Game assets extracted successfully.${NC}\n"

# 4. Standalone Flash Player download & bundling (Linux x86_64 only)
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    echo -e "${BLUE}[4/5] Bundling native Linux Flash Player Projector...${NC}"
    FLASH_URL="https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux_debug.x86_64.tar.gz"
    
    echo "Downloading Adobe standalone projector..."
    if curl -s -f -L -o flashplayer.tar.gz "$FLASH_URL"; then
        echo "Extracting Flash binary..."
        tar -xzf flashplayer.tar.gz -C "$INSTALL_DIR" flashplayerdebugger
        mv "$INSTALL_DIR/flashplayerdebugger" "$INSTALL_DIR/flashplayer"
        chmod +x "$INSTALL_DIR/flashplayer"
        rm flashplayer.tar.gz
        echo -e "${GREEN}Native Linux Flash Player bundled successfully.${NC}\n"
    else
        echo -e "${YELLOW}Warning: Native Flash Player download timed out or was rejected.${NC}"
        echo "You can still run the game in standard Web Browser mode."
        echo ""
    fi
else
    echo -e "${YELLOW}[4/5] Skipping native Flash Player (System architecture is not x86_64).${NC}"
    echo "You will play using Ruffle WebAssembly or browser emulation mode."
    echo ""
fi

# 5. Create Desktop Launcher Integration
echo -e "${BLUE}[5/5] Creating launcher shortcuts and desktop integration...${NC}"

# Set execute permissions on game launch scripts
chmod +x "$INSTALL_DIR/launch.sh"
chmod +x "$INSTALL_DIR/server.py"

# Setup Desktop file integration
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"

cat <<EOF > "$DESKTOP_DIR/oe3-offline.desktop"
[Desktop Entry]
Name=Obliterate Everything 3
Comment=Play Obliterate Everything 3 Offline Edition
Exec=bash "$INSTALL_DIR/launch.sh"
Icon=game-controller
Terminal=true
Type=Application
Categories=Game;
EOF

chmod +x "$DESKTOP_DIR/oe3-offline.desktop"
echo -e "${GREEN}Desktop integration shortcut registered.${NC}\n"

# Final steps / Help instruction
echo -e "${GREEN}====================================================================${NC}"
echo -e "${GREEN}${BOLD}      INSTALLATION SUCCESSFUL!${NC}"
echo -e "${GREEN}====================================================================${NC}"
echo -e "  The game has been installed to: ${CYAN}${INSTALL_DIR}${NC}"
echo ""
echo -e "  ${BOLD}To start the game server & play:${NC}"
echo -e "    1. Open your Applications Menu and search for ${BOLD}Obliterate Everything 3${NC}"
echo -e "    2. Or run it directly from your terminal:"
echo -e "       ${CYAN}cd ~/OE3-Offline && ./launch.sh${NC}"
echo ""
echo -e "  ${YELLOW}GTK Libraries Dependency Warning (For Native Player Mode):${NC}"
echo -e "  If launching the native Flash Player fails with library error issues,"
echo -e "  please run the following command to install the required GTK/NSS libraries:"
echo -e "    - Debian/Ubuntu/Mint:  ${CYAN}sudo apt install -y libgtk2.0-0 libnss3 libnspr4${NC}"
echo -e "    - Arch Linux/Manjaro:  ${CYAN}sudo pacman -S --needed gtk2 nss${NC}"
echo -e "    - Fedora/RedHat:       ${CYAN}sudo dnf install -y gtk2 nss${NC}"
echo -e "${GREEN}====================================================================${NC}"
