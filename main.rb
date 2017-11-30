require './scraper'

# Constants of 'overly positive'
WOULD_RECOMMEND = "Yes"
REVIEW_EMOTION = :positive
SUM_IND_SCORE = 250

scraper = Scraper.new("McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685")

reviews = scraper.parse(1, 5)

reviews = reviews.select { |review| review.wouldRecommend == WOULD_RECOMMEND and review.emotion == REVIEW_EMOTION and review.sumIndScore == SUM_IND_SCORE }

reviews = reviews.sort{ |a, b|  a.polarity <=> b.polarity }

puts reviews