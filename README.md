## Synopsis

This is a top secret web scraping tool, written in Ruby, commissioned by the KGB to solve the mystery of the 'overly positive' reviews currently being posted about Chevrolet Buick on DealerRater.com. 

Here is an example of a review:

![review pic](https://github.com/backdoer/Scraper/blob/master/Assets/review.png)

The reviews are then filtered on whether or not they meet the following criteria:

* Reviewer says they would recommend dealer
* Every review category has 5 stars
* The sentiment of the headline is overall positive
* The sentiment of the content body is overall positive  

After the reviews are filtered, they are then ordered by the average of the positivity score of the headline and the positivity score of the content body. 

All sentiment values are calculated using the [sentimental](https://github.com/7compass/sentimental) analysis library.

After the ordering is complete, the top reviews are then printed to the terminal.

## Dependencies
This project has the following dependencies:
* Ruby
* Gems:
	* mechanize
	* sentimental
	* highline

## Installation

To install all of the gem dependencies, run the following command:

```
bundle install
```

If you don't have bundler, go [here](http://bundler.io/) to learn how to install it.

## Application Parameters
### Dealer Id
The DealerId comes from the URL of the dealer's page on DealerRater.
e.g. the full url of Chevrolet Buick is (with the DealerId bolded):

https://www.dealerrater.com/dealer/**McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685**

### Starting Page
This is the first page of reviews that will be scraped from the site

### Ending Page
The web scraper will scrape reviews from every page starting with the starting page until the ending page

### Number Of Reviews Posted
This is the number of reviews that will be printed in the console once the web scraping and positivity analysis is complete

## Code Example

### Default Run
In the root directory of the project, run the following command in your terminal to run the default version of the tool:
```
ruby Main.rb
```

This will default to the following parameters for the web scrape:

**Dealer Id:** McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685

**Starting Page:** 1

**Ending Page:** 5

**Number Of Reviews Posted:** 3


### Interactive Run
To run the interactive version of the tool, which allows you to specify the four parameters instead of resorting to default, run the following command in the root directory of the project:

```
ruby Main.rb -i
```

You will then be prompted for the four parameters mentioned above in order. Leaving the **Dealer Id** blank will default it to "McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685" (Chevrolet Buick).


## Tests

There is a full suite of unit tests centered around testing the Review class and the Parser class. To run the suite of tests, run the following command in the root directory of the project:

```
ruby TestSuite.rb
```

