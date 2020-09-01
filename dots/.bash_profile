### PROMPT

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		echo "[${BRANCH}]"
	else
		echo ""
	fi
}

export PS1="\[\e[34;40m\]\W\[\e[m\]\[\e[32m\]\`parse_git_branch\`\[\e[m\]\\$ "


### ALIASES
alias vim=nvim


### COMPLETION
[[ -r "/usr/local/etc/profile.d/autojump.sh" ]] && . "/usr/local/etc/profile.d/autojump.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
