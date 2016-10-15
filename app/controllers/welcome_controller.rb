class WelcomeController < ApplicationController
  def index
    @latest_movies = Movie.order(:add_date => 'DESC').limit(3)
  end
end