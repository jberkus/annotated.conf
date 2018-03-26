# annotated.conf

This repo contains materials for the GUCS tutorial from SCALE 16x.

More importantly, it contains annotations of all 269 postgresql.conf settings
for PostgreSQL 10.

Here's all the contents:

* annotated.csv: a spreadsheet file of all 269 options ordered by category and subcategory, with recommendations and comments for your reference.
* guc_tutorial_10.odp/pdf: the slides for the tutorial.
* postgresql.10.simple.conf: a sample PostgreSQL 10 configuration file, with the 18 or so most common settings for users to alter called out.
* extra.10.conf: an additional configuration file with another 24 options called out.
* gucs.pgdump: a PostgreSQL 10 backup file, containing a database.
* gucs.sql: a text-mode database dump

Load gucs.pgdump using pg_restore into a PostgreSQL 10 database:

```
createdb gucs
pg_restore -d gucs -x -O -U postgres gucs.pgdump
```

You can then query it to get ideas for specific settings, or maybe to even write a tuning tool of your own.  The important tables are `annotated` which joins to the built-in pg_settings table, and the view `annotated_report`.

If you don't have PostgreSQL 10 on your desktop, then you can use an earlier version with the SQL file:

```
createdb gucs
psql -U postgres -f gucs.sql
```

... and ignore the messages about missing users etc.  However, installing the gucs database onto an older version of Postgres will mean that new settings will be missing from the annotated_report, and some older ones may show up with no recommendations.

## Corrections, Changes, and Arguments

See something missing?  See something you disagree with?  Issues noticed, and pull requests accepted.

Particularly, if someone wants to take on creating a formatted report based on the annotated_report, that would be lovely.

## LICENSE

All of this material is licensed Creative Commons Share-Alike 4.0.  Full text of license here:
