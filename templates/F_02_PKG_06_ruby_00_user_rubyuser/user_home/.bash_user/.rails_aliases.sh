# ----------------------------------------------------------------------------
# Linux grouping commands
# ----------------------------------------------------------------------------
# * Ref.
#   * https://www.gnu.org/software/bash/manual/html_node/Command-Grouping.html
#   * https://www.gnu.org/software/bash/manual/html_node/Command-Grouping.html
# ```
#   1 #!/bin/bash
#   2 # (difference)
#   3 # will create subshell
#   4 (NAME="Charlie") && echo "${NAME}"
#   5 # output: [EMPTY]
#   6
#   7 # using current shell. ';' and space ' ' are required. such as: { command; }
#   8 { NAME="Charlie"; } && echo "${NAME}"
#   9 # output: Charlie
# ```

alias bess='
  grep -q "spring" Gemfile.lock 2>/dev/null && \
    { \
      echo "==================================="; \
      echo "     Spring Status"; \
      echo "==================================="; \
      bundle exec spring status ; \
      echo ""; \
    }
  '

alias besp='
  grep -q "spring" Gemfile.lock 2>/dev/null && \
    { \
      echo "==================================="; \
      echo "     Spring Stop"; \
      echo "==================================="; \
      bundle exec spring stop ; \
      echo ""; \
    }
  '


alias be='bundle exec'
alias bl='bundle exec rails'

#alias bv='
#  grep -q "spring" Gemfile.lock 2>/dev/null && \
#    { \
#      echo "==================================="; \
#      echo "     Spring Stop"; \
#      echo "==================================="; \
#      bundle exec spring stop ; \
#      echo ""; \
#    }; \
#  grep -q "rails" Gemfile.lock 2>/dev/null && \
#    { \
#      echo "==================================="; \
#      echo "     rails tmp:clear"; \
#      echo "==================================="; \
#      bundle exec rails tmp:clear ; \
#      echo "" ; \
#      echo "==================================="; \
#      echo "     rails assets:clobber"; \
#      echo "==================================="; \
#      bundle exec rails assets:clobber ; \
#      echo "" ; \
#      echo "==================================="; \
#      echo "     Start Rails in Dev Mode"; \
#      echo "==================================="; \
#      bundle exec rails server -b 0.0.0.0 ; \
#      echo ""; \
#    }
#  '

alias bn='
  grep -q "spring" Gemfile.lock 2>/dev/null && \
    { \
      echo "==================================="; \
      echo "     Spring Stop"; \
      echo "==================================="; \
      bundle exec spring stop ; \
      echo ""; \
    }; \
  grep -q "rails" Gemfile.lock 2>/dev/null && \
    { \
      echo "==================================="; \
      echo "     rails tmp:clear"; \
      echo "==================================="; \
      bundle exec rails tmp:clear ; \
      echo "" ; \
      echo "==================================="; \
      echo "     rails assets:clobber"; \
      echo "==================================="; \
      bundle exec rails assets:clobber ; \
      echo ""; \
    }
  '

alias br='
  grep -q "spring" Gemfile.lock 2>/dev/null && \
    { \
      echo "==================================="; \
      echo "     Spring Stop"; \
      echo "==================================="; \
      bundle exec spring stop ; \
      echo ""; \
    }; \
  grep -q "rails" Gemfile.lock 2>/dev/null && \
    { \
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
      test -f package.json && yarn install ; \
      echo "" ; \
      echo "==================================="; \
      echo "     touch tmp/restart.txt"; \
      echo "==================================="; \
      bundle exec rails restart ; \
      echo ""; \
    }
  '

# alias bs='
#   grep -q "spring" Gemfile.lock 2>/dev/null && \
#     { \
#       echo "==================================="; \
#       echo "     Spring Stop"; \
#       echo "==================================="; \
#       bundle exec spring stop ; \
#       echo ""; \
#     }; \
#   grep -q "rails" Gemfile.lock 2>/dev/null && \
#     { \
#       echo "==================================="; \
#       echo "     Start Rails in Dev Mode"; \
#       echo "==================================="; \
#       bundle exec rails server -b 0.0.0.0 ; \
#       echo ""; \
#     }
#   '

# -----------------------------------------------------
# For Rails 7 compat
# -----------------------------------------------------
alias bs='
  grep -q "spring" Gemfile.lock 2>/dev/null && \
    { \
      echo "==================================="; \
      echo "     Spring Stop"; \
      echo "==================================="; \
      bundle exec spring stop ; \
      echo ""; \
    }; \
  test -f bin/dev && \
  { \
    cat Procfile.dev | grep -vE "^[[:space:]]*#" | grep -E '0\.0\.0\.0' && \
      { \
        echo "==================================="; \
        echo "     Start Rails in Dev Mode"; \
        echo "==================================="; \
        bin/dev ; \
        echo ""; \
      } || \
      { \
        echo "==================================="; \
        echo "     check Procfile.dev"; \
        echo "==================================="; \
        cat Procfile.dev | grep rails ; \
        echo ""; \
      }; \
  } || \
  { \
    grep -q "rails" Gemfile.lock 2>/dev/null && \
      { \
        echo "==================================="; \
        echo "     Start Rails in Dev Mode"; \
        echo "==================================="; \
        bundle exec rails server -b 0.0.0.0 ; \
        echo ""; \
      }
  }
  '

# alias bdev='
#   grep -q "spring" Gemfile.lock 2>/dev/null && \
#     { \
#       echo "==================================="; \
#       echo "     Spring Stop"; \
#       echo "==================================="; \
#       bundle exec spring stop ; \
#       echo ""; \
#     }; \
#   grep -q "rails" Gemfile.lock 2>/dev/null && \
#     { \
#       echo "==================================="; \
#       echo "     Start Rails in Dev Mode"; \
#       echo "==================================="; \
#       bin/dev ; \
#       echo ""; \
#     }
#   '

alias bp='bin/importmap'

