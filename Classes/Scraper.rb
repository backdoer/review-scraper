require 'mechanize'
require_relative 'review'

# Class to scrape reviews from dealerrater 
# =====================================================

class Scraper

	# constants
	BASE_URL = 'https://www.dealerrater.com/dealer/'
	RATING_KW = "rating"
	CLASS_KW = "class"
	DEFAULT_DEALER = "McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"

	# error messages used in validation
	IS_NUMERIC_ERROR = "The starting and ending pages must be numbers"
	PAGES_ORDER_ERROR = "The starting page must be less than the ending page"
	PAGES_GRTH_0_ERROR = "The starting and ending pages must be greather than 0"
	NOT_FOUND_ERROR = "could not be found. Are you sure you specified a valid Dealer Id?"

	# DOM constants and locations
	REVIEW_CONTENT = ".review-content"
	DEALERSHIP_RATING = ".dealership-rating .hidden-xs.rating-static"
	RATINGS_ALL = ".review-ratings-all .tr"
	REVIEW_WRAPPER = ".review-wrapper div"
	REVIEW_ENTRY = ".review-entry"

	# constructor
	def initialize(dealerId = DEFAULT_DEALER)
		@url = "#{BASE_URL}#{dealerId}/page"
	end

	# parse method to go through pages and grab reviews
	# return array of all review objects across specified pages
	def parse(startingPage, endingPage = nil)
		# handle missing endingPage
		endingPage = endingPage.nil? ? startingPage : endingPage

		validate_pages(startingPage, endingPage)

		# get the html
		#doc = agent.get("#{@url}#{startingPage}")
		doc = get_page("#{@url}#{startingPage}")

		# array of reviews to be held across all pages
		reviews = []

		anotherPage = true

		# Go through each page and add review objects to the reviews array
		while anotherPage

			reviews += get_reviews(doc)

			if startingPage < endingPage
				startingPage += 1
				doc = get_page("#{@url}#{startingPage}")
			else
				anotherPage = false
			end
			
		end

		return reviews
	end

	# private helper functions
	private 

	# get a page 
	def get_page(url)
		begin
		  if not defined? agent
		  	agent = Mechanize.new
		  end

		  return agent.get(url)

		rescue Mechanize::ResponseCodeError => e

		  # if page couldn't be found, throw an error
		  if e.response_code == "404"
		  	raise ArgumentError.new(
		  		"#{@url} #{NOT_FOUND_ERROR}"
		  		)
		  else
		  	throw
		  end 

		end
	end

	# create a review object out of an html element
	# return review object
	def get_review(review)

		reviewObject = Review.new(
			review.css(REVIEW_CONTENT).first&.content.strip.gsub(/\r\n/,""),   			          # content
			get_ranking_val(review.css(DEALERSHIP_RATING).first), # rating 
			create_rating_dict(review.css(RATINGS_ALL)[0...-1]),				                  # individual ratings
			review.css(RATINGS_ALL).last.css("div").last.content.strip,	                          # would recommend
			review.css("#{REVIEW_WRAPPER} h3").first.content.tr("\"", "").strip,			  # headline
			review.css("#{REVIEW_WRAPPER} span").first.content.tr("-", "").strip              # username
		)

		return reviewObject
	end

	# go through all review elements and create objects
	# return array of review objects
	def get_reviews(doc)

		reviews = []
		doc.css(REVIEW_ENTRY).each do |review|
			reviews.push(get_review(review))
		end

		return reviews
	end

	# take a string of class values and find the one matching the pattern rating-\d\d
	# return the value of the digits if one is found
	def get_ranking_val(review)
		if review.key?(CLASS_KW )
			return review[CLASS_KW][/#{RATING_KW}\-\d\d/]&.split("#{RATING_KW}-").last&.to_i
		end

		return nil
	end

	# take a series of individual rating elements and pull rating for each category
	# return hash of ratings
	def create_rating_dict (reviews)
		reviewDict = Hash.new

		reviews.each do |review|
			details = review.css('div')
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