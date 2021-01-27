# Ref. https://github.com/puma/puma/blob/master/lib/puma/dsl.rb
# Ref. https://puma.io/puma/Puma/DSL.html

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
# ----------- Puma Prod ------------
### Base var
app_dir = File.expand_path("../../..", __FILE__)
app_name = File.basename(app_dir)
app_tmp = "#{app_dir}/tmp"
app_log = "#{app_dir}/log"

### Display message
puts "--------------------------------------"
puts "Starting Puma server: #{app_dir}"
puts "--------------------------------------"

### Logging
stdout_redirect "#{app_log}/puma.stdout.log", "#{app_log}/puma.stderr.log", true

### TCP Port
# bind  "tcp://127.0.0.1:9292"

### Socket file path
#bind  "unix://#{app_tmp}/sockets/puma.sock"
bind  "unix:///run/rails_sites/#{app_name}_puma.sock"

### Pid file path
pids_dir = "#{app_tmp}/pids"
Dir.mkdir(pids_dir) unless Dir.exist?(pids_dir)

pidfile "#{pids_dir}/puma.pid"
state_path "#{pids_dir}/puma.state"
# activate_control_app

# ----------------------------
# Thread safe
# Ref. https://github.com/puma/puma/issues/531#issuecomment-48828357
# ----------------------------
## Thread setting

# #########################################
#        ##### Single Mode #####
# Worker setting: "single mode" -> value = 0
# #########################################
workers 0
#threads_count = 1  # not sure rails 4.2 is thread_safe
threads_count = 5
threads threads_count, threads_count
# --------------- Single --------------





# #########################################
#       ###### Cluster Mode #####
# For cluster mode. Uncomment this if workers > 1
# Worker setting: "cluster mode" -> value > 0
# For High Performance Production.
# #########################################
#cpu_cores = %x{grep -c processor /proc/cpuinfo}.to_i

##workers_count = cpu_cores * 10
##threads 5, 18

#workers_count = cpu_cores
#workers workers_count
#threads 1, 1  # not sure rails 4.2 is thread_safe


# -----------------------------------------
# (cluster mode) WARNING: Thread detected is normal , ref. https://github.com/schneems/puma_worker_killer/issues/35
# -----------------------------------------
#preload_app!

# -----------------------------------------
# (cluster mode) for copy on write feature
# -----------------------------------------
#on_worker_boot do
#  ActiveSupport.on_load(:active_record) do
#    ActiveRecord::Base.establish_connection
#  end
#end
# --------------- Cluster --------------


# #########################################
# #    Puma Prod  #
# #########################################

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "production" }


# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

