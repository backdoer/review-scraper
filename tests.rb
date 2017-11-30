require "test/unit"
require "./scraper"
require "mechanize"

class TestScraper < Test::Unit::TestCase

	TEST_FILE_DIR = "file:///Users/tdoermann/Desktop/ReviewScraper/TestSites/"

	# make sure that the review parser still works
	def test_get_review
		assert_equal(
			{
				:content=>"Test Html", 
				:rating=>50, 
				:individualRatings=>
					{
						"Customer Service"=>50, 
						"Quality of Work"=>50, 
						"Friendliness"=>50, 
						"Pricing"=>50, 
						"Overall Experience"=>50
					}, 
				:wouldRecommend=>"Yes"
			},

			Scraper.new("").get_review(Mechanize.new.get("#{TEST_FILE_DIR}testReview.html"))
			
		)
	end

	# make sure that the review parser can get all the reviews from a page
	def test_get_reviews
		assert_equal(
			[
				{:content=>"A rare commodity! Friendly,  polite and honest. When he ask me how can I help you; I gave him what I was looking for and the price rang he said I think I have something you are looking for. He took me to  exactly what I wanted and spent time showing me how all the new  gadgets worked .", :rating=>50, :individualRatings=>{"Customer Service"=>0, "Quality of Work"=>0, "Friendliness"=>0, "Pricing"=>0, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"Jason and the team were so helpful. I was in a death trap of a car with minimal value and now I'm in a Gorgeous Bright Red Chevy! Couldn't have been any better. They were all so polite and professional. Thank you for such a wonderful experience and car!! Will recommend and return if I ever need another vehicle!", :rating=>50, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>50, "Friendliness"=>50, "Pricing"=>50, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"Adrian and the team went above and beyond to get me into an amazing car. I will be using them again in the future and highly recommend them for anyone looking to have an honest experience with a car dealership.", :rating=>50, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>50, "Friendliness"=>50, "Pricing"=>50, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"Everyone that has sonething to do with this place and my purchase has am A+ such caring and wonderful people I am grateful and most thankful for everything", :rating=>50, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>50, "Friendliness"=>50, "Pricing"=>50, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"This is my first time getting a vehicle out at Mckaig Chevrolet and I was pleased! I had a great experience, help, and got me into a vehicle I LOVE all thanks to Adrian Cortes on which he meet all my needs ! I had definitely a lot of questions and he answered every single one!! I couldn’t be anymore happier! Overall great experience! Thanks to Adrian Cortes!!", :rating=>50, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>50, "Friendliness"=>50, "Pricing"=>50, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"People were awsome to be with! Was very happy with the truck and all the extra effort they went through to get us financed and into our truck! Thank you!", :rating=>50, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>50, "Friendliness"=>50, "Pricing"=>50, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"My visit here was in and out with a new car. Can say your visit will depend on your situation. But They have nice cars and the sales team are the best part about this dealership. They help you get into a vehicle based on YOUR needs.", :rating=>46, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>50, "Friendliness"=>50, "Pricing"=>40, "Overall Experience"=>40}, :wouldRecommend=>"Yes"},
				{:content=>"McKaig makes buying a new vehicle painless.  Summur contacted us after we were viewing online.  She put us with Jason. He showed us all the ins and outstanding details.  After we made the deal, Sabrina made the final signing quick and easy.", :rating=>50, :individualRatings=>{"Customer Service"=>0, "Quality of Work"=>0, "Friendliness"=>50, "Pricing"=>0, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"Charles was fantastic in getting us into our Buick Enclave quickly and without hassle. He went above and beyond to make sure we were comfortable and happy. We are so thankful!", :rating=>50, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>50, "Friendliness"=>50, "Pricing"=>50, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
				{:content=>"This is the smoothest car buying i've ever had hassle free! Thank you Charles P. Jeriamy S. and Sabrina P. I met Mark A:)", :rating=>46, :individualRatings=>{"Customer Service"=>50, "Quality of Work"=>40, "Friendliness"=>50, "Pricing"=>40, "Overall Experience"=>50}, :wouldRecommend=>"Yes"},
			],

			Scraper.new("").get_reviews(Mechanize.new.get("#{TEST_FILE_DIR}testSite.html"))
		)

	end

	# make sure page validation works
	def test_validate_pages
		exception = assert_raise(ArgumentError) {Scraper.new("").validate_pages(1, 0)}
		assert_equal("The starting page must be less than the ending page", exception.message)

		exception = assert_raise(ArgumentError) {Scraper.new("").validate_pages(-3, -1)}
		assert_equal("The starting and ending pages must be greather than 0", exception.message)
		
	end



end
