require './Classes/scraper'

# Constants of 'overly positive'
WOULD_RECOMMEND = "Yes"
REVIEW_EMOTION = :positive
SUM_IND_SCORE = 250

scraper = Scraper.new("McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685")

reviews = scraper.parse(1, 5)

reviews = reviews.select { |review|
		review.wouldRecommend == WOULD_RECOMMEND\
		and review.contentEmotion == REVIEW_EMOTION\
		and review.headlineEmotion == REVIEW_EMOTION\
		and review.sum_ind_score == SUM_IND_SCORE\
	}

reviews = reviews.sort{ |a, b|  a.averageScore <=> b.averageScore }.reverse

for i in 0..2 
	puts "Review ##{i+1}"
	puts reviews[i]
	puts ""
end
