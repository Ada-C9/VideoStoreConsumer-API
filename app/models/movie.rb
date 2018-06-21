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
    if !orig_value
      MovieWrapper::DEFAULT_IMG_URL
    elsif external_id
      MovieWrapper.construct_image_url(orig_value)
    else
      orig_value
    end
  end

  private
  # def exists?
  #   if Movie.find_by(external_id: self.external_id)
  #     return render status: :bad_request, json: {
  #       errors: {
  #         rental: ["#{params[:title]} is already in the library"]
  #       }
  #     }
  #   end
  # end
end
