require 'sentimental'

class Review 

	attr_accessor :reviewContent, :overallRating, :individualRatings, :wouldRecommend

	@@analyzer = Sentimental.new
	@@analyzer.load_defaults

	def initialize(reviewContent, overallRating, individualRatings, wouldRecommend)
		@reviewContent = reviewContent
		@overallRating = overallRating
		@individualRatings = individualRatings
		@wouldRecommend = wouldRecommend
	end

	# To String
	def to_s
		return self.inspect
	end

	# Calculated Fields
	def polarity
		return @@analyzer.score(@reviewContent)
	end

	def emotion
		return @@analyzer.sentiment(@reviewContent)
	end

	def sum_ind_score
		return @individualRatings.values.inject(:+)
	end

	# equality comparison for testing
	def equals_review(oR)
		oR.reviewContent == @reviewContent and oR.overallRating == @overallRating and oR.individualRatings == @individualRatings and oR.wouldRecommend == @wouldRecommend
	end

end