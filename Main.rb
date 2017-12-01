require './classes/scraper'
require 'highline'
require 'terminal-table'

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

# start timer to track speed
startTime = Time.now

# parse the web to get the reviews
reviews = scraper.parse(startPage, endPage)

# grab the length of the reviews array to display for benchmarking
totalReviewsParsed = reviews.length

# filter the reviews by the 'overly positive' criteria
reviews = reviews.select { |review|
	review.wouldRecommend == Review::RECOMMEND_VALUE\
	and review.contentEmotion == Review::POSITIVE_SENTIMENT\
	and review.headlineEmotion == Review::POSITIVE_SENTIMENT\
	and review.sumIndScore == Review::SUM_IND_SCORE_MAX\
}

# order the reviews by the highest average sentiment score
reviews = reviews.sort{ |a, b|  a.averageScore <=> b.averageScore }.reverse

# line to be printed to the screen
line = Array.new(80){"_"}.join("")

# output the top specified number of most 'overly positive' reviews
for i in 0..numberOfReviews - 1
	puts "\n*** Review ##{i+1} ***\n\n"
	puts "#{reviews[i]}\n\n"
	puts "#{line}\n\n"
end

# end timer
endTime = Time.now

table = Terminal::Table.new do |t|
  t << ['Reviews Parsed', totalReviewsParsed]
  t.add_row ['Overly Positive Reviews', reviews.length]
  t.add_row ['Total Time Elapsed', "#{(endTime - startTime).round(3)} secs"]
  t.add_row ['Avg. Speed', "#{(totalReviewsParsed / (endTime - startTime)).round(3)} reviews/sec"]
end

puts table

