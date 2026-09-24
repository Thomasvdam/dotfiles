# Stolen from https://github.com/anna-oake/nixos-config/blob/main/modules/home/profiles/workstation/ssh-tint.zsh
# Ghostty only. Tint the background for the life of an SSH session.
# The color comes from the host key in known_hosts, so the same host stays
# the same color and an unknown host is a plain red.

_ssh_tint() {
    emulate -L zsh
    zmodload zsh/mathfunc
    local -a cfg files lines
    local host port key f sum
    cfg=("${(@f)$(command ssh -G "$@" 2>/dev/null)}")
    host=${${(M)cfg:#hostname *}#hostname }
    port=${${(M)cfg:#port *}#port }
    [[ -n $host ]] || return 1
    [[ $port == 22 ]] || host="[$host]:$port"
    files=(${=${${(M)cfg:#userknownhostsfile *}#* }} ${=${${(M)cfg:#globalknownhostsfile *}#* }})
    for f in $files; do
        [[ -r $f ]] && lines+=("${(@f)$(ssh-keygen -F $host -f $f 2>/dev/null)}")
    done
    # prefer ed25519 (what ssh records by default), then any key
    key=${${(M)lines:#* ssh-ed25519 *}[1]}
    [[ -n $key ]] || key=${${(M)lines:#[^\#]*}[1]}
    key=${${=key}[3]}
    # unknown host: plain red tint
    [[ -n $key ]] || { print -n '#2a1a1a'; return }
    sum=$(print -rn -- $key | cksum)
    # 16 evenly spaced hues x 2 brightness levels, dark and muted like the terminal background
    local -i n=$(( ${sum%% *} % 32 ))
    local -F hp=$(( n % 16 * 6 / 16.0 )) s=0.35 l=$(( n < 16 ? 0.12 : 0.19 )) c x m
    c=$(( (1 - abs(2 * l - 1)) * s ))
    x=$(( c * (1 - abs(fmod(hp, 2) - 1)) ))
    m=$(( l - c / 2 ))
    local -a rgb
    case $(( int(hp) )) in
        0) rgb=($c $x 0) ;; 1) rgb=($x $c 0) ;; 2) rgb=(0 $c $x) ;;
        3) rgb=(0 $x $c) ;; 4) rgb=($x 0 $c) ;; *) rgb=($c 0 $x) ;;
    esac
    printf '#%02x%02x%02x' $(( int((rgb[1] + m) * 255) )) $(( int((rgb[2] + m) * 255) )) $(( int((rgb[3] + m) * 255) ))
}

_with_ssh_tint() {
    emulate -L zsh
    local cmd=$1 tint rc=0
    shift
    tint=$(_ssh_tint "$@") || true
    [[ -n $tint ]] && printf '\033]11;%s\033\\' "$tint"
    {
        command "$cmd" "$@"
        rc=$?
    } always {
        printf '\033]111\033\\'
    }
    return $rc
}

ssh() { _with_ssh_tint ssh "$@" }
