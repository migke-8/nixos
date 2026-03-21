CURRENT_BG="NONE"
SEGMENT_SEPARATOR=""

LEFT_CORNER=""

get_segment() {
    local bg fg

    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    if [[ $CURRENT_BG != "NONE" && $1 != $CURRENT_BG ]]; then
        echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
    else
        local corner=""

        # [ $CURRENT_BG = "NONE" ] && corner="%{%k%F{$1%}%}$LEFT_CORNER"
        echo -n "$corner%{$bg%}%{$fg%} "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && echo -n $3
}
get_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}
has_git() {
    local dir=$1

    if [[ ! "$dir" =~ .*\/.* ]]; then
        return 2
    elif [[ -e "$dir/.git" ]]; then
        return 0
    else
        local parent_dir=$dir

        parent_dir="${parent_dir%\/*}"
        if [[ ${#parent_dir} -eq 0 && $dir != "/" ]]; then 
            parent_dir=/
        fi
        has_git $parent_dir
        return $?
    fi
}
get_prompt() {
    local default_bg="#272822"

    get_segment "$default_bg" "1" "%n"
    get_segment "1" "$default_bg" "󰨉"
    get_segment "$default_bg" "6" "localhost"
    get_segment "6" "$default_bg" "%~"
    has_git $PWD
    if [[ $? -eq 0 ]]; then
        local branch=$(git rev-parse --abbrev-ref HEAD)

        get_segment "$default_bg" "5" ""
        get_segment  "5" "$default_bg" "\ue0a0 $branch"
    fi
    get_end
}
set_prompt() {
    PROMPT='%{%f%b%k%}$(get_prompt) '
}

set_prompt
