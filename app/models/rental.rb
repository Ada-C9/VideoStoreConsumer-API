class RentalValidator < ActiveModel::Validator

  def validate(record)

    if duplicate_rental(record)
      record.errors.add(:base, "Customer has not returned this movie yet.")
    end

    if no_availability(record)
      record.errors.add(:base, "No copies of this movie are currently available")
    end

  end

  private

  def duplicate_rental(record)
    active_previous_rental = Rental.find_by(customer_id: record.customer_id, movie_id: record.movie_id, returned: nil)
    return active_previous_rental
  end

  def no_availability(record)
    return record.movie.available_inventory == 0
  end

end


####################################################################


class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer

  # validates :movie, uniqueness: { scope: :customer }
  validates :due_date, presence: true
  validate :due_date_in_future, on: :create
  validates_with RentalValidator, on: :create

  after_initialize :set_checkout_date
  after_initialize :set_due_date

  # def self.first_outstanding(movie, customer)
  #   self.where(movie: movie, customer: customer, returned: false).order(:due_date).first
  # end

  def self.overdue
    self.where(returned: false).where("due_date < ?", Date.today)
  end

private
  def due_date_in_future
    return unless self.due_date
    unless due_date > Date.today
      errors.add(:due_date, "Must be in the future")
    end
  end

  def set_checkout_date
    self.checkout_date ||= Date.today
  end

  def set_due_date
    self.due_date ||= self.checkout_date + 7
  end
end
