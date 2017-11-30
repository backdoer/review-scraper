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
		"Yes",
		"Test Headline",
		"TestUsername"
	)

	def test_sum_indv_score
		assert_equal(250, @@review.sum_ind_score)
	end

	def test_scores
		assert_instance_of(Float, @@review.contentScore)
		assert_instance_of(Float, @@review.headlineScore)
	end

	def test_emotions
		assert([:positive, :negative, :neutral].include? @@review.contentEmotion )
		assert([:positive, :negative, :neutral].include? @@review.headlineEmotion )
	end

end