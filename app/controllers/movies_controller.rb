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

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
      )
    )
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.inventory = rand(0..10)

    if @movie.save
      render(
        status: :ok,
        json: @movie.as_json(
          only: [:title, :overview, :release_date, :inventory],
          methods: [:available_inventory]
        )
      )

    else
      render(
        status: :bad_request,
        json: {
          errors: {
            movie: ["Movie #{@movie.title} could not be added to our database."]
          }
        }
      )

    end
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end

  def movie_params
    return params.permit(:title, :overview, :release_date, :image_url, :external_id)

  end
end
