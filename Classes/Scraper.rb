require 'mechanize'
require_relative 'review'

# Class to scrape reviews from dealerrater 
# =====================================================

class Scraper

	# constants
	BASE_URL = 'https://www.dealerrater.com/dealer/'
	RATING_KW = "rating"
	DEFAULT_DEALER = "McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"

	# error messages
	IS_NUMERIC_ERROR = "The starting and ending pages must be numbers"
	PAGES_ORDER_ERROR = "The starting page must be less than the ending page"
	PAGES_GRTH_0_ERROR = "The starting and ending pages must be greather than 0"
	

	# constructor
	def initialize(dealerId = DEFAULT_DEALER)
		@url = "#{BASE_URL}/#{dealerId}/page"
	end

	# parse method to go through pages and grab reviews
	# return array of all review objects across specified pages
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

	# create a review object out of an html element
	# return review object
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

	# go through all review elements and create objects
	# return array of review objects
	def get_reviews(doc)

		reviews = []
		doc.css('.review-entry').each do |review|
			reviews.push(get_review(review))
		end

		return reviews

	end

	# take a string of class values and find the one matching the pattern rating-\d\d
	# return the value of the digits if one is found
	def get_ranking_val(review)
		if review.key?('class')
			return review['class'][/#{RATING_KW}\-\d\d/]&.split("#{RATING_KW}-").last&.to_i
		end

		return nil
	end

	# take a series of individual rating elements and pull rating for each category
	# return hash of ratings
	def create_rating_dict (reviews)
		reviewDict = Hash.new

		for i in 0..reviews.length - 2
			details = reviews[i].css('div')
			reviewDict[details.first.content] = get_ranking_val(details.last)
		end

		return reviewDict
	end

	# check whether a value is an int or is a numeric string
	# return whether or not the number is numeric
	def is_numeric(val)
		return Integer(val).is_a? Integer rescue false
	end

	# take a starting page and ending page and do a series of validation 
	# void 
	def validate_pages(startingPage, endingPage)
		# validate
		if not is_numeric(startingPage) or not is_numeric(endingPage)
			raise ArgumentError.new(IS_NUMERIC_ERROR)
		end

		if startingPage > endingPage
			raise ArgumentError.new(PAGES_ORDER_ERROR)
		end

		if startingPage < 0 or endingPage < 0
			raise ArgumentError.new(PAGES_GRTH_0_ERROR)
		end
	end
end