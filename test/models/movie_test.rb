require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  let (:movie_data) {
    {
      "title": "Hidden Figures",
      "overview": "Some text",
      "release_date": "1960-06-16",
      "inventory": 8
    }
  }

  before do
    @movie = Movie.new(movie_data)
  end

  describe "Constructor" do
    it "Can be created" do
      Movie.create!(title: "Dumbo", external_id: 900)
    end

    it "Has rentals" do
      @movie.must_respond_to :rentals
    end

    it "Has customers" do
      @movie.must_respond_to :customers
    end
  end

  describe "available_inventory" do
    it "Matches inventory if the movie isn't checked out" do
      # Make sure no movies are checked out
      Rental.destroy_all
      Movie.all.each do |movie|
        movie.available_inventory().must_equal movie.inventory
      end
    end

    it "Decreases when a movie is checked out" do
      Rental.destroy_all

      movie = movies(:one)
      before_ai = movie.available_inventory

      Rental.create!(
        customer: customers(:one),
        movie: movie,
        due_date: Date.today + 7,
        returned: nil
      )

      movie.reload
      after_ai = movie.available_inventory
      after_ai.must_equal before_ai - 1
    end

    it "Increases when a movie is checked in" do
      Rental.destroy_all

      movie = movies(:one)

      rental =Rental.create!(
        customer: customers(:one),
        movie: movie,
        due_date: Date.today + 7,
        returned: nil
      )

      movie.reload
      before_ai = movie.available_inventory

      rental.returned = true
      rental.save!

      movie.reload
      after_ai = movie.available_inventory
      after_ai.must_equal before_ai + 1
    end
  end

  describe "validations" do
    it "cannot be created without a title" do
      old_count = Movie.count
      movie = Movie.new
      movie.valid?.must_equal false

      movie.save
      movie.errors.messages.must_include :title

      Movie.count.must_equal old_count
    end

    it "can successfully be created with title" do
      title = "some title"
      old_count = Movie.count
      movie = Movie.new(title: "300", external_id: 867)
      movie.valid?.must_equal true

      movie.save

      Movie.count.must_equal old_count + 1
    end

    it "cannot be created with duplicate external id" do
      reused_id = 123
      Movie.create!(title: "something", external_id: reused_id)
      old_count = Movie.count

      new_movie = Movie.new(title: "whatever", external_id: reused_id)
      new_movie.valid?.must_equal false
      new_movie.save
      new_movie.errors.messages.must_include :external_id
      Movie.count.must_equal old_count
    end
  end
end
