# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# keyword_analyzer
# keyword_analyzer
### MVP
* I want to be able to:
1. Create a project
2. Enter a list of keywords for that project
3. The tool will then:
    - Categorize the keywords based on syntax (nGram)
    - Categorize the URLs based on any discernable folder structure
    - Show URL based metrics (kw count, sv, traffic)
    - Show category based metrics (kw count, sv, traffic)
    - analyze cannibalization (see if keywords don't match the URL slugs)
4. From there it should give insights and tips 
    - "5 Things You Can do Next"
    - A. Use the nGram to ensure you're targeting the keywords on page
    - B. Use the folder structure to see what keywords the brand ranks for
    - C. See which categories/urls get the most traffic
    - D. You're ranking "toilets for small bathroom" on the faucets page
    - E. Upload more competitors to get new ideas