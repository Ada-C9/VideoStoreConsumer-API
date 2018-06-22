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
    elsif external_id && !url_valid?(orig_value)
      MovieWrapper.construct_image_url(orig_value)
    else
      orig_value
    end
  end
  
private
  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end
end
