twitter-ua
==========

##Google Universal Analytics for Twitter

Welcome to a world where tweets can be recorded and documented as page views. 

How to use the code:

#####Get your own keys. And UA Tracking ID

Get Twitter Developers Account Here: https://apps.twitter.com/
Get a UA tracking code on Google Analytics. (Need to upgrade to Universal Analytics)

#####Set up database (we used Postgresql)

1. Install PostgreSQL if you don't have it installed already. (http://www.postgresql.org/docs/7.4/static/installation.html)
2. Create a database. instructions here: http://www.postgresql.org/docs/7.4/static/tutorial-createdb.html

use this command to create a database called mydb:

	$ createdb mydb

#####Create a table within the database.

First access the database with: (assuming your database is named mydb)

	$psql mydb

the last line will look like mydb=> or mydb=# (to quit type \q)

You'll need to create a table named tweets with one column named message of datatype varchar(140) and one column named tweet_id of datatype bigint. Type:

	CREATE TABLE tweets (
		message   varchar(140),
		tweet_id  bigint
	);


#####What tweets do you want to track? Replace twitter_search on line 70 to your query. 
	example: "to:harrys" will all tweets to @harrys

If you want to see all your options, see here: https://dev.twitter.com/docs/api/1.1/get/search/tweets

#####Deploy to heroku! It will run forever. 