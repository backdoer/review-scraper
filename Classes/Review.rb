require 'sentimental'

# Class to encapsulate review objects
# =====================================================

class Review 

	# provide accessor rights to these attributes
	attr_accessor :reviewContent, :overallRating, :individualRatings, 
					:wouldRecommend, :headline, :username

	# constants
	POSSIBLE_SENTIMENTS = [:positive, :negative, :neutral]
	IND_RATING_HEADINGS = {
		:customerService => "Customer Service",
		:qualityOfWork => "Quality of Work",
		:friendliness => "Friendliness",
		:pricing => "Pricing",
		:overallExperience => "Overall Experience"
	}

	# 'overly positive' values
	RECOMMEND_VALUE = "Yes"
	SUM_IND_SCORE_MAX = 250
	IND_SCORE_MAX = 50
	POSITIVE_SENTIMENT = :positive

	# declare sentiment analyzer
	@@analyzer = Sentimental.new
	@@analyzer.load_defaults

	# constructor
	def initialize(reviewContent, overallRating, individualRatings, 
		wouldRecommend, headline, username)

		@reviewContent = reviewContent
		@overallRating = overallRating
		@individualRatings = individualRatings
		@wouldRecommend = wouldRecommend
		@headline = headline
		@username = username
	end

	# To String
	def to_s
		"By: #{@username}\n"\
		"\"#{@headline}\"\n"\
		"Overall Rating: #{@overallRating / 10.0}\n"\
		"Recommend Dealer: #{@wouldRecommend}\n\n"\
		"\"#{@reviewContent}\""
	end

	# Calculated Fields

	# return average score of content and headline 
	def averageScore
		return (self.contentScore + self.headlineScore) / 2
	end

	# return content sentiment score
	def contentScore
		return @@analyzer.score(@reviewContent)
	end

	# return content sentiment score
	def headlineScore
		return @@analyzer.score(@headline)
	end

	# return emotion of content
	def contentEmotion
		return @@analyzer.sentiment(@reviewContent)
	end

	# return emotion of headline
	def headlineEmotion
		return @@analyzer.sentiment(@headline)
	end

	# return the sum of all the individual scores 
	def sumIndScore
		return @individualRatings.values.inject(:+)
	end

	# compare review object to another review object
	# return whether they are equal
	def equals_review(oR)
		return (
			oR.reviewContent == @reviewContent\
			and oR.overallRating == @overallRating\
			and oR.individualRatings == @individualRatings\
			and oR.wouldRecommend == @wouldRecommend\
			and oR.headline == @headline\
			and oR.username == @username
		)
	end

end