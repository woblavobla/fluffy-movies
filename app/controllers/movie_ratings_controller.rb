class MovieRatingsController < ApplicationController
  def update
    rating = MovieRating.find(params[:id])
    if rating.update_attributes(params[:movie_rating].permit(:rating))
      movie_to_watch = rating.user.movie_to_watches.where(:movie => rating.movie).first
      already_watched = rating.user.watched_movies.where(:movie => rating.movie).first
      if movie_to_watch != nil
        movie_to_watch.destroy!
      end
      if already_watched != nil
        already_watched.update(:watched => true)
      else
        rating.user.watched_movies.create(:movie => rating.movie, :watched => true)
      end
      redirect_to movie_path(rating.movie), :notice => 'Рейтинг фильма успешно обновлен'
    else
      redirect_to movie_path(rating.movie), :alert => "#{rating.errors.to_a}"
    end
  end
end