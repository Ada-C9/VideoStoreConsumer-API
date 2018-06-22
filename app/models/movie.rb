class Movie < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals
  validates :title, uniqueness: true
  # validates :overview, uniqueness: { scope: :title }

  def available_inventory
    return 0 if self.inventory.nil?
    self.inventory - Rental.where(movie: self, returned: [false, nil]).length
  end

  def image_url
    orig_value = read_attribute :image_url
    if !orig_value
      MovieWrapper::DEFAULT_IMG_URL
    elsif external_id
      MovieWrapper.construct_image_url(orig_value)
    else
      orig_value
    end
  end
end
