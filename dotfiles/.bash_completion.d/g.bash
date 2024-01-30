# delegate autocompletions of custom git aliases to their corresponding
# git commands

if [[ -f /usr/share/bash-completion/completions/git ]]; then
	source /usr/share/bash-completion/completions/git
else
	return 0
fi

__mhf_git_main() {
	__git_complete_command $1
}

__mhf_git_func_wrap ()
{
	local cur words cword prev
	_get_comp_words_by_ref -n =: cur words cword prev
	$1 $2
}

__mhf_git_complete() {
	local f="__mhf_git_main"
	local wrapper="__git_wrap${f}"
	eval "$wrapper () { __mhf_git_func_wrap $f $2 ; }"
	complete -o bashdefault -o default -o nospace -F $wrapper $1 2>/dev/null \
		|| complete -o default -o nospace -F $wrapper $1
}

__mhf_git_complete gb branch
__mhf_git_complete gco checkout
__mhf_git_complete gm merge
