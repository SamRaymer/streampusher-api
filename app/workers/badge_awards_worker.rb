class BadgeAwardsWorker < ActiveJob::Base
  FRUITS = ["strawberry", "lemon", "orange", "cabbage", "banana", "watermel"]
  AWARD_THRESHOLD = 50_000

  include RedisConnection
  queue_as :default

  def perform radio_id
    radio = Radio.find radio_id
    radio.users.find_each do |user|
      FRUITS.each do |fruit|
        count = redis.hget "datafruits:user_fruit_count:#{user.username}", fruit
        if count >= AWARD_THRESHOLD & !user.roles.include?(fruit)
          user.roles << fruit
          user.save
        end
      end
    end
  end
end
