require "test/unit"
require "./scraper"
require "mechanize"

class TestScraper < Test::Unit::TestCase

	TEST_FILE_DIR = "file:///Users/tdoermann/Desktop/ReviewScraper/TestFiles/"
	TEST_WEB_URL = "https://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"

	# make sure that the review parser still works
	def test_get_review
		review = Scraper.new("").get_review(Mechanize.new.get("#{TEST_FILE_DIR}testReview.html"))
		review2 = Review.new(
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
		assert(review.equals_review(review2), "Review parser isn't working")

	end

	# make sure that the DOM of dealerrater is still in the same format
	def test_site_dom
		webReview = Scraper.new("").get_review(Mechanize.new.get(TEST_WEB_URL).css('.review-entry').first)
		assert_not_nil(webReview.reviewContent)
		assert_not_nil(Fixnum)
		assert_equal(5, webReview.individualRatings.keys.length)
		assert_instance_of(String, webReview.wouldRecommend)
	end

	# make sure that get_reviews is pulling 10 review from the test site
	def test_get_reviews
		reviews = Scraper.new("").get_reviews(Mechanize.new.get("#{TEST_FILE_DIR}testSite.html"))
		assert_equal(10, reviews.count)
	end

	def test_parse

		# make sure page validation works
		exception = assert_raise(ArgumentError) {Scraper.new("").parse("a")}
		assert_equal("The starting and ending pages must be numbers", exception.message)

		exception = assert_raise(ArgumentError) {Scraper.new("").parse(1, 0)}
		assert_equal("The starting page must be less than the ending page", exception.message)

		exception = assert_raise(ArgumentError) {Scraper.new("").parse(-3, -1)}
		assert_equal("The starting and ending pages must be greather than 0", exception.message)

		# make sure going across multiple pages works
		assert_equal(20, Scraper.new("McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685").parse(1, 2).count)
	end

end
