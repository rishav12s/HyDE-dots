# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Path to powerlevel10k theme
#source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=(git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]] ; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
   aurhelper="paru"
fi

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null ; then
            arch+=("${pkg}")
        else 
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# Helpful aliases
alias  c='clear' # clear terminal
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list availabe package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='vscodium --ozone-platform=wayland'
alias code='vscodium --ozone-platform=wayland'
alias mirror='sudo reflector --verbose -c "India" --latest 10 --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias update='yay -Syu --devel'
alias emby_str='cd ~/docker/emby && docker compose up -d && cd ~'
alias emby_stp='cd ~/docker/emby && docker compose down && cd ~'
alias jiotv_start='cd ~/docker/jiotv_go && docker compose up -d && cd ~'
alias jiotv_stop='cd ~/docker/jiotv_go &&  docker stop d36e45b59bda && cd ~'
alias nf='fastfetch -c ~/.config/fastfetch/config_foot.jsonc'
alias fetch='fastfetch'
alias grub-update='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias nvim='~/.config/kitty/kitty.sh'


# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#Display Pokemon
pokeget random --hide-name
#echo -e "\n"

#fetch
#fastfetch
#pfetch
#nitch

export STARSHIP_CONFIG=~/.config/starship/starship.toml

eval "$(starship init zsh)"

export EDITOR=nvim
export FORCE_THEME_UPDATE=true   

# bun completions
[ -s "/home/rishav/.bun/_bun" ] && source "/home/rishav/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/rishav/.local/share/bin:/home/rishav/.jiotv_go/bin

export PATH=$PATH:/home/rishav/.spicetify
