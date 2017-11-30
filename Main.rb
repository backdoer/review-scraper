require './classes/scraper'
require 'highline'

# Main file to scrape web and output results
# =====================================================

# if interactive flag is specified, get user input
if ARGV.include? '-i'
	cli = HighLine.new
	dealerId = cli.ask("Dealer Id? ") { |q| q.default = Scraper::DEFAULT_DEALER }

	startPage = cli.ask("Starting Page? ", Integer) { |q| q.above = 0  }

	endPage = cli.ask("Ending Page? ", Integer) { |q| q.above = startPage }

	numberOfReviews = cli.ask("Number of Reviews Posted? ", Integer) { |q| q.above = 0 }
end

# default values
startPage ||= 1
endPage ||= 5
dealerId ||= Scraper::DEFAULT_DEALER
numberOfReviews ||= 3

# create scraper class
scraper = Scraper.new(dealerId)

# parse the web to get the reviews
reviews = scraper.parse(startPage, endPage)

# filter the reviews by the 'overly positive' criteria
reviews = reviews.select { |review|
	review.wouldRecommend == Review::RECOMMEND_VALUE\
	and review.contentEmotion == Review::POSITIVE_SENTIMENT\
	and review.headlineEmotion == Review::POSITIVE_SENTIMENT\
	and review.sumIndScore == Review::SUM_IND_SCORE_MAX\
}

# order the reviews by the highest average sentiment score
reviews = reviews.sort{ |a, b|  a.averageScore <=> b.averageScore }.reverse

# output the top specified number of most 'overly positive' reviews
for i in 0..numberOfReviews - 1
	puts "Review ##{i+1}"
	puts reviews[i]
	puts ""
end
