class WatchedMoviesController < ApplicationController
  def update
    watched_movie = WatchedMovie.find(params[:id])
    if watched_movie.update_attributes(params[:watched_movie].permit(:watched))
      redirect_to movie_path(watched_movie.movie)
    else
      redirect_to movie_path(watched_movie.movie), :class => 'Watched status not updated'
    end
  end
end