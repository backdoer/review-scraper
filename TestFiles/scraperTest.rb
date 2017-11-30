require "test/unit"
require_relative "../Classes/scraper"
require "mechanize"

class TestScraper < Test::Unit::TestCase

	TEST_FILE_DIR = "file:///Users/tdoermann/Desktop/ReviewScraper/TestFiles/"

	# make sure that the review parser works
	def test_get_review
		review = Scraper.new().send :get_review, Mechanize.new.get("#{TEST_FILE_DIR}testReview.html")
		review2 = Review.new(
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
			"Above and Beyond",
			"Jrainer1010",

		)
		assert(review.equals_review(review2), "Review parser isn't working")

	end

	# make sure that the DOM of dealerrater is still in the same format
	def test_site_dom
		webReview = Scraper.new().send :get_review, Mechanize.new.get("#{Scraper::BASE_URL}#{Scraper::DEFAULT_DEALER}").css('.review-entry').first
		assert_not_nil(webReview.reviewContent)
		assert_not_nil(Fixnum)
		assert_equal(5, webReview.individualRatings.keys.length)
		assert_instance_of(String, webReview.wouldRecommend)
	end

	# make sure that get_reviews is pulling 10 review from the test site
	def test_get_reviews
		reviews = Scraper.new().send :get_reviews, Mechanize.new.get("#{TEST_FILE_DIR}testSite.html")
		assert_equal(10, reviews.count)
	end

	def test_parse

		# make sure page validation works
		exception = assert_raise(ArgumentError) {Scraper.new().parse("a")}
		assert_equal(Scraper::IS_NUMERIC_ERROR, exception.message)

		exception = assert_raise(ArgumentError) {Scraper.new().parse(1, 0)}
		assert_equal(Scraper::PAGES_ORDER_ERROR, exception.message)

		exception = assert_raise(ArgumentError) {Scraper.new().parse(-3, -1)}
		assert_equal(Scraper::PAGES_GRTH_0_ERROR, exception.message)

		# make sure going across multiple pages works
		assert_equal(20, Scraper.new().parse(1, 2).count)
	end

end
