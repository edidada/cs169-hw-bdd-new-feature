# CHIP 7.9 (hw-bdd-new-feature) Part 1:
# add the `director` field to the movies table.
class AddDirectorToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :director, :string
  end
end
