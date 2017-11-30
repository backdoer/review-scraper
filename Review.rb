require 'sentimental'

class Review 

	@@analyzer = Sentimental.new
	@@analyzer.load_defaults
	@@analyzer.threshold = 2

	def initialize(reviewContent, overallRating, individualRatings, wouldRecommend)
		@reviewContent = reviewContent
		@overallRating = overallRating
		@individualRatings = individualRatings
		@wouldRecommend = wouldRecommend
	end

	# To String
	def to_s
		
	end

	# Getters
	def reviewContent
		@reviewContent
	end

	def overallRating
		@overallRating
	end

	def individualRatings
		@individualRatings
	end

	def wouldRecommend
		@wouldRecommend
	end

	# Calculated Fields
	def polarity
		return @@analyzer.score(@reviewContent)
	end

	def emotion
		return @@analyzer.sentiment(@reviewContent)
	end

	def sumIndScore
		return @individualRatings.values.inject(:+)
	end

	# equality comparison
	def equalsReview(oR)
		oR.reviewContent == @reviewContent and oR.overallRating == @overallRating and oR.individualRatings == @individualRatings and oR.wouldRecommend == @wouldRecommend
	end

end