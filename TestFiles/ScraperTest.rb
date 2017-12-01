require "test/unit"
require_relative "../classes/scraper"
require "mechanize"

# Test Class to test the functionality of the Scraper class
# ==========================================================

class TestScraper < Test::Unit::TestCase

	TEST_FILE_DIR = "file:///Users/tdoermann/Desktop/ReviewScraper/TestFiles/"

	# make sure that the review parser works
	def test_get_review
		review = Scraper.new().send :get_review, Mechanize.new.get("#{TEST_FILE_DIR}TestReview.html")
		review2 = Review.new(
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
			"Above and Beyond",
			"Jrainer1010",

		)
		assert(review.equals_review(review2), 
			"Review parser isn't working")

	end

	# make sure that the DOM of dealerrater is still in the same format
	def test_site_dom
		webReview = Scraper.new().send :get_review, 
		      Mechanize.new.get("#{Scraper::BASE_URL}#{Scraper::DEFAULT_DEALER}")\
		      .css('.review-entry').first

		assert_not_nil(webReview.reviewContent, 
			"Review Content isn't being pulled correctly from DealerRater")
		assert_not_nil(Fixnum, 
			"Rating value isn't being pulled corretly from DealerRater")
		assert_equal(5, webReview.individualRatings.keys.length, 
			"The 5 individual ratings aren't being pulled correctly from DealerRater")
		assert_instance_of(String, webReview.wouldRecommend, 
			"The 'Recommend Dealer' value isn't being pulled correctly from DealerRater")
	end

	# make sure that get_reviews is pulling 10 review from the test site
	def test_get_reviews
		reviews = Scraper.new().send :get_reviews, Mechanize.new.get("#{TEST_FILE_DIR}TestSite.html")
		assert_equal(10, reviews.count,
			"The get_reviews method isn't pulling in the expected amount of reviews")
	end

	def test_parse

		# make sure page validation works
		exception = assert_raise(ArgumentError) {Scraper.new().parse("a")}
		assert_equal(Scraper::IS_NUMERIC_ERROR, exception.message,
			"Error wasn't caught of pages not being numeric")

		exception = assert_raise(ArgumentError) {Scraper.new().parse(1, 0)}
		assert_equal(Scraper::PAGES_ORDER_ERROR, exception.message, 
			"Error wasn't caught of pages being in wrong order")

		exception = assert_raise(ArgumentError) {Scraper.new().parse(-3, -1)}
		assert_equal(Scraper::PAGES_GRTH_0_ERROR, exception.message,
			"Error wasn't caught of pages not being greater than 0")

		# make sure navigation across multiple pages works
		assert_equal(20, Scraper.new().parse(1, 2).count, 
			"Unexpected number of reviews returned while navigating DealerRater pages.")
	end

end
