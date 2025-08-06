# Start Hyprland with UWSM if conditions are met
if status is-login; and not set -q TMUX; and uwsm check may-start
    exec uwsm start hyprland-uwsm.desktop
end

# Start SSH Agent
if not pgrep -f ssh-agent >/dev/null
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Fix tmux compositor error in Hyprland
#if test -n "$TMUX"
#    set -e WAYLAND_DISPLAY
#end

# Create an alias in your fish config
# alias tmux='env -u WAYLAND_DISPLAY tmux'

# Add rose pine theme
fish_config theme choose "Rosé Pine"

# Add atuin plugin
atuin init fish | source

# Initialize starship
starship init fish | source

# Set environment variables
set -gx EDITOR nvim
set -gx BROWSER zen-browser
set -gx TERMINAL kitty

# Add local bin to PATH
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# Fish color theme (dark)
set -U fish_color_normal white
set -U fish_color_command 74c0fc
set -U fish_color_quote 51cf66
set -U fish_color_redirection d084ff
set -U fish_color_end ff6b6b
set -U fish_color_error ff5555
set -U fish_color_param 22d3ee
set -U fish_color_comment 6c7086
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 74c0fc
set -U fish_color_escape 22d3ee
set -U fish_color_cwd 51cf66
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 6c7086
set -U fish_color_user 51cf66
set -U fish_color_host 74c0fc

# Aliases - System
alias grep='rg'
alias find='fd'
alias ps='procs'
alias top='btop'
alias htop='btop'
alias du='dust'
alias df='duf'

# Aliases - Git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gp='git push'
alias gpu='git push -u origin HEAD'
alias gl='git pull'
alias gs='git status'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate'

# Aliases - Arch specific
alias pac='sudo pacman -S'
alias pacs='pacman -Ss'
alias pacu='sudo pacman -Syu'
alias pacr='sudo pacman -Rs'
alias yay='yay --color=always'
alias yays='yay -Ss'
alias yayu='yay -Syu'

# Aliases - System monitoring
alias temp='sensors'
alias meminfo='free -h'
alias cpuinfo='lscpu'
alias diskinfo='lsblk'
alias netinfo='ip addr show'

# Functions
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

function backup
    cp $argv[1] $argv[1].backup-(date +%Y%m%d-%H%M%S)
end

function weather
    curl -s "wttr.in/$argv[1]?format=3"
end

function ports
    sudo netstat -tulpn | grep LISTEN
end

function killport
    sudo kill -9 (sudo lsof -t -i:$argv[1])
end

# Git functions
function gclone
    git clone $argv[1]
    cd (basename $argv[1] .git)
end

function gignore
    curl -sL "https://www.gitignore.io/api/$argv[1]"
end

# Auto-suggestions and completions
set -g fish_autosuggestion_enabled 1
set -g fish_autosuggestion_highlight_style 'fg=6c7086'

# Greeting
# function fish_greeting
#     echo
#     echo "Welcome to "(set_color purple)"Fish"(set_color normal)" on "(set_color cyan)"Arch Linux"(set_color normal)
#     echo "Today is "(set_color yellow)(date +"%A, %B %d, %Y")(set_color normal)
#     echo
# end
set -g fish_greeting ""

# Key bindings
bind \cf accept-autosuggestion
bind \ce edit_command_buffer

# History
set -g fish_history_max 10000
