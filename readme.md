Mini E-shop Core
================

This is an example of a pure Nette Framework solution without any other useful libraries.

Installation
------------

1. clone this product from git to a directory
2. go to the directory and copy the docker-compose.override.yml.dist file as docker-compose.override.yml
3. create file config/local.neon empty or with your settings
4. docker-compose up -d
5. docker-compose exec app composer install
6. open http://localhost in your browser

In case of problems, make sure that directory `.volumes/`, `temp/` and `log/` have write permissions set and files in directory `bin/`, `cron/` have execute permissions set.

In the step 5, a database with sample data is also created and prices are recalculated according to the current EUR exchange rate from the CNB.
It is possible to run the commands manually:

docker-compose exec app php bin/init.php

docker-compose exec app php cron/exchange-rate-import.php






