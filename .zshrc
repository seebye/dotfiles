# start zsh and execute a command and wait for input
# via zsh -is eval 'first command'
#
# used to differentiate terminal emulators
if [[ $1 == eval ]]
then
     "$@"
#set --
fi


if [[ $terminix == 1 ]] ; then
       # terminial used for public places
       # show the fools a notepad like terminal
       # reason: idiots -> terminal = hacking
       ZSH_THEME="xxf-for-the-fools/xxf"
else
       ZSH_THEME="minimal-theme/minimal-theme"
fi

# default editor for ranger
export EDITOR="vim"

# android
export PATH=$PATH:$HOME"/Android/Sdk/platform-tools"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# fancy icons
export LC_ALL=en_US.UTF-8

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



neofetch() {
	$HOME/github/others_projects/neofetch/neofetch --image ascii --ascii_colors 255 173
}
get_sandbox_display() {
### selinux

	# returns the x display 
	# of sandboxed firefox
#	echo :$(cat ~/.sandboxes/firefox/seremote | sed 's/[^0-9]//g' | xargs)

### firejail
	cat $HOME/Sandboxes/firefox.new/seremote
}
# only sandboxed firefox supported currently..
set-sandbox-clipboard() {
	# read host | set sandbox
	sandbox=$(get_sandbox_display)
	xsel --display $DISPLAY -b -o | xsel -i -b --display $sandbox
}
get-sandbox-clipboard() {
	# 1. arg: X-Display e.g. ":0"
	# xsel -o --display $1
	sandbox=$(get_sandbox_display)
	xsel --display $sandbox -b -o | xsel -i -b --display $DISPLAY
}
# github pw store: git config credential.helper store
#alias w3mimgdisplay=/usr/libexec/w3m/w3mimgdisplay
w3mimgdisplay() {
 	# source: https://wiki.vifm.info/index.php?title=How_to_preview_images
	# Based on script by z3bra -- 2014-01-21
	W3MIMGDISPLAY="/usr/libexec/w3m/w3mimgdisplay"
	FONTH=15 # Size of one terminal row
	FONTW=7 # Size of one terminal column
 
	X=$1
	Y=$2
	COLUMNS=$3
	LINES=$4
	FILENAME=$5

	if [[ $# -le 4 ]] ; then
		echo "usage: $0 x y with height path"
		return 1
	fi
 
	read width height <<< `echo "5;$FILENAME" | $W3MIMGDISPLAY`
	if [ -z "$width" -o -z "$height" ]; then
	    echo 'Error: Failed to obtain image size.'
	    return 1
	fi
 
	x=$((FONTW * X))
	y=$((FONTH * Y))
 
	max_width=$((FONTW * COLUMNS))
	max_height=$((FONTH * LINES))
 
	if [ "$width" -gt "$max_width" ]; then
	    height=$((height * max_width / width))
	    width=$max_width
	fi
	if [ "$height" -gt "$max_height" ]; then
	    width=$((width * max_height / height))
	    height=$max_height
	fi
 
	w3m_command="0;1;$x;$y;$width;$height;;;;;$FILENAME\n4;\n3;"
 
	echo -e "$w3m_command" | $W3MIMGDISPLAY
}
forceamd() {
	# forces a program to use the amd gpu
	DRI_PRIME=1  "$@"
}
pastime() {
	# todo add more?
	echo 'Try pacvim'
}
sudo() {
	print $(tput bold)"$@"$(tput sgr0)

	echo -n "Press y to continue the execution."
	read -sk input
	echo

	case $input in 
		[^Yy]* ) return ;;
	esac

	command sudo "$@"
}

dlna() {
	minidlnad -f /home/$USER/.config/minidlna/minidlna.conf -P /home/$USER/.config/minidlna/minidlna.pid
}

timeit() {
	local START=$(date +%s.%N)

	eval "$@"

	local END=$(date +%s.%N)
	echo $(echo "$END - $START" | bc) s
}

search_tvs() {
	# source: https://stackoverflow.com/questions/20221112/filtering-nmap-outputs-using-grep-awk-or-sed/20222165#20222165
	nmap -p 55000 192.168.0.0/24 | awk '
	  /^Nmap scan report for/ {
	    if (open) {
	      print output;
	    }
	    output="";
	    open=0;
	  }
	
	  {
	    output=output $0 "\n";
	  }
	
	  $2 == "open" {
	    open=1;
	  }
	
	  END {
	    if (open) {
	      print output;
	    }
	  }
	' | grep for | sed 's/^[^0-9]*//g'

}

youtube_watch() {
	# source: https://www.reddit.com/r/linux/comments/49u4f7/watch_youtube_videos_in_terminal/
	youtube-dl 'http://www.youtube.com/watch?v='$1 -o - | \
	    mplayer -cache 122767 -vo aa:driver=curses -
}

is_altyo_terminal() {
	if [[ $COLORTERM == 'altyo' ]] ; then
		echo 1
	else
		echo 0
	fi
}
set_title_altyo() {
	if [[ $(is_altyo_terminal) == 1 ]] ; then
		xdotool key ctrl+shift+i
		if [[ $@ == "" ]] ; then
			xdotool type " "
			xdotool key BackSpace
		else
			xdotool type $@
		fi
		sleep .1
		xdotool key Return
	fi
}
music() {
	set_title_altyo music
	mpd --no-daemon &
	echo starting mpd
	sleep 1
	echo updating media database
	mpc -p 6600 update 
	$HOME/i3/lemonbar-music-show.sh &> /dev/null &
	sleep 1
	clear
	sleep 1
	ncmpcpp --config $HOME/.config/ncmpcpp/config
	echo killing mpd
	killall mpd 
	echo killing lemonbar
	killall lemonbar
	set_title_altyo ""
	clear
}

get_man_description() {
	man $1 | grep -Pzo '(?s)DESCRIPTION[ \t\n]+(.*?)\n\n' | grep -Pzo '(?s)[ \t](.*)\n' | xargs
}

search_command() {
	local found=0

	local searchpattern=""

	for arg in $@ ; do
		if [[ $searchpattern != "" ]] ; then
			local searchpattern=$searchpattern"\|"
		fi

		local searchpattern=$searchpattern$arg
	done

	for cmd in $(ls /bin) ; do
		# { whatis $cmd | grep $1 } &> /dev/null
		local res=$({ get_man_description $cmd } 2>&1 >/dev/null)
		local ok=1

		[[ $res == "" ]] && local res=$({ get_man_description $cmd }) || local res=""

		for i in $@ ; do
			echo $res | grep $i &> /dev/null

			if [[ $? != 0 ]] ; then
				local ok=0
			fi
		done

		if [[ $ok != 0 ]] ; then
			local found=$(expr $found + 1)

			whatis $cmd
			
			get_man_description $cmd | grep $searchpattern
			echo '\n'
		fi
	done

	echo 'Found '$found' commands'
}
explain_command() {
    local retval=1
    local explanation=""
    while [[ $retval != 0 || $explanation == ""
		|| $explanation == *"nothing appropriate"*
		|| $explanation == *"unknown subject"* ]] ; do
    	# 2>&1 prevents errors from beeing printed
        local explanation=$(whatis $(ls /bin | shuf -n 1) 2>&1)
        local retval=$?
    done

    echo "Did you know that:\n"$explanation
}

explain_command2() {
	explain_command | sed 's/[ ]\+ \- /\n/g' | fold -s -w 42 | boxes -d parchment 
}

forbes_saying() {
	local saying=$(wget -O - -o /dev/null "http://www.forbes.com/forbesapi/thought/get.json?limit=1&random=true&stream=true" | jq ".thoughtStream.thoughts")

	echo $(echo $saying | jq ".[0].quote")"\n"$(echo $saying | jq ".[0].thoughtAuthor.name" | sed 's/\"//g') | fold -s -w 42 | boxes -d parchment 
}

min() {
	local val=999999999999999999

	for i in $@ ; do
		if [[ $i -lt $val ]] ; then
			val=$i
		fi
	done

	echo -n $val
}

max() {
	local val=-999999999999999999

	for i in $@ ; do
		if [[ $i -gt $val ]] ; then
			val=$i
		fi
	done

	echo -n $val
}

fill() {
	# repeats a string sequence n times
	local n=$1
	local seq=$2

	for i in {0..$n} ; do
		echo -n $seq
	done
}

supported_colors() {
	BLOCK=$(fill 5 "\u2588")

	for COLOR in {0..255} 
	do
	    for STYLE in "38;5"
	    do
	        TAG="\033[${STYLE};${COLOR}m"
	        STR="${STYLE};${COLOR}"
	        [[ $# -lt 1 ]] && echo -ne "${TAG}${STR}${BLOCK}${NONE}  " || echo -ne "${TAG}${BLOCK}${NONE}"
	    done
	    [[ $# -lt 1 ]] && echo
	done

	return 0
}


if [[ $(is_altyo_terminal) == 1 ]] ; then
	echo
	figlet -c -w 140 -f shadow Terminal Emulator altyo
	#echo
	explain_command2 #forbes_saying
	echo
elif [[ 1 == 2 ]] ; then
	explain_command
fi

if [[ $(is_altyo_terminal) != 1 ]] ; then
	# xterm use ibeam as cursor
	#echo -e -n "\x1b[\x30 q" # changes to blinking block
	#echo -e -n "\x1b[\x31 q" # changes to blinking block also
	#echo -e -n "\x1b[\x32 q" # changes to steady block
	#echo -e -n "\x1b[\x33 q" # changes to blinking underline
	#echo -e -n "\x1b[\x34 q" # changes to steady underline
	#echo -e -n "\x1b[\x35 q" # changes to blinking bar
	echo -e -n "\x1b[\x36 q" # changes to steady bar
fi



# enable zsh vi mode
bindkey -v
zle -N zle-keymap-select
# restore some keybindungs - vi mode
# command search
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
# other (source: http://zshwiki.org/home/zle/bindkeys)
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char


# go
export GOPATH="$HOME/Arbeit/go/workspace/"
export default_user="nico"
alias ls='ls -h --color=auto --group-directories-first'
