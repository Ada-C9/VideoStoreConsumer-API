require 'date'

class CustomersController < ApplicationController
  SORT_FIELDS = %w(name registered_at postal_code)

  before_action :parse_query_args

  def index
    if @sort
      data = Customer.all.order(@sort)
    else
      data = Customer.all
    end

    # data = data.paginate(page: params[:p], per_page: params[:n])

    render json: data.as_json(
      only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone, :account_credit],
      methods: [:movies_checked_out_count]
    )
  end

  def show
    data = Customer.find_by(id: params[:id])

    render json: data.as_json(
      only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone, :account_credit],
      methods: [:movies_checked_out_count]
    )
  end

  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer.as_json(
        only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone, :account_credit],
        methods: [:movies_checked_out_count]
      ), status: :ok
    else
      render status: :bad_request
    end
  end

  def update
    customer = Customer.find_by(id: params[:id])

    customer.assign_attributes(customer_params)

    if customer.save
      render json: customer.as_json(
        only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone, :account_credit],
        methods: [:movies_checked_out_count]
      ), status: :ok
    else
      render status: :bad_request
    end

  end

  def destroy
    if Customer.delete(params[:id])
      render status: :ok
    else
      render status: :bad_request
    end
  end

private

  def customer_params
    return params.permit(:name, :address, :city, :state, :postal_code, :phone, :account_credit)
  end

  def parse_query_args
    errors = {}
    @sort = params[:sort]
    if @sort and not SORT_FIELDS.include? @sort
      errors[:sort] = ["Invalid sort field '#{@sort}'"]
    end

    unless errors.empty?
      render status: :bad_request, json: { errors: errors }
    end
  end
end
