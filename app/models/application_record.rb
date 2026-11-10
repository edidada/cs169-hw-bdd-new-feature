# Rails 4.2 has no ApplicationRecord base class (introduced in Rails 5),
# but the official hw-bdd-new-feature starter's app/models/movie.rb
# subclasses it. Provide the standard trivial abstract base class so the
# starter model loads unchanged.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
