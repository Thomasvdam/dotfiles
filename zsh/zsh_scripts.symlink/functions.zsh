#!/usr/bin/env zsh

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}";
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python3 -m http.server "$port";
}

# Display local or external ip address and copy to clipboard
function getip() {
	if [ $# -eq 0 ]
	then
		local ip=`ipconfig getifaddr en0`;
		printf "Local ip: ";
	elif [[ $1 = "-e" || $1 = "--external" ]]
	then
		local ip=`curl -s ipecho.net/plain`;
		printf "External ip: ";
	else
		echo "Usage: $0 [-e | --external]";
		return;
	fi

	echo $ip;
	echo $ip | pbcopy;
}

function mkdird() {
    mkdir $1 && cd $_;
}

function set_window_title() {
	echo -ne "\033]0; $(basename "$PWD") \007";
}
precmd_functions+=(set_window_title)
