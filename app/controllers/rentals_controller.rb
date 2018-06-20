class RentalsController < ApplicationController
  before_action :require_movie, only: [:check_out, :check_in]
  before_action :require_customer, only: [:check_out, :check_in]

  # TODO: make sure that wave 2 works all the way
  def check_out
    rental = Rental.new(movie: @movie, customer: @customer, due_date: params[:due_date])

    if rental.save
      render status: :ok, json: {}
    else
      render status: :bad_request, json: { errors: rental.errors.messages }
    end
  end

  def check_in
    rental = Rental.find_by(movie: @movie, customer: @customer, returned: nil)
    unless rental
      return render status: :not_found, json: {
        errors: {
          rental: ["#{@customer.name} does not have #{@movie.title} checked out"]
        }
      }
    end
    rental.returned = true
    if rental.save
      render status: :ok, json: {}
    else
      render status: :bad_request, json: { errors: rental.errors.messages }
    end
  end

  def overdue
    rentals = Rental.overdue.map do |rental|
      {
          title: rental.movie.title,
          customer_id: rental.customer_id,
          name: rental.customer.name,
          postal_code: rental.customer.postal_code,
          checkout_date: rental.checkout_date,
          due_date: rental.due_date
      }
    end
    render status: :ok, json: rentals
  end

private
  # TODO: make error payloads arrays
  def require_movie
    @movie = Movie.find_by title: params[:title]
    unless @movie
      render status: :not_found, json: { errors: { rental: ["Movie not found"] } }
    end
  end

  def require_customer
    @customer = Customer.find_by id: params[:customer_id]
    unless @customer
      render status: :not_found, json: { errors: { rental: ["Customer not found"] } }
    end
  end
end
