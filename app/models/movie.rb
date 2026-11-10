class Movie < ApplicationRecord
  #### Part 2 ####
  # movies whose director matches the director of `self`,
  # excluding `self` itself. Returns [] for movies without a director.
  def others_by_same_director
    return [] if director.blank?
    Movie.where(director: director)
         .where.not(id: id)
  end
end
