module GenresHelper

  def format_genres( genres )
    genres.map { |g| g.genre }.join( "\n" )
  end

end
