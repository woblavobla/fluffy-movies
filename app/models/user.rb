class User < ApplicationRecord
  include Clearance::User
  has_and_belongs_to_many :movies
  has_many :movie_ratings
  has_many :watched_movies
  has_many :movie_to_watches
  has_many :movie_update_requests

  validates :email, :uniqueness => {:case_sensitive => false}, :presence => true

  def rating_for_watched_film(watched_movie)
    movie_rating = movie_ratings.where(:movie => watched_movie.movie).first
    if movie_rating
      movie_rating.rating
    else
      0.0
    end
  end

  def rating_for_film(movie)
    movie_rating = movie_ratings.where(:movie => movie).first
    if movie_rating
      movie_rating.rating
    else
      0.0
    end
  end

  def movie_in_watch_list?(movie)
    watch_list_movie = movie_to_watches.where(:movie => movie).where('date_of_added is not null').first
    if watch_list_movie != nil
      true
    else
      false
    end
  end
end
