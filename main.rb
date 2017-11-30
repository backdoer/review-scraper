require './scraper'

scraper = Scraper.new("McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685")

reviews = scraper.parse()