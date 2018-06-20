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
    puts "we made it"
    puts "params below"

    movie = Movie.new(title: params["title"], overview: params["overview"], release_date: params["release_date"], image_url: params["image_url"])
    movie.save

    puts "movie"
    puts movie.inspect

  end

  private

  # def movie_params
  #   return params.permit(title: params["title"], overview: params["overview"], release_date: params["release_date"], image_url: params["image_url"])
  # end

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
