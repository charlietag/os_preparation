alias be='bundle exec'
alias bl='bundle exec rails'

alias bv='
  echo "==================================="; \
  echo "     rails tmp:clear"; \
  echo "==================================="; \
  bundle exec rails tmp:clear ; \
  echo "" ; \
  echo "==================================="; \
  echo "     rails assets:clobber"; \
  echo "==================================="; \
  bundle exec rails assets:clobber ; \
  echo "" ; \
  echo "==================================="; \
  echo "     Start Rails in Dev Mode"; \
  echo "==================================="; \
  bundle exec rails server -b 0.0.0.0 ; \
  echo ""
  '

alias bn='
  echo "==================================="; \
  echo "     rails tmp:clear"; \
  echo "==================================="; \
  bundle exec rails tmp:clear ; \
  echo "" ; \
  echo "==================================="; \
  echo "     rails assets:clobber"; \
  echo "==================================="; \
  bundle exec rails assets:clobber ; \
  echo ""
  '

alias br='
  echo "==================================="; \
  echo "     rails tmp:clear"; \
  echo "==================================="; \
  bundle exec rails tmp:clear ; \
  echo "" ; \
  echo "==================================="; \
  echo "     rails assets:clobber"; \
  echo "==================================="; \
  bundle exec rails assets:clobber ; \
  echo "" ; \
  echo "==================================="; \
  echo "     rails assets:precompile RAILS_ENV=production"; \
  echo "==================================="; \
  bundle exec rails assets:precompile RAILS_ENV=production ; \
  echo "" ; \
  echo "==================================="; \
  echo "     yarn install again(under dev mode)"; \
  echo "     (because precomile do the yarn install under PROD mode)"; \
  echo "     (config/environments/development.rb:  config.webpacker.check_yarn_integrity = true)"; \
  echo "==================================="; \
  yarn install ; \
  echo "" ; \
  echo "==================================="; \
  echo "     touch tmp/restart.txt"; \
  echo "==================================="; \
  bundle exec rails restart ; \
  echo ""
  '

PS1="${COLOR_MAGENTA}\u@\h${COLOR_END} ${COLOR_DARK_CYAN}\t${COLOR_END} ${COLOR_BLUE}\w${COLOR_END}\n# "
