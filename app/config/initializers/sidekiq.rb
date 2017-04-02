sidekiq_config = { url: ENV['JOB_WORKER_URL'] || 'fuck' }
Sidekiq.default_worker_options = { retry: 1 }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
