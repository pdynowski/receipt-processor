if Rails.env.test?
  REDIS = MockRedis.new
else
  REDIS = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
end