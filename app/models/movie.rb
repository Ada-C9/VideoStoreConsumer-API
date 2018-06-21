class Movie < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals
  validates :external_id, uniqueness: true
  # validate :exists?, on: :create

  def available_inventory
    self.inventory - Rental.where(movie: self, returned: false).length
  end

  def image_url
    orig_value = read_attribute :image_url
    puts "image_url method orig_value: #{orig_value}"
    if !orig_value
      MovieWrapper::DEFAULT_IMG_URL
    elsif external_id && (orig_value[0] != "h")
      MovieWrapper.construct_image_url(orig_value)
    else
      orig_value
    end
  end
end
