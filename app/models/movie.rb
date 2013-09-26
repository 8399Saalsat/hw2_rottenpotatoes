class Movie < ActiveRecord::Base
  @all_ratings = Array.new(['G','PG','PG-13','R'])
  def self.ratings
    return @all_ratings
  end
end
