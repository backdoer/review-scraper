require 'mechanize'

# Class to scrape reviews from dealerrater 
# =====================================================

class Scraper

	# constants
	BASE_URL = 'https://www.dealerrater.com/dealer'
	RATING_KW = "rating"

	# constructor
	def initialize(dealerId)
		@url = "#{BASE_URL}/#{dealerId}/"
	end

	def parse()

		# Create a mechanize agent to scrape the web pages
		agent = Mechanize.new

		# get the html
		doc = agent.get("#{@url}")

		review = doc.css('.review-entry').first

		reviewContent = review.css('.review-content').first.content

		rankingVal = get_ranking_val(review.css('.dealership-rating .hidden-xs.rating-static').first)

		individualRankings = create_rating_dict(review.css('.review-ratings-all .tr'))

		wouldRecommend = review.css('.review-ratings-all .tr').last.css('div').last.content.strip

		puts reviewContent

		puts rankingVal

		puts individualRankings

		puts wouldRecommend


	end

	# private helper functions
	private
		def get_ranking_val(review)
			if review.key?('class')
				return review['class'][/#{RATING_KW}\-\d\d/]&.split("#{RATING_KW}-").last.to_i
			end

			return nil
		end

		def create_rating_dict (reviews)
			reviewDict = Hash.new

			for i in 0..reviews.length - 2
				details = reviews[i].css('div')
				reviewDict[details.first.content] = get_ranking_val(details.last)
			end

			return reviewDict
		end
end