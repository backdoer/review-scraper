require './Classes/scraper'

scraper = Scraper.new()

reviews = scraper.parse(1, 5)

reviews = reviews.select { |review|
		review.wouldRecommend == Review::RECOMMEND_VALUE\
		and review.contentEmotion == Review::POSITIVE_SENTIMENT\
		and review.headlineEmotion == Review::POSITIVE_SENTIMENT\
		and review.sum_ind_score == Review::SUM_IND_SCORE_MAX\
	}

reviews = reviews.sort{ |a, b|  a.averageScore <=> b.averageScore }.reverse

for i in 0..2 
	puts "Review ##{i+1}"
	puts reviews[i]
	puts ""
end
