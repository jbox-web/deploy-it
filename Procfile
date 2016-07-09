web:    sbin/puma -C config/puma.rb
worker: sbin/sidekiq -C config/sidekiq.yml -L log/sidekiq.log
socket: sbin/thin start -C config/danthes_thin.yml
