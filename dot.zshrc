# =============================================================================
#                                   oh-my-zsh
# =============================================================================
ZSH="$HOME/.oh-my-zsh"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# plugins=(git zsh-syntax-highlighting zsh-title colored-man)

source $ZSH/oh-my-zsh.sh

# =============================================================================
#                                  Prompt Setup
# =============================================================================

function _prompt_char() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo "%{%F{blue}%}±%{%f%k%b%}"
  else
    echo ' '
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=" [%{%B%F{12}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%F{10}%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}*%{%f%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%{%f%k%b%}
%{%K{black}%B%(!|%F{9}|%F{11})%}%n%{%B%F{14}%}@%m %{%b%F{yellow}%}%~%{%B%F{10}%}$(git_prompt_info)%E%{%f%k%b%}
%{%K{black}%}$(_prompt_char)%{%K{black}%} %#%{%f%k%b%} '

DEFAULT_RPROMPT=""
setopt prompt_subst
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    export RPROMPT="%(0?||%{%F{red}%}%? )%{%F{cyan}%}${timer_show}s %{$reset_color%}"
    unset timer
  else
    export RPROMPT=$DEFAULT_RPROMPT
  fi
}

# =============================================================================
#                                  Environment
# =============================================================================
export PATH="$HOME/local/bin:/usr/local/bin:$PATH"
export EDITOR="vim"
export VISUAL="vim"
export LC_ALL="en_US.utf-8"
export LANG="$LC_ALL"
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# =============================================================================
#                                    Colors
# =============================================================================
# for tmux: export screen-256color
[ "$TERM" = "linux" ] || { [ -n "$TMUX" ] && export TERM="screen-256color" || export TERM="xterm-256color" }
eval `dircolors ~/.dir_colors`
export GREP_COLOR=35

# =============================================================================
#                                    Aliases
# =============================================================================
# Make "open" open things
command -v gnome-open > /dev/null && alias open='gnome-open'
command -v gvfs-open > /dev/null && alias open='gvfs-open'

alias vi="vim"
alias vint="vim +NT"

alias ls='ls --color=auto -h --group-directories-first'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ag='ag --color-path=33 --color-match=35 --context=2'

alias glg="git log --graph --decorate --abbrev-commit --date=relative"
alias gn="git number"
alias gst="gn"
alias gds="git diff --staged -w"
alias gp="git push origin HEAD -u"
alias gph="gp && gh"
alias gcd="git checkout develop && git pull"
alias gcm="git checkout master && git pull"

alias hlog='git log --all --graph --format="%C(yellow)%h %C(reset)%an %C(blue)%ar %C(red)%d %C(reset)%s"'
alias xlog='git log --graph --format="%C(yellow)%h %C(reset)%an %C(blue)%ar %C(red)%d %C(reset)%s"'
alias slog='git log --stat --all --graph --format="%C(yellow)%h %C(reset)%an %C(blue)%ar %C(red)%d %C(reset)%s"'
alias mlog='git log --all --graph --format="%C(yellow)%h %C(red)%d %C(reset)%s"'

# =============================================================================
#                                  Functions
# =============================================================================
function vim-conflicts() {
  vim -p +/"<<<<<<<" $( git diff --name-only --diff-filter=U | xargs )
}

function gh() {
  open `git remote get-url origin | sed -Ee 's#(git@|git://)#https://#' -e 's@:([^:]+).git$@/\1@'`
}

man() {
    env \
        LESS_TERMCAP_mb=$'\e[31m' \
        LESS_TERMCAP_md=$'\e[36m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[32m' \
            man "$@"
}

# =============================================================================
#                     Source user-specific customizations
# =============================================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
