require "test/unit"
require_relative "../Classes/review"

class TestReview < Test::Unit::TestCase

	@@review = Review.new(
		"Test Html",
		Review::IND_SCORE_MAX, 
		{
			"Customer Service"=>Review::IND_SCORE_MAX, 
			"Quality of Work"=>Review::IND_SCORE_MAX, 
			"Friendliness"=>Review::IND_SCORE_MAX, 
			"Pricing"=>Review::IND_SCORE_MAX, 
			"Overall Experience"=>Review::IND_SCORE_MAX
		},
		Review::RECOMMEND_VALUE,
		"Test Headline",
		"TestUsername"
	)

	def test_sum_indv_score
		assert_equal(Review::SUM_IND_SCORE_MAX, @@review.sum_ind_score)
	end

	def test_scores
		assert_instance_of(Float, @@review.contentScore)
		assert_instance_of(Float, @@review.headlineScore)
	end

	def test_emotions
		assert(Review::POSSIBLE_SENTIMENTS.include? @@review.contentEmotion )
		assert(Review::POSSIBLE_SENTIMENTS.include? @@review.headlineEmotion )
	end

end