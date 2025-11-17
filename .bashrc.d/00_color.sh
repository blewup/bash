# ~/.bashrc.d/00_color_fast.sh (Optimized Version)

# --- Initial Color Check (No changes) ---
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

if [ "$color_prompt" = yes ]; then

    # --- 1. PS1-Wrapped Colors ---
    # ALL colors used for PS1 are wrapped in \[...\]
    fluo_green='\[\033[1;92m\]'
    fluo_purple='\[\033[1;38;5;165m\]'
    light_blue='\[\033[1;38;5;45m\]'
    white='\[\033[1;97m\]'
    red='\[\033[1;38;5;203m\]'
    light_green='\[\033[1;38;5;82m\]'
    reset='\[\033[0m\]'

    # Path-specific colors (now wrapped)
    yellow='\[\033[1;38;5;227m\]'
    purple='\[\033[1;38;5;129m\]'
    
    # VENV Colors (Corrected and Wrapped)
    GOLDEN='\[\033[1;38;5;220m\]'
    SILVER='\[\033[1;38;5;255m\]'
    CYAN='\[\033[1;38;5;51m\]'
    
    # Fill in missing/assumed colors from your logic
    GREEN="${light_green}"
    BLUE="${light_blue}"
    PURPLE="${fluo_purple}"

    # --- 2. Global Variables for Prompt ---
    # We will update these variables in functions instead of using slow subshells
    __PS1_PATH=""
    __PS1_VENV=""

    # --- 3. Optimized Path Function ---
    # This function NO LONGER prints. It sets the global __PS1_PATH variable.
    _update_prompt_path() {
        # 1. Abbreviate $HOME to ~ (fast parameter expansion)
        local path_abbr="${PWD/#$HOME/~}"

        # 2. Handle simple cases (Home and Root)
        if [ "$path_abbr" = "/" ]; then
            __PS1_PATH="${yellow}/${reset}"
            return
        elif [ "$path_abbr" = "~" ]; then
            if [ "$EUID" -eq 0 ]; then
                __PS1_PATH="${red}~${reset}" # Root home
            else
                __PS1_PATH="${purple}~${reset}" # User home
            fi
            return
        fi

        # 3. Handle all other paths using fast parameter substitution
        # Replace EVERY '/' with yellow '/' followed by fluo_purple
        local final_path="${path_abbr//\//${yellow}\/${fluo_purple}}"

        # Prepend the path with fluo_purple (to color the first segment)
        __PS1_PATH="${fluo_purple}${final_path}${reset}"
    }

    # --- 4. Optimized VENV Function ---
    # This function NO LONGER prints. It sets the global __PS1_VENV variable.
    _update_prompt_venv() {
        if [ -n "$VIRTUAL_ENV" ]; then
            # Use fast parameter expansion instead of external `basename`
            __PS1_VENV="${GOLDEN}PY:${VIRTUAL_ENV##*/}${reset}"
        elif [ -n "$NVM_DIR" ] && [ -n "$NODE_VERSION" ]; then
            __PS1_VENV="${GREEN}NODE:$NODE_VERSION${reset}"
        elif [ -n "$NODE_ENV" ]; then
            __PS1_VENV="${BLUE}NODE:$NODE_ENV${reset}"
        elif [ -n "$CONDA_DEFAULT_ENV" ]; then
            __PS1_VENV="${PURPLE}CONDA:$CONDA_DEFAULT_ENV${reset}"
        elif [ -n "$CL_VIRTUAL_ENV" ]; then
            # Use fast parameter expansion instead of external `basename`
            __PS1_VENV="${GOLDEN}${CL_VIRTUAL_ENV##*/}${reset}"
        else
            __PS1_VENV="${white}NO VENV${reset}" # Give 'NO VENV' a color
        fi
    }


    # --- 5. Main Prompt Builder ---
    build_prompt() {
        # 1. Update the global variables. These are fast.
        _update_prompt_path
        _update_prompt_venv

        # 2. Build the PS1 string using the variables (NO subshells)
        if [[ $EUID -eq 0 ]]; then
            # Root user prompt
            case "$PROMPT_ALTERNATIVE" in
                twoline)
                    PS1="${red}┏━━[${fluo_purple}\u${white}㉿${light_blue}\h${red}━━[${__PS1_PATH}${red}]━━┛\n${red}┗━━[${__PS1_VENV}${red}]━━►${GOLDEN} " ;;
                oneline|backtrack)
                    PS1="${red}┗━━${__PS1_VENV}${red}━━(${fluo_purple}\u${white}㉿${light_blue}\h${red})━━[${__PS1_PATH}${red}]━━►${GOLDEN} " ;;
            esac
        else
            # Regular user prompt
            case "$PROMPT_ALTERNATIVE" in
                twoline)
                    PS1="${fluo_green}┌──[${light_green}\u${white}㉿${light_blue}\h${fluo_green}─[${__PS1_PATH}${fluo_green}]─┘\n${fluo_green}└─[${__PS1_VENV}${fluo_green}]──►${CYAN} " ;;
                oneline|backtrack)
                    PS1="${fluo_green}└──[${__PS1_VENV}${fluo_green}]──(${fluo_purple}\u${white}㉿${light_blue}\h${fluo_green})-([${__PS1_PATH}${fluo_green}]──►${CYAN} " ;;
            esac
        fi

        # 3. Add the final reset (as in your original script)
        PS1+="${reset}"
    }

    # Set the PROMPT_COMMAND to run the main builder function
    PROMPT_COMMAND='build_prompt'

fi