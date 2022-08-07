# See dotbot/dotbot/messenger/color.py
RESET='\033[0m' # No Color
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
MAGENTA='\033[0;95m'

__source=$(basename ${BASH_SOURCE[1]})

log() {
    echo -e "${GREEN}[$__source] $@${RESET}"
}

log_no_change() {
    echo -e "${BLUE}[$__source] $@${RESET}"
}

error() {
    echo -e "${RED}[$__source] $@${RESET}"
}
