module Cacheable

  # create takes a string, assigns a random uuid
  # then stores the (uuid, string) pair in Redis
  # It returns the uuid as a string

  def create(string)
    uuid = generate_uuid
    save(uuid, string)
    uuid
  end

  # find takes a string-valued uuid as a key and 
  # retrieves a stored value from the redis cache
  # It returns the retrieved value as a string

  def find(uuid)
    REDIS.get(uuid)
  end

  private

  # save takes a string-valued uuid and a string 
  # and stores the string in redis with a key of 
  # the uuid

  def save(uuid, string)
    REDIS.set(uuid, string)
  end

  # generate_uuid takes no parameters 
  # It generates and returns a uuid as a string
  
  def generate_uuid
    SecureRandom.uuid
  end
end