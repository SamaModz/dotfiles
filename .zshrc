# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
EDITOR='nvim'
# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="false"

plugins=(
  command-not-found
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-autopair
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# Aliases for Termux
# List all files and directories in the current directory
alias ls='eza --all --icons=always --no-time --color=always --no-user --no-permissions --no-filesize --long'
# Change Font
alias chfont='cp $1 $HOME/.config/font.ttf'
# Edit $HOME/.zshrc
alias zsh-edit='%F{EDITOR} $HOME/.zshrc'
# Reload Termux settings
alias reload='termux-reload-settings && source $HOME/.termux/colors.properties && source .config/termux/termux.properties'
# Open Neovim configuration
alias nc='%F{EDITOR} $HOME/.config/nvim'

# COnvert inches to centimeters
function pol() { echo "scale=2; 2.54 * $1" | bc }
# Get the Documentantion of Node.js
function node-docs { local section=${1:-all}; open_command "https://nodejs.org/docs/$(node --version)/api/$section.html" }
# Create a new directory and enter it 
function mkd() { mkdir -p "$@" && cd "$@" }
# Create a new file and open it with nvim
function mkf() { touch "$@" && nvim "$@" }
# Open a new session with a contact
function call() { termux-telephony-call $1 }
# Opens a conversation with AI (Gemini || Mistral)
# function ai() { node $HOME/.config/ai/gemini.js }

# Set up colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Set up the prompt
PROMPT='%F{blue}%n%f@%F{green}%m%f %F{yellow}%~%f %# '

# Set up the prompt for root
RPROMPT='%F{red}%#%f'

# Set up the prompt for SSH_CONNECTION
if [[ -n $SSH_CONNECTION ]]; then
  PROMPT='%F{blue}%n%f@%F{green}%m%f %F{yellow}%~%f %F{red}ssh%f %# '
fi

# Set up the prompt for root over SSH 
if [[ -n $SSH_CONNECTION ]] && [[ $USER == "root" ]]; then
  PROMPT='%F{blue}%n%f@%F{green}%m%f %F{yellow}%~%f %F{red}ssh%f %# '
fi

# Set up the PS2 prompt 
PS2='%F{red}●%f '

# Set up the PS3 prompt 
PS3='%F{red}▪%f '

# Set up the PS4 prompt 
PS4='%F{red}+%f '

# Set up the Oh-My-Posh prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/themes/theme.omp.json)"