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

  def add_movie
    #pass in new_movie from params...somehow..its an object
    @new_movie = Movie.new()
    @new_movie.title = params[:title]
    @new_movie.overview = params[:overview]
    @new_movie.release_date = params[:release_date]
    @new_movie.image_url = params[:image_url]
    @new_movie.external_id = params[:external_id]

    if Movie.find_by(external_id: params[:external_id])
      render(
        status: :bad_request, json: { errors: "already in movie library" }
      )
    else
      if @new_movie.save
        render(
          status: :ok,
          json: @new_movie.as_json(
            # also can return external_id and then have the front end do an api call again
            only: [:title, :overview]
          )
        )
      else
        render status: :bad_request, json: { errors: rental.errors.messages }
      end
    end
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
