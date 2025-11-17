
hello() {
        # Date and time variables
        local day_name=$(date +"%A")
        local day=$(date +"%d" | sed 's/^0//')  # Remove leading zero
        local month=$(date +"%B")
        local year=$(date +"%Y")
        local date_day=$(date +"%d")
        local date_month=$(date +"%m")
        local date_year=$(date +"%Y")
        local time_hours=$(date +"%H")
        local time_minutes=$(date +"%M")
        local time_seconds=$(date +"%S")  # Fixed typo: was 'time_secondss'
        local time_nanoseconds=$(date +"0.%6N")

        # Determine suffix
        local suffix=""
        case $day in
        1|21|31) suffix="ˢᵗ" ;;  # UTF-8 small 'st'
        2|22)   suffix="ⁿᵈ" ;;  # UTF-8 small 'nd'
        3|23)   suffix="ʳᵈ" ;;  # UTF-8 small 'rd'
        *)      suffix="ᵗʰ" ;;  # UTF-8 small 'th'
        esac

        # Terminal colors
        local RESET="\033[0m"
        local CYAN="\033[1;36m"
        local PURPLE="\033[1;35m"
        local YELLOW="\033[1;33m"
        local GREEN="\033[1;32m"
        local PINK="\033[1;38;5;206m"
        local WHITE="\033[1;37m"
        local DARK_BLUE="\033[1;34m"
        local LIGHT_GREEN="\033[1;38;5;120m"
        local RED="\033[1;31m"
        local GOLDEN="\033[1;38;5;220m"  # Fixed typo: was 'GODLEN'
        local SILVER="\033[1;38;5;250m"
        local ORANGE="\033[1;38;5;208m"

        # Print formatted output
        echo -e "${CYAN}------${LIGHT_GREEN}---------${RED}--------${LIGHT_GREEN}---------${CYAN}------${RESET}"
        echo -e ""
        echo -e "           ${LIGHT_GREEN}HELLO ${PINK}S${PURPLE}H${PINK}U${PURPLE}R${PINK}U${PURPLE}K${PINK}N${WHITE},${RESET}"
        echo -e ""
        echo -e "       ${LIGHT_GREEN}TODAY${WHITE}, ${CYAN}WE ARE ${LIGHT_GREEN}${day_name}${WHITE},${RESET}"
        echo -e "   ${CYAN}THE ${GREEN}${day}${RED}${suffix} ${CYAN}OF ${GREEN}${month^^}${WHITE}, ${GOLDEN}${date_day}${SILVER}/${GOLDEN}${date_month}${SILVER}/${GOLDEN}${date_year}${WHITE}.${RESET}"
        echo -e ""
        echo -e "       ${CYAN}From ${GOLDEN}now ${RED}ON${WHITE}, ${GOLDEN}it${WHITE}'${GOLDEN}s ${CYAN}been${WHITE};${RESET}"
        echo -e "        ${GREEN}${time_hours}${RED}Hours ${CYAN}and ${GREEN}${time_minutes}${RED}Minutes${WHITE},${RESET}"
        echo -e "${CYAN}some ${GREEN}${time_seconds}${RED}Seconds ${CYAN}and some ${GREEN}${time_nanoseconds}${RED}Nanoseconds${WHITE},${RESET}"
        echo -e " ${YELLOW}THAT THIS ${PINK}BEAUTIFUL ${LIGHT_GREEN}DAY ${PINK}STARTED ${YELLOW}SHINNING${WHITE}.${RESET}"
        echo -e "         ${PURPLE}SO ${RED}DON'T MESS ${PURPLE}UP${WHITE}.${RESET}"
        echo -e ""
        echo -e "       ${PURPLE}IT ${LIGHT_GREEN}MIGHT ${RED}NOT ${LIGHT_GREEN}BE ${PURPLE}RAINY${WHITE},${RESET}"
        echo -e "     ${PURPLE}BUT ${PINK}U ${RED}NO ${PINK}I ${LIGHT_GREEN}BETTER ${PURPLE}STAY ${RED}IN${WHITE}.${RESET}"
        echo -e ""
        echo -e "${CYAN}------${LIGHT_GREEN}---------${RED}--------${LIGHT_GREEN}---------${CYAN}------${RESET}"
}
