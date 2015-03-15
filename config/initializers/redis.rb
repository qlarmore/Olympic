$redis ||= Redis.new(:host => 'localhost', :port=> 6379)
# module ReadCache
#  class << self
#    def redis
#    end
#  end
# end