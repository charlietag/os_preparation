# Copy this file to additional_environment.rb and add any statements
# that need to be passed to the Rails::Initializer.  `config` is
# available in this context.
#
# Example:
#
#   config.log_level = :debug
#   ...

# -------------------------------------------------------------------------------------------------------------------------
# Avoid request.remote_ip always being 127.0.0.1 in production.log
#   default rails will record remote_ip as 127.0.0.1 , if client is from private lan (192.168.x.x)
# -------------------------------------------------------------------------------------------------------------------------
# config.action_dispatch.trusted_proxies = [IPAddr.new('127.0.0.1')]

# -------------------------------------------------------------------------------------------------------------------------
# Add timestamp (in system default timezone)
# Fail2ban requires timestamp to calulate the findtime, etc.
# Default redmine log authenication error in UTC
# /home/rubyuser/rails_sites/redmine/app/controllers/account_controller.rb
#  def invalid_credentials
#    logger.warn "Failed login for '#{params[:username]}' from #{request.remote_ip} at #{Time.now.utc}"
#    flash.now[:error] = l(:notice_account_invalid_credentials)
#  end
# And if it's logged in UTC, and my timezone is +0800,
# findtime 600, will never find the failed attempped log.
# -------------------------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------------------------
# Solution 1:
#   #{Time.now.utc} -> #{Time.now}
# Log Format:
#   "Failed login for 'asdf' from 59.124.165.113 at 2019-09-02 14:06:03 +0800"
# -------------------------------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------------------------------
# Solution 2:
#   Change default log formatter as the following 2 methods
# Log Format:
#   "W, [2019-09-02T14:07:37.426871 #18632]  WARN -- : Failed login for 'afdfdasdf' from 59.124.165.113 at 2019-09-02 06:07:37 UTC"
# -------------------------------------------------------------------------------------------------------------------------

# --- Method 1: Rails Default config for Production ---
config.log_formatter = ::Logger::Formatter.new

# OR
# --- Method 2: Rails To Overwrite Rails default log formatter ---
# Add the following in file /home/rubyuser/rails_sites/redmine/config/environment.rb
#class Logger
#  def format_message(severity, timestamp, progname, msg)
#    "#{timestamp} (#{$$}) #{msg}\n"
#  end
#end
