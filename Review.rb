require 'sentimental'

class Review 

	attr_accessor :reviewContent, :overallRating, :individualRatings, :wouldRecommend

	@@analyzer = Sentimental.new
	@@analyzer.load_defaults

	def initialize(reviewContent, overallRating, individualRatings, wouldRecommend, headline, username)
		@reviewContent = reviewContent
		@overallRating = overallRating
		@individualRatings = individualRatings
		@wouldRecommend = wouldRecommend
		@headline = headline
		@username = username
	end

	# To String
	def to_s
		return self.inspect
	end

	# Calculated Fields
	def averageScore
		return (self.contentScore + self.headlineScore) / 2
	end

	def contentScore
		return @@analyzer.score(@reviewContent)
	end

	def headlineScore
		return @@analyzer.score(@headline)
	end

	def contentEmotion
		return @@analyzer.sentiment(@reviewContent)
	end

	def headlineEmotion
		return @@analyzer.sentiment(@headline)
	end

	def sum_ind_score
		return @individualRatings.values.inject(:+)
	end

	# equality comparison for testing
	def equals_review(oR)
		return (
			oR.reviewContent == @reviewContent\
			and oR.overallRating == @overallRating\
			and oR.individualRatings == @individualRatings\
			and oR.wouldRecommend == @wouldRecommend
		)
	end

end