require 'mechanize'
require './review'

# Class to scrape reviews from dealerrater 
# =====================================================

class Scraper

	# constants
	BASE_URL = 'https://www.dealerrater.com/dealer'
	RATING_KW = "rating"

	# constructor
	def initialize(dealerId)
		@url = "#{BASE_URL}/#{dealerId}/page"
	end

	def get_review(review)

		reviewObject = Review.new(
			review.css('.review-content').first&.content.strip,
			get_ranking_val(review.css('.dealership-rating .hidden-xs.rating-static').first),
			create_rating_dict(review.css('.review-ratings-all .tr')),
			review.css('.review-ratings-all .tr').last.css('div').last.content.strip,
			review.css('.review-wrapper div h3').first.content.tr("\"", "").strip,
			review.css('.review-wrapper div span').first.content.tr("-", "").strip
		)

		return reviewObject


	end

	def get_reviews(doc)

		reviews = []
		doc.css('.review-entry').each do |review|
			reviews.push(get_review(review))
		end

		return reviews

	end

	def parse(startingPage, endingPage = nil)
		# handle missing endingPage
		if !endingPage
			endingPage = startingPage
		end

		validate_pages(startingPage, endingPage)

		# Create a mechanize agent to scrape the web pages
		agent = Mechanize.new

		# get the html
		doc = agent.get("#{@url}#{startingPage}")

		reviews = []

		anotherPage = true

		while anotherPage

			reviews += get_reviews(doc)

			if startingPage < endingPage
				startingPage += 1
				doc = agent.get("#{@url}#{startingPage}")
			else
				anotherPage = false
			end
			
		end

		return reviews

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

	def is_numeric(val)
		return Integer(val) rescue false
	end

	def validate_pages(startingPage, endingPage)
		# validate
		if not is_numeric(startingPage) or not is_numeric(endingPage)
			raise ArgumentError.new("The starting and ending pages must be numbers")
		end

		if startingPage > endingPage
			raise ArgumentError.new("The starting page must be less than the ending page")
		end

		if startingPage < 0 or endingPage < 0
			raise ArgumentError.new("The starting and ending pages must be greather than 0")
		end
	end
end