class MoviesController < ApplicationController

  def show
    session[:prev] = true
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
# will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    sort_type = params[:sort] || session[:sort]
    if sort_type == 'title'
      ordering, @title_header = {:order => :title}, 'hilite'
    elsif sort_type == 'release_date'
      ordering, @date_header = {:order => :release_date}, 'hilite'
    end

    @all_ratings = Movie.all_ratings
    @checked_ratings = params[:ratings] || session[:ratings] || {}

    if session[:sort] != params[:sort]
      session[:sort] = sort_type
      redirect_to :sort => sort_type, :ratings => @checked_ratings and return
    end

    if params[:ratings] != session[:ratings] && @checked_ratings != {}
      session[:sort] == sort_type
      session[:ratings] = @checked_ratings
      redirect_to :sort => sort_type, :ratings => @checked_ratings and return
    end

    @movies = Movie.find_all_by_rating(@checked_ratings.keys, ordering)
  end

  def new
    # default: render 'new' template
  end

  def create
    session[:prev] = true
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    session[:prev] = true
    @movie = Movie.find params[:id]
  end

  def update
    session[:prev] = true
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    session[:prev] = true
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
