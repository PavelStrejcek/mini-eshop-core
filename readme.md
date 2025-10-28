Mini E-shop Core
================

This is an example of a pure Nette Framework solution without any other useful libraries.

Installation
------------

1. Clone this project from Git into a directory, and make the directory writable.

2. Navigate to the directory and copy the file docker-compose.override.yml.dist to docker-compose.override.yml.

3. Create the file config/local.neon, either empty or with your custom settings.

4. Run `docker-compose up -d`.

5. Run `docker-compose exec app composer install`.

Open http://localhost
in your browser.

If you encounter any issues, make sure the directories .volumes/, temp/, and log/, or the main project directory itself, have write permissions, and that files in the bin/ and cron/ directories have execute permissions.

In step 5, a database with sample data is also created, and prices are recalculated according to the current EUR exchange rate from the CNB.
These commands can also be run manually:

`docker-compose exec app php bin/init.php`

`docker-compose exec app php cron/exchange-rate-import.php`






