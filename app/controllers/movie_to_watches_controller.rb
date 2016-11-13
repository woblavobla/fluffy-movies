class MovieToWatchesController < ApplicationController
  def update
    movie = Movie.find(params.require(:id))
    movie_to_watch = movie.movie_to_watches.where(:user_id => params[:user_id]).first

    if movie_to_watch.update_attribute(:date_of_added, DateTime.now)
      redirect_to movie_to_watch.movie
    else
      redirect_to movie_to_watch.movie, :alert => "Error while adding this film, to your watch list"
    end
  end

  def destroy
    movie_to_watch = MovieToWatch.find(params.require(:id))
    user = movie_to_watch.user
    if movie_to_watch.user.watched_movies.where(:movie => movie_to_watch.movie).first == nil
      movie_to_watch.user.watched_movies.create(:movie => movie_to_watch.movie, :watched => true)
    end
    movie_to_watch.destroy!
    redirect_to user
  end
end