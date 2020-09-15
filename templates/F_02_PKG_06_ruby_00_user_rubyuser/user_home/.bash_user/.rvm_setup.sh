if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  # --- defined from the beginning ---
  # To Fix - rvm path error, when no .rvmrc, .ruby-version, .ruby-gemset found


  # Fix TMUX session env,
  # After setting this var: $(__rvm_env_string) command will fetch currect ruby version &
  export rvm_previous_environment="default"
  # ----------------------------------




  # ----------------------------------------------------------------------------------------------------------------------
  # Add for tmux compatibility
  # ----------------------------------------------------------------------------------------------------------------------
  # #######################################################################################################
  # When launch tmux more than 2 sessions, rvm env (gemset, ruby version) is always not switched currectly
  # Add this config to make sure all ruby / rails projects are setting properly,
  # (when .ruby-version , .ruby-gemset is detected)
  # i.e.
  # cd rails_project_ruby_2.5
  # tmux new
  # cd /some_other/rails_2.7
  # gem env <--- wrong env
  # #######################################################################################################

  # Make sure rvm is loaded as a function (So that "cd" is replace with "cd()" )
  #[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
  source "$HOME/.rvm/scripts/rvm"

  # change directory to load all rvm env
  #[[ -s "$HOME/.rvm/scripts/rvm" ]] && cd "."
  cd "."
  #[[ -s "$HOME/.rvm/scripts/rvm" ]] && cd $PWD
  #[[ -s "$HOME/.rvm/scripts/rvm" ]] && __zsh_like_cd cd "."


  # #######################################################################################################
  # Add this to make sure , rvm is using DEFAULT ruby version and rvm gemset
  # (when .ruby-version , .ruby-gemset is NOT detected)
  # i.e.
  # cd rails_project_ruby_2.5
  # tmux new
  # cd $HOME
  # ruby -v
  # >> 2.5 <--- not switch back to default (which might be 2.7)
  # #######################################################################################################
  # Fix TMUX session env,
  # After setting this var: $(__rvm_env_string) command will fetch currect ruby version &

  # --- defined from the beginning ---
  # Define again... Because it's been replaced
  export rvm_previous_environment="default"
  # ----------------------------------

  # Tmux will use "current" (.ruby-version & .ruby-gemset), not "default" (rvm use xxx --default)
  #export rvm_previous_environment="$(__rvm_env_string)"


  # --- Set tmux env value to right value ---
  if [[ -n "${TMUX}" ]]; then
    # Do NOT change to HOME, to make sure use current project's env (GEM_*)
    #cd "$HOME"

    tmux setenv GEM_HOME $GEM_HOME
    tmux setenv -g GEM_HOME $GEM_HOME
    tmux setenv GEM_PATH $GEM_PATH
    tmux setenv -g GEM_PATH $GEM_PATH

    #cd "${OLDPWD}"
  fi

  # --- Verify tmux env value ---
  # ## Current session ##
  # tmux showenv
  # ## Global session ##
  # tmux showenv -g
  rvm reload
fi
