#!/usr/bin/env puma

# Better explanations at:                  https://github.com/puma/puma/blob/3cbe5219a221cc5bdf4c1e0e8c37fc4ec8d83fce/examples/config.rb
# Executes in this obj (instance_evaled):  https://github.com/puma/puma/blob/3cbe5219a221cc5bdf4c1e0e8c37fc4ec8d83fce/lib/puma/configuration.rb#L158

# Setup paths
root_dir = File.expand_path('..', __FILE__)
tmp_dir  = File.join(root_dir, 'tmp')
Dir.mkdir tmp_dir unless Dir.exist? tmp_dir

# Serve from the root
directory root_dir

# Prod rackup file
rackup File.join(root_dir, 'config.prod.ru')

# Set the environment
environment 'production'

# Daemonize the server
daemonize true
pidfile    File.join(tmp_dir, 'puma.pid')
state_path File.join(tmp_dir, 'puma.state')

# Logging
append_to_files = true
stdout_redirect File.join(tmp_dir, 'puma_out.log'), File.join(tmp_dir, 'puma_err.log'), append_to_files

# Serve on a socket so we don't need root access
bind 'unix:///tmp/octo.sock'
