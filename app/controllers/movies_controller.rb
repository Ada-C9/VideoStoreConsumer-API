class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def create
    # Search for movie in our library:
    @movie = Movie.find_by(title: params[:title])

    if !@movie
      # If movie doesnt already exists in our library:
      @movie = Movie.new(movie_params)
      @movie.inventory = 1
    else
      # If movie already exists:
      @movie.inventory += 1
    end

    if @movie.save
      render status: :ok, json: @movie
    else
      render status: 500, json: { errors: { title: ["Did not save movie to library"] } }
    end
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
      )
    )
  end

  private

  def movie_params
    return params.permit(:title, :overview, :release_date, :image_url, :external_id)
  end

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
