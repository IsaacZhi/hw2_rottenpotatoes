class Movie < ActiveRecord::Base
  @@static_all_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
  def self.all_ratings
    @@static_all_ratings
  end
end
