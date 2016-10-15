class MovieUpdateRequestsController < ApplicationController

  def index
    @requests = MovieUpdateRequest.where.not(:request_time => nil).distinct(:movie).paginate(:page => params[:page])
  end

  def update
    @movie_request = MovieUpdateRequest.find(params[:id])
    if @movie_request != nil
      if @movie_request.update_attributes!(params[:movie_update_request].permit(:kinopoisk_link)) && @movie_request.update_attribute(:request_time, DateTime.now)
        redirect_to movie_path(@movie_request.movie), :notice => t('successfull_request_creation')
        return
      else
        redirect_to movie_path(@movie_request.movie), :alert => t('error_while_creating_request')
        return
      end
    else
      redirect_to movie_path(@movie_request.movie), :alert => t('error_while_creating_request')
    end
  end

  def destroy
    @movie_request = MovieUpdateRequest.find(params[:id])
    @movie_request.delete
    redirect_to movie_update_requests_path
  end

  def actualize
    @movie_request = MovieUpdateRequest.find(params[:id])
    kinopoisk_link = @movie_request.kinopoisk_link
    if kinopoisk_link.blank? || !kinopoisk_link.to_s.start_with?('https://www.kinopoisk.ru/film/')
      redirect_to movie_update_requests_path, :alert => 'Error updating request'
    else
      movie = Movie.parse_movie kinopoisk_link
      if movie.nil?
        redirect_to movie_update_requests_path, :alert => 'Error updating movie info'
        return
      end
      movie.id = @movie_request.movie.id
      @movie_request.movie.delete
      backup_movie_attributes = @movie_request.movie.attributes
      if movie.save
        @movie_request.delete
        redirect_to movie_path(movie), :notice => t('movie_successfully_added')
      else
        Movie.create(backup_movie_attributes)
        redirect_to movie_update_requests_path, :alert => "#{movie.errors.to_a}"
      end
    end
  end

end