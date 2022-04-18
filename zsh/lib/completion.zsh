###############################################################################
# Initialize completion.
###############################################################################

# Reference to compinstall to load this specific file.
# If the user wants to run compinit to customize completion the compinit will
# find existing configuration and allow to update these
zstyle :compinstall filename "${ZSH}/completion.zsh"

# Load completion
# Commenting this line does not load completion module, effectively disabling it
autoload -Uz compinit
compinit -d "${ZSH_CACHE_DIR}/zcompdump-${ZSH_VERSION}"
_comp_options+=(globdots) # With hidden files

# Automatically highlight first element of completion menu
setopt MENU_COMPLETE
# Automatically list choices on ambiguous completion.
setopt AUTO_LIST
# Complete from both ends of a word.
setopt COMPLETE_IN_WORD


###############################################################################
# Define completers.
###############################################################################

# The definition order determines completer (completion alts.) source order
# (Keep this order! Should not be alphabetical!)
zstyle ':completion:*' completer \
  _extensions \
  _expand \
  _complete \
  _match \
  _correct \
  _approximate

# Other relevant completers:
# _list _oldlist (usually set first)
# _match _ignored (set after _complete )
# _prefix (usually set last)
# More at: https://zsh.sourceforge.io/Doc/Release/Completion-System.html

###############################################################################
# General completion options
###############################################################################

# ??
zstyle ':completion:*' completions 1

# Use cache for commands using cache
# [ -z "${ZCOMPCACHE}" ] && ZCOMPCACHE=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache
# mkdir -p "${ZCOMPCACHE}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZCOMPCACHE}"

# Complete elements with spaces
zstyle ':completion:*' add-space true

# Autocomplete options after '-' input for cd instead of directory stack
zstyle ':completion:*' complete-options true

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order \
  local-directories \
  directory-stack \
  path-directories

# Order by date of modification
zstyle ':completion:*' file-sort modification

# Prompt to show upon completion
zstyle ':completion:*' format '%d'

# Grouping of different types of matches in separate lists
# If empty string is given, the name of the tag for the matches  will be used
zstyle ':completion:*' group-name ''
# (Comment out this line to disable grouping)
# More thorough specification can be added like so:
# zstyle ':completion:*:*:-command-:*:commands' group-name commands
# zstyle ':completion:*:*:-command-:*:functions' group-name functions

# The groups named are shown in the given order;
# any other groups are shown in the order defined by the completion function.
zstyle ':completion:*:*:-command-:*' group-order \
  aliases builtins functions commands

# Ignore completion for '..'
# F.ex: 'foo/bar/..' does not complete 'foo/bar/../bar'
zstyle ':completion:*' ignore-parents parent pwd .. directory

# This style is used by the function that completes filenames.
# If it is true, and completion is attempted on a string containing multiple
# partially typed pathname components, all ambiguous components will be shown.
# Otherwise, completion stops at the first ambiguous component
zstyle ':completion:*' list-suffixes true

# Completion matcher order
zstyle ':completion:*' matcher-list \
  '+' \
  '+m:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+r:|[.]=** r:|=**' '+l:|=* r:|=*'
# Alternative:
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# See ZSHCOMPWID "completion matching control"

# Max number of errors that completion can accept in order to perform completion
zstyle ':completion:*' max-errors 5 numeric

# Use navigation keys to go through completion suggestions
# rather than cycling through them with th Tab key
# Only when the list does not fit the screen. To enable always remove '=long'
zstyle ':completion:*' menu select #=long

# zstyle ':completion:*' old-menu false

# Do not complete items starting with '//'
# '//' in directory completion still works, ex: 'f//b' completes to 'foo/dir/bar'
zstyle ':completion:*' preserve-prefix '//[^/]##/'

# Show completion item
zstyle ':completion:*' prompt '%e'

zstyle ':completion:*' verbose true

# Completion for stuff in paranthesis based on known_hosts file
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' \
  hosts \
  'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Adds nice colors to completion prompt
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# Use $LS_COLORS to enable coloring of files
# zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

###############################################################################
# _list completer (can be enabled on line 7)
###############################################################################

# This style is used by the _list completer function to decide if insertion
# of matches should be delayed unconditionally
# Show list if there are more than 1 completion options
# zstyle ':completion:*' condition 'NUMERIC != 1'

###############################################################################
# _expand completer (defined on line 7)
###############################################################################

# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true
# Define alias-expansion to complete aliases
# zle -C alias-expansion complete-word _generic
# # Bind expansion  to CTRL-A
# bindkey '^A' alias-expansion
# # Add completer
# zstyle ':completion:alias-expansion:*' completer _expand_alias

# If 'true' globbing will be attempted on the words resulting from a previous
# substitution (see the substitute style) or else the original string from the
# line.
zstyle ':completion:*' glob 1

# Used by _expand completer. If true the completer will try to keep
# prefix containing a tilde or paramter expansion
# F.ex '~/f' is expanded to '~/foo' rather than '/home/user/foo'
zstyle ':completion:*' keep-prefix true

# _expand completer will first try to expand all substitutions in the string
# such as ‘$(...)’ and ‘${...}’.
zstyle ':completion:*' substitute 1

###############################################################################
# _approximate completer (line 7)
###############################################################################

# This is used by the _match and _approximate completers.
# These completers are often used with menu completion since the word typed may
# bear little resemblance to the final completion.
# If 'true' the completer will start menu completion only if it could find no
# unambiguous initial string at least as long as the original string typed by
# the user.
zstyle ':completion:*' insert-unambiguous true

# This is used by the _approximate and _correct completers to decide if the
# original string should be added as a possible completion.
# Normally, this is done only if there are at least two possible corrections,
# but if this style is set to 'true', it is always added.
# Note that the style will be examined with the completer field in the context
# name set to correct-num or approximate-num, where num is the number of errors
# that were accepted.
zstyle ':completion:*' original false

###############################################################################
# _match completer (line 7)
###############################################################################

# If set, _match will try to generate matches without inserting a '*' at the
# cursor position. If non-empty value, it will first try to generate matches
# without inserting the '*' and if that yields no matches, it will try again
# with the '*' inserted. (Used below) # If it is unset or set to the empty
# string, matching will only be performed with the '*' inserted.
# zstyle ':completion:*' match-original both
