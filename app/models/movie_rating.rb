class MovieRating < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user
  validates :rating, :numericality => {:greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0}
end