class Customer < ApplicationRecord
  has_many :rentals
  has_many :movies, through: :rentals

  def movies_checked_out_count
    self.rentals.where(returned: false).length
  end

  def registration_date
    self.registered_at.strftime("%B %d, %Y")
  end
end
