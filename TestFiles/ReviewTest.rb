require "test/unit"
require_relative "../classes/review"

# Test Class to test the functionality of the Review class
# ==========================================================

# helper method for testing
def create_ruby_object
  Review.new(
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
end

class TestReview < Test::Unit::TestCase

  # create a review instance to test with
  @@review = create_ruby_object()

  # make sure the sum function for individual ratings works
  def test_sum_indv_score
    assert_equal(Review::SUM_IND_SCORE_MAX, @@review.sumIndScore,
		 "Rating sum function isn't working")
  end

  # make sure the sentiment analysis library is giving back a float score for sentiment
  def test_scores
    assert_instance_of(Float, @@review.contentScore,
		       "Sentimental review score isn't returning a float")
  end

  # make sure the sentiment analysis library is giving back one of the expected emotions
  def test_emotions
    assert(Review::POSSIBLE_SENTIMENTS.include?(@@review.contentEmotion),
	   "Sentimental isn't returning an expected emotion" )
  end

  # make sure the review eqality function works
  def test_equals_review
    assert(@@review.equals_review(create_ruby_object()),
	   "Review comparison method isn't working")
  end

end
