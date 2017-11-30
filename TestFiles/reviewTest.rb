require "test/unit"
require_relative "../Classes/review"

# Test Class to test the functionality of the Review class
# ==========================================================

class TestReview < Test::Unit::TestCase

	@@review = Review.new(
		"Test Html",
		Review::IND_SCORE_MAX, 
		{
			Review::IND_RATING_HEADINGS[:customerService]=>Review::IND_SCORE_MAX, 
			Review::IND_RATING_HEADINGS[:qualityOfWork]=>Review::IND_SCORE_MAX, 
			Review::IND_RATING_HEADINGS[:friendliness]=>Review::IND_SCORE_MAX, 
			Review::IND_RATING_HEADINGS[:pricing]=>Review::IND_SCORE_MAX, 
			Review::IND_RATING_HEADINGS[:overallExperience]=>Review::IND_SCORE_MAX
		},
		Review::RECOMMEND_VALUE,
		"Test Headline",
		"TestUsername"
	)

	def test_sum_indv_score
		assert_equal(Review::SUM_IND_SCORE_MAX, @@review.sumIndScore)
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