# Roster

Creates RSS Feed for theberrics.com website


## Installation

Checkout the repository

    $ git clone https://github.com/devrieda/berrics_rss.git

Install Locally
  
    $ cd berrics_rss/
    $ rvm use 1.9.3-p286
    $ rake install


## Usage
  
Generate RSS

    builder = BerricsRss::Builder.new
    rss = builder.xml

Write RSS to file
    
    builder = BerricsRss::Builder.new
    builder.write("path/to/berrics.rss")
    