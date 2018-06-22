class Customer < ApplicationRecord
  has_many :rentals
  has_many :movies, through: :rentals

  def movies_checked_out_count
    # self.rentals.where(returned: 0).length
    self.rentals.to_a.select { |rental| rental.returned.nil? }.length
  end
end
