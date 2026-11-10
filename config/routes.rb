Rottenpotatoes::Application.routes.draw do
  resources :movies do
    # Part 2: "show movies with similar director"
    # i.e. GET /movies/:id/similar, e.g. /movies/1/similar
    get 'similar', on: :member
  end

  root to: redirect('/movies')
end
