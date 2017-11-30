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

	def get_review(review)

		reviewObject = Hash.new

		reviewObject[:content] = review.css('.review-content').first.content.strip

		reviewObject[:rating] = get_ranking_val(review.css('.dealership-rating .hidden-xs.rating-static').first)

		reviewObject[:individualRatings] = create_rating_dict(review.css('.review-ratings-all .tr'))

		reviewObject[:wouldRecommend] = review.css('.review-ratings-all .tr').last.css('div').last.content.strip

		return reviewObject


	end

	def get_reviews(doc)

		reviews = []
		doc.css('.review-entry').each do |review|
			reviews.push(get_review(review))
		end

		return reviews

	end

	def parse()

		# Create a mechanize agent to scrape the web pages
		agent = Mechanize.new

		# get the html
		doc = agent.get("#{@url}")
		
		return get_reviews(doc)

	end

	# private helper functions
	private 
		def get_ranking_val(review)
			if review.key?('class')
				return review['class'][/#{RATING_KW}\-\d\d/]&.split("#{RATING_KW}-").last&.to_i
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