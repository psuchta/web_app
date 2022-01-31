module MoviesHelper
  def genres_select_options(genres)
    genres.map{ |genre| [genre[:name], genre[:id]] }
  end
end
