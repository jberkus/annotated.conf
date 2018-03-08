# annotated.conf

This repo contains materials for the Annotated.Conf tutorial from SCALE 16x.

More importantly, it contains annotations of all 269 postgresql.conf settings
for PostgreSQL 10.

Here's all the contents:

* annotated.csv: a spreadsheet file of all 269 options ordered by category and subcategory, with recommendations and comments for your reference.
* guc_tutorial_10.odp: the slides for the tutorial.
* postgresql.10.simple.conf: a sample PostgreSQL 10 configuration file, with the 18 or so most common settings for users to alter called out.
* extra.10.conf: an additional configuration file with another 19 options called out.
* gucs.pgdump: a PostgreSQL 10 backup file, containing a database.

Load gucs.pgdump using pg_restore:

```
pg_restore -d gucs -U postgres gucs.pgdump
```

You can then query it to get ideas for specific settings, or maybe to even write a tuning tool of your own.  The important tables are `annotated` which joins to the built-in pg_settings table, and the view `annotated_report`.
