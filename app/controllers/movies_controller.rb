class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @hilite = 'hilite'
    @all_ratings = Movie.ratings

    if params[:commit] then
      @ratings = params[:ratings]
      @sort_key = params[:sort_key]
      if @ratings
        session[:ratings] = @ratings
      else
        @ratings = session[:ratings]
        @sort_key = session[:sort_key]
        redirect = true
      end
    else
      @sort_key = params[:sort_key] || session[:sort_key]
      @ratings = params[:ratings]
      if !@ratings then
        if session[:ratings] then
          redirect = true
          @ratings = session[:ratings]
        else
          @ratings = {}
        end
      else
        session[:ratings] = @ratings
      end
    end 

    if session[:sort_key] != @sort_key then
      redirect = true
      session[:sort_key] = @sort_key
    end
    
    if redirect then
      flash.keep
      redirect_to movies_path(:sort_key => @sort_key, :ratings => @ratings)
      return
    end   
	
    if params[:ratings]
      @ratings = params[:ratings].keys
      @movies = Movie.order(params[:sort_key]).find_all_by_rating(@ratings)
    else
      @movies = Movie.order(params[:sort_key]).find_all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
