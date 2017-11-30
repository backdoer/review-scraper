require "test/unit"
require "./review"

class TestReview < Test::Unit::TestCase

	@@review = Review.new(
		"Test Html",
		50, 
		{
			"Customer Service"=>50, 
			"Quality of Work"=>50, 
			"Friendliness"=>50, 
			"Pricing"=>50, 
			"Overall Experience"=>50
		},
		"Yes"
	)

	def test_sum_indv_score
		assert_equal(250, @@review.sum_ind_score)
	end

	def test_polarity
		assert_instance_of(Float, @@review.polarity)
	end

	def test_emotion
		assert([:positive, :negative, :neutral].include? @@review.emotion )
	end

end