require "test/unit"
require_relative "../classes/review"

# Test Class to test the functionality of the Review class
# ==========================================================

class TestReview < Test::Unit::TestCase

	# create a review instance to test with
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

	# make sure the sum function for individual ratings works
	def test_sum_indv_score
		assert_equal(Review::SUM_IND_SCORE_MAX, @@review.sumIndScore)
	end

	# make sure the sentiment analysis library is giving back a float score for sentiment
	def test_scores
		assert_instance_of(Float, @@review.contentScore)
		assert_instance_of(Float, @@review.headlineScore)
	end

	# make sure the sentiment analysis library is giving back one of the expected emotions
	def test_emotions
		assert(Review::POSSIBLE_SENTIMENTS.include? @@review.contentEmotion )
		assert(Review::POSSIBLE_SENTIMENTS.include? @@review.headlineEmotion )
	end

end