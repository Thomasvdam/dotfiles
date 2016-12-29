# Mostly based on purity by Kevin Lanni with some changes of my own
# https://github.com/therealklanni/purity
# MIT License

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)


# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
prompt_purity_human_time() {
	local tmp=$1
	local days=$(( tmp / 60 / 60 / 24 ))
	local hours=$(( tmp / 60 / 60 % 24 ))
	local minutes=$(( tmp / 60 % 60 ))
	local seconds=$(( tmp % 60 ))
	echo -n "⌚︎ "
	(( $days > 0 )) && echo -n "${days}d "
	(( $hours > 0 )) && echo -n "${hours}h "
	(( $minutes > 0 )) && echo -n "${minutes}m "
	echo "${seconds}s"
}

# displays the exec time of the last command if set threshold was exceeded
prompt_purity_cmd_exec_time() {
	local stop=$EPOCHSECONDS
	local start=${cmd_timestamp:-$stop}
	integer elapsed=$stop-$start
	(($elapsed > ${PURITY_CMD_MAX_EXEC_TIME:=5})) && prompt_purity_human_time $elapsed
}

prompt_purity_preexec() {
	cmd_timestamp=$EPOCHSECONDS

	# shows the current dir and executed command in the title when a process is active
	print -Pn "\e]0;"
	echo -nE "$PWD:t: $2"
	print -Pn "\a"
}

prompt_purity_precmd() {
	# shows the full path in the title
	print -Pn '\e]0;%~\a'
	
    local exec_time=$(prompt_purity_cmd_exec_time)

    # trim spaces and check string length != 0 before printing
    [[ -n "${exec_time// }" ]] && print -P " %F{yellow}$exec_time%f"

	# reset value since `preexec` isn't always triggered
	unset cmd_timestamp
}

prompt_purity_setup() {
	# prevent percentage showing up
	# if output doesn't end with a newline
	export PROMPT_EOL_MARK=''

	prompt_opts=(cr subst percent)

	zmodload zsh/datetime
	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info

	add-zsh-hook precmd prompt_purity_precmd
	add-zsh-hook preexec prompt_purity_preexec

	# show username@host if logged in through SSH
	[[ "$SSH_CONNECTION" != '' ]] && prompt_purity_username='%n@%m '

	# prompt turns red if the previous command didn't exit with 0
	PROMPT='%\[%*]:%B%c%b %(?.%F{green}.%F{red})❯%f '
	RPROMPT='%F{red}%(?..⏎)%f'
}

prompt_purity_setup "$@"

# Since I can't get it to work from the tmux gitbar config do it here
# until I have time to figure out what I'm doing wrong
if [[ -n "$ZSH_VERSION" && -n "$TMUX_GITBAR_DIR" ]]; then
    updateGitbarCmd() { $TMUX_GITBAR_DIR/update-gitbar };
    precmd_functions=(updateGitbarCmd);
fi
