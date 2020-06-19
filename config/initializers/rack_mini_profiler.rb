# frozen_string_literal: true
Rack::MiniProfiler.config.storage_options = {
  host:      Settings.redis_host,
  port:      Settings.redis_port,
  db:        Settings.redis_db,
  namespace: 'mini_profiler',
  driver:    :hiredis
}

Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
