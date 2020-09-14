# ----------------------------------------------------------------------------------------------------------------------
# Add for tmux compatibility
# ----------------------------------------------------------------------------------------------------------------------
# When launch tmux more than 2 sessions, rvm env (gemset, ruby version) is always not switched currectly
# Add this config to make sure all ruby / rails projects are setting properly

# Make sure rvm is loaded as a function (So that "cd" is replace with "cd()" )
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# change directory to load all rvm env
[[ -s "$HOME/.rvm/scripts/rvm" ]] && cd "."
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && cd $PWD
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && __zsh_like_cd cd "."

