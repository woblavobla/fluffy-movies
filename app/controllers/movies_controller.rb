require 'will_paginate'
require 'will_paginate/active_record'
require 'net/http'
require 'net/https'
class MoviesController < ApplicationController
  def index
    @movie = Movie.find(1)
    if params[:search]
      @movies = Movie.search(params[:search]).order(:add_date => :desc).paginate(:page => params[:page])
    else
      @movies = Movie.order(:add_date => :desc).paginate(:page => params[:page])
    end
  end

  def show
    @movie = Movie.find(params[:id].to_i)
    if signed_in?
      @movie_rating = @movie.movie_ratings.where(:user => current_user).first
      if @movie_rating == nil
        @movie_rating = @movie.movie_ratings.create(:user => current_user, :rating => 0.0)
      end
      @movie_to_watch = current_user.movie_to_watches.where(:movie => @movie).first
      if @movie_to_watch == nil
        @movie_to_watch = current_user.movie_to_watches.create(:movie => @movie)
      end
      @movie_upd_req = @movie.movie_update_requests.where(:user => current_user).first
      if @movie_upd_req == nil
        @movie_upd_req = @movie.movie_update_requests.create(:user => current_user)
      end
    end
  end

  def new
    @movie = Movie.new
    @kino = Movie.first
  end

  def create
    @movie = Movie.new(params[:movie].permit(:name, :year, :description))
    if @movie.save
      redirect_to @movie, :notice => t('movie_successfully_added')
    else
      flash[:error] = "#{@movie.errors.to_a}"
      redirect_to new_movie_path(@user)
    end
  end

  def add_from_kinopoisk
    kinopoisk_link = params.require(:movie)[:kinopoisk_url]
    if kinopoisk_link.blank? || !kinopoisk_link.to_s.start_with?('https://www.kinopoisk.ru/film/')
      redirect_to movies_path, :alert => 'Error while adding movie from kinopoisk'
    else
      movie = Movie.parse_movie kinopoisk_link
      if movie.nil?
        redirect_to movies_path, :alert => t('error_adding_from_kinopoisk')
        return
      end
      if Movie.exists?(movie)
        redirect_to movie_path(movie)
      else
        if movie.save
          redirect_to movie_path(movie), :notice => t('movie_successfully_added')
        else
          redirect_to movies_path, :alert => "#{movie.errors.to_a}"
        end
      end
    end
  end
end