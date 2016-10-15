class UsersController < ApplicationController
  def index
    @users = User.paginate(:page => params[:page])
  end

  def edit
    unless signed_in?
      redirect_to users_path, :alert => "You should be logged in to edit user"
    end
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @watched_movies = @user.watched_movies.paginate :per_page => 10, :page => params[:watched_page]
    @movies_to_watch = @user.movie_to_watches.where('date_of_added is not null').paginate :per_page => 10, :page => params[:to_watch_page]
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user, :notice => 'Профиль успешно обновлен'
    else
      redirect_to edit_user_path(@user), :alert => @user.errors
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name)
  end
end