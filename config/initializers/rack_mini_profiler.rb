Rack::MiniProfiler.config.storage_options = { host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'] }
Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
