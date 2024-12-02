class CacheService
  DEFAULT_EXPIRATION = 2.hours

  def fetch(key, &block)
    Rails.cache.fetch(key, expires_in: DEFAULT_EXPIRATION, &block)
  end

  def write(key, value)
    Rails.cache.write(key, value, expires_in: DEFAULT_EXPIRATION)
  end
end
