# Roster

Creates RSS Feed for theberrics.com website


## Installation

Checkout the repository

    $ git clone git://github.com/devrieda/berrics_rss.git

Install Locally
  
    $ cd berrics_rss/
    $ rvm use 1.9.3-p286
    $ rake install


## Usage
  
Generate RSS

    builder = BerricsRss::Builder.new
    rss = builder.xml
