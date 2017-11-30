require './Classes/scraper'

# create scraper class
scraper = Scraper.new()

# parse the web to get the reviews
reviews = scraper.parse(1, 5)

# filter the reviews by the 'overly positive' criteria
reviews = reviews.select { |review|
		review.wouldRecommend == Review::RECOMMEND_VALUE\
		and review.contentEmotion == Review::POSITIVE_SENTIMENT\
		and review.headlineEmotion == Review::POSITIVE_SENTIMENT\
		and review.sum_ind_score == Review::SUM_IND_SCORE_MAX\
	}

# order the reviews by the highest average sentiment score
reviews = reviews.sort{ |a, b|  a.averageScore <=> b.averageScore }.reverse

# output the top 3 most 'overly positive' reviews
for i in 0..2 
	puts "Review ##{i+1}"
	puts reviews[i]
	puts ""
end
