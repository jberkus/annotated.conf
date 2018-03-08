--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: annotated; Type: TABLE; Schema: public; Owner: jberkus
--

CREATE TABLE public.annotated (
    name text NOT NULL,
    category text,
    subcategory text,
    type text,
    defaults text,
    recommendation text,
    comments text
);


ALTER TABLE public.annotated OWNER TO jberkus;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: jberkus
--

CREATE TABLE public.categories (
    category text,
    category_sort integer
);


ALTER TABLE public.categories OWNER TO jberkus;

--
-- Name: subcategories; Type: TABLE; Schema: public; Owner: jberkus
--

CREATE TABLE public.subcategories (
    category text,
    subcategory text,
    subcategory_sort integer
);


ALTER TABLE public.subcategories OWNER TO jberkus;

--
-- Name: annotated_report; Type: VIEW; Schema: public; Owner: jberkus
--

CREATE VIEW public.annotated_report AS
 SELECT annotated.category,
    annotated.subcategory,
    annotated.name,
    annotated.type,
    annotated.defaults,
    annotated.recommendation,
        CASE
            WHEN (pg_settings.min_val IS NOT NULL) THEN ((pg_settings.min_val || COALESCE(pg_settings.unit, ''::text)) || COALESCE(((' to '::text || pg_settings.max_val) || COALESCE(pg_settings.unit, ''::text)), ''::text))
            WHEN (pg_settings.enumvals IS NOT NULL) THEN array_to_string(pg_settings.enumvals, ','::text)
            ELSE NULL::text
        END AS range,
    pg_settings.context,
    pg_settings.short_desc AS docs,
    annotated.comments
   FROM (((public.annotated
     JOIN pg_settings ON ((annotated.name = pg_settings.name)))
     JOIN public.categories ON ((annotated.category = categories.category)))
     LEFT JOIN public.subcategories ON (((annotated.category = subcategories.category) AND (annotated.subcategory = subcategories.subcategory))))
  ORDER BY categories.category_sort, subcategories.subcategory_sort, annotated.name;


ALTER TABLE public.annotated_report OWNER TO jberkus;

--
-- Data for Name: annotated; Type: TABLE DATA; Schema: public; Owner: jberkus
--

COPY public.annotated (name, category, subcategory, type, defaults, recommendation, comments) FROM stdin;
allow_system_table_mods	Developer Options	\N	bool	off	default	Only available in single-user mode; this setting is for initdb and may be used in the future for upgrade-in-place.
application_name	Other Settings & Defaults	Identification	string	psql	name	Set this to a reasonable default for most user sessions; if in the middle of working over your application to support application names, this might be “unknown”.
archive_command	WAL and Checkpoints	Archiving	string	(disabled)	varies	All of the Archiving settings are part of a Point In Time Recovery or Warm Standby configuration.  Please see the Backup and Restore section for more information.
archive_mode	WAL and Checkpoints	Archiving	bool	off	varies	Requires a restart to change, so if you want to turn archiving on and off, set this to 'on' and change archive_command instead.  Even better, set archive_command to a script which can be disabled by trigger or ENV variable.
archive_timeout	WAL and Checkpoints	Archiving	integer	0	varies	Dependant on your tradeoff between disk space and letting the standby get behind.
array_nulls	Version and Platform Compatibility	Previous PostgreSQL Versions	bool	on	default	Provided for compatibility with 7.4 behavior.
authentication_timeout	Connections and Authentication	Connection Persistence	time	60	decrease	For production databases, it's important that this value be synchronized with the timeout on the application server side.  Most web applications will want a shorter timeout, like 20s.
autovacuum	Maintenance	Autovacuum	bool	on	on	Starts the daemon which cleans up your tables and indexes, preventing bloat and poor response times. The only reason to set it to “off” is for databases which regularly do large batch operations like ETL.  Note that you can adjust the frequency or stop autovacuum on individual tables by adding rows to the pg_autovacuum system table.
autovacuum_analyze_threshold	Maintenance	Autovacuum	integer	50	default	\N
autovacuum_freeze_max_age	Maintenance	Autovacuum	integer	200000000	500000000	Triggers autovacuum automatically if a table is about to suffer from XID rollover. The setting is very conservative, and should probably be increased to 500million, but not higher.
autovacuum_max_workers	Maintenance	Autovacuum	integer	3	default	If you have an installation with many tables (100's to 1000's) or with some tables which autovacuum takes hours to process, you may want to add additional autovacuum workers so that multiple tables can be vacuumed at once.  Be conservative, though, as each autovacuum worker will utilize a separate CPU core, memory and I/O.
autovacuum_multixact_freeze_max_age	Maintenance	Autovacuum	integer	400000000	default	Triggers autovacuum automatically when the oldest “multixact” (a kind of lock transaction) is more than this old.  Do not raise past 1billion.
autovacuum_naptime	Maintenance	Autovacuum	integer	60	default	Decrease this to 30s or 15s if you have a large number (100's) of tables, or if you otherwise see from pg_stat_user_tables that autovacuum is not keeping up.
autovacuum_vacuum_cost_delay	Maintenance	Autovacuum	integer	20	default	If autovacuum is having too much of a performance impact on running queries, you might want to increase this setting to 50ms.  However, this will also cause individual vacuum tasks to take longer.
autovacuum_vacuum_cost_limit	Maintenance	Autovacuum	integer	-1	default	\N
autovacuum_vacuum_threshold	Maintenance	Autovacuum	integer	50	default	\N
autovacuum_work_mem	Maintenance	Autovacuum	memory	-1	AvRAM / workers / 4	Set a limit on this which is based on the number of autovac workers you expect to have running.
backend_flush_after	WAL and Checkpoints	Synch to Disk	memory	0	default	Unless you have time to tune memory flushing behavior and test for improvements/regressions
backslash_quote	Version and Platform Compatibility	Previous PostgreSQL Versions	ENUM	safe_encoding	default	If you have cleaned up your application code, you can set this to 'off' to help lock down the database.  Older PHP applications will require the insecure setting of 'on'.
bgwriter_delay	WAL and Checkpoints	Background Writer	time	200	default	Thanks to bgwriter autotuning, it should no longer be necessary for most users to touch the bgwriter settings.  Only modify these if you have a demonstrated issue shown by checkpoint spikes and monitoring pg_stat_bgwriter.  Laptop PostgreSQL users may want to increase bgwriter_delay to 60s to decrease I/O activity, since it is no longer possible to turn the bgwriter off.
bgwriter_flush_after	WAL and Checkpoints	Background Writer	memory	512kB	default	Unless you have time to tune memory flushing behavior and test for improvements/regressions
bgwriter_lru_maxpages	WAL and Checkpoints	Background Writer	integer	100	default	\N
bgwriter_lru_multiplier	WAL and Checkpoints	Background Writer	real	2	default	\N
block_size	Preset Options	\N	integer	8192	N/A	Informational: lets you know of non-standard installation or compile options.
bonjour	Connections and Authentication	Connection Settings	bool	off	off	Set to “on” if you've compiled in Bonjour support and have an application which works by autodiscovery of Postgres.  Otherwise, leave off.
bonjour_name	Connections and Authentication	Connection Settings	string	machine name	default	Bonjour support must be compiled in and activated on the host machine to be live.  You'll want alternate names if you have several instances of PostgreSQL on the same machine.
bytea_output	Version and Platform Compatibility	Previous PostgreSQL Versions	enum	hex	hes	\N
check_function_bodies	Other Settings & Defaults	Other Defaults	bool	on	default	You only really want to turn this off to resolve circular dependancies, and that can be done on a per-session basis.  In general, checking for syntax errors in PL/pgSQL functions is a very good idea.
checkpoint_completion_target	WAL and Checkpoints	Checkpoints	real	1	default	Defines the fraction of one checkpoint_interval over which to spread checkpoints. The default value works for most users.
checkpoint_flush_after	WAL and Checkpoints	Checkpoints	memory	256kB	default	Unless you have time to tune memory flushing behavior and test for improvements/regressions
checkpoint_timeout	WAL and Checkpoints	Checkpoints	integer	300	default	If you do really large ETL batches, you may want to increase this setting to the maximum length of a batch run.
checkpoint_warning	WAL and Checkpoints	Checkpoints	integer	30	default	\N
client_encoding	Locale & Formatting	Locale	string	per ENV	default	Should match server_encoding unless you have a really good reason why not.
client_min_messages	Reporting and Logging	When to Log	ENUM	notice	default	Unless doing interactive debugging, then you want it set to DEBUG1-5.  If you have a client application which is confused by some of PostgreSQL's WARNINGs then you may want to set this to ERROR.
cluster_name	Other Settings & Defaults	Identification	string	NULL	set	Should be “postgres-1” or something else identifiable as this specific postmaster.
commit_delay	WAL and Checkpoints	Commit Settings	integer	0	0	A primitive form of group commit without asynchronicity.  Performance testing of this is very mixed; only set to non-zero if you have time to test the specific performance impact on your workload.  Reasonable values are 200 to 1000.
commit_siblings	WAL and Checkpoints	Commit Settings	integer	5	1	See commit_delay.  Reasonable values are 3 to 8
enable_tidscan	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
config_file	File Locations	\N	string	ConfigDir/postgresql.conf	default	Can only be changed via command-line switch for obvious reasons.  Useful primarily for testing different configuration options, or for automated restart with different configuration options.
constraint_exclusion	Query Tuning	Other Planner Options	bool	partiton	default	Default of “partition” is fine for most users.  Setting it to “on” can allow optimization of UNION queries as well, but deserves testing before production deployment.
cursor_tuple_fraction	Query Tuning	Other Planner Options	real	0	\N	Increase this to 0.9 if most of the time you're using cursors to step through all of the rows of a query result.
data_checksums	Preset Options	\N	bool	off	on	This has to be set at initdb time, and does create a significant amount of extra I/O.  However, it will save you from a corrupt database down the line, so if you're not performance-constrained, always use it.
data_directory	File Locations	\N	string	ConfigDir	default	Supports the ability to distribute files according to sysadmin or operating system defined schemes, or for launching multiple restart instances using the same binaries.  Most of the time, it's better to use configuration options to define these locations so that all PostgreSQL binaries default to the correct paths.
DateStyle	Locale & Formatting	Display	list	ISO, MDY	default	Should be set according to the format in which you expect to receive date information.
db_user_namespace	Connections and Authentication	Security and Authentication	bool	off	do not use	This setting is a hack to work around the lack of per-database users in PostgreSQL.  Unless you desperately need it, avoid this setting as it will eventually be replaced by something more maintainable.
deadlock_timeout	Lock Management	\N	time	1sec	default	Default is fine, except when you are troubleshooting/monitoring locks.  In that case, you may want to lower it to as little as 50ms.
debug_assertions	Developer Options	\N	bool	off	default	Used for debugging PostgreSQL code problems; not for production use.  Requires compile options.
debug_pretty_print	Reporting and Logging	What to Log	bool	off	on	For debugging a testing machine.  Do not set in production.
debug_print_parse	Reporting and Logging	What to Log	bool	off	default	For debugging a testing machine.  Do not set in production.
debug_print_plan	Reporting and Logging	What to Log	bool	off	default	For debugging a testing machine.  Do not set in production.
debug_print_rewritten	Reporting and Logging	What to Log	bool	off	default	For debugging a testing machine.  Do not set in production.
default_statistics_target	Query Tuning	Other Planner Options	integer	100	varies	Most applications can use the default of 100.    For very small/simple databases, decrease to 10 or 50.  Data warehousing applications generally need to use 500 to 1000.  Otherwise, increase statistics targets on a per-column basis.
default_tablespace	Other Settings & Defaults	Default Locations	string	\N	default	Change this if you want a different tablespace for user-created tables.  Generally, better set on a ROLE or session basis.
hot_standby_feedback	Replication	Standby Options	bool	off	on	Helps avoid query cancel on the replicas in most cases.  Turn it off for a replica which does long-running reports and is allowed to lag.
default_text_search_config	Other Settings & Defaults	Text Search	string	per ENV	default	Set to the most common language used by the users, so that they don't have to pass the language parameter when calling TSearch functions.
default_transaction_deferrable	Other Settings & Defaults	Statement Behavior	bool	off	default	If you use serializable transactions by default, it may be also useful to set this in order to decrease the overhead of long-running transactions.
default_transaction_isolation	Other Settings & Defaults	Statement Behavior	ENUM	read committed	default	Relates to transaction_isolation.  Better set on a session or transaction basis as transaction_isolation in order to support specific types of transaction conflict resolution.
default_transaction_read_only	Other Settings & Defaults	Statement Behavior	bool	off	default	This setting is mainly useful for preventing yourself from accidentally changing data.  It is not really a security setting, as anyone can revoke it on their own session.  Better set on a session or ROLE level.  Will show up as TRUE if you are on a replication standby.
default_with_oids	Version and Platform Compatibility	Previous PostgreSQL Versions	bool	off	default	Provided for consistency with 7.3 behavior.  Since this creates an OID for every row, can cause OID wraparound in large databases.
dynamic_library_path	Other Settings & Defaults	Libraries	string	$libdir	default	Primarily useful if you've written lots of custom C libraries for your installation and want to organize them into custom directories.
dynamic_shared_memory_type	Resource Usage	Memory	ENUM	auto-detect	default	\N
effective_cache_size	Query Tuning	Planner Cost Constants	integer	65536	( AvRAM * 0.75 )	Tells the PostgreSQL query planner how much RAM is estimated to be available for caching data, in both shared_buffers and in the filesystem cache. This setting just helps the planner make good cost estimates; it does not actually allocate the memory.
effective_io_concurrency	Query Tuning	Other Planner Options	integer	1	varies	Set to the number of disks in your RAID array or number of I/O channels.  Available only for platforms with posix_fadvise support (i.e. Linux).  Currently only affects the execution of parallel bitmapscan, but might affect other I/O operations in future versions.
cpu_tuple_cost	Query Tuning	Planner Cost Constants	real	0.01	default	\N
enable_bitmapscan	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_gathermerge	Query Tuning	Planner Method Configuration	bool	on	default	\N
enable_hashagg	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_hashjoin	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_indexonlyscan	Query Tuning	Planner Method Configuration	bool	on	default	\N
enable_indexscan	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_material	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_mergejoin	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_nestloop	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_seqscan	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
enable_sort	Query Tuning	Planner Method Configuration	bool	on	default	For interactive session use only when troubleshooting queries.
escape_string_warning	Version and Platform Compatibility	Previous PostgreSQL Versions	bool	on	off	Useful for providing warnings for interpreted-language applications which may be engaging in unsafe string escape behavior.  Unless you are currently porting or upgrading such an application, though, these warnings are not useful and should be turned off.
event_source	Other Settings & Defaults	Identification	string	NULL	set	Should be “postgres-1” or something else identifiable as this specific postmaster.
exit_on_error	Other Settings & Defaults	Other Defaults	bool	off	default	\N
external_pid_file	File Locations	\N	string	None	default	Creates an extra copy of the process ID.  Used for server administration tools which need a copy of the process ID in a specific directory.
extra_float_digits	Locale & Formatting	Display	integer	0	default	Only significant for applications which do a lot of float calculations, like scientific databases.
force_parallel_mode	Query Tuning	Parallel Query	ENUM	off	default	\N
from_collapse_limit	Query Tuning	Other Planner Options	integer	8	default	While it's probably true that newer CPUs could support higher collapse_limits, there's not much incremental benefit to just raising either collapse_limit to 10 or 11.
fsync	WAL and Checkpoints	Synch to Disk	bool	on	on	Never turn off unless your data is entirely disposable.  Setting fsync=off is the equivalent of saying “I don't care about my data, I can recreate the database from scratch if I have to.”  If synch activity is a performance concern, see synchronous_commit.
full_page_writes	WAL and Checkpoints	Synch to Disk	bool	on	on	This is PostgreSQL's triple-check on transaction log integrity.  Leave it on unless you have enough in-depth knowledge of your filesystem and hardware to be certain that torn page writes of log segments are completely prevented.  Solaris/ZFS users claim to be able to turn this off, but that has not been destruction-tested.
geqo	Query Tuning	Genetic Query Optimizer	bool	on	default	\N
geqo_effort	Query Tuning	Genetic Query Optimizer	integer	5	default	\N
geqo_generations	Query Tuning	Genetic Query Optimizer	integer	0	default	\N
geqo_pool_size	Query Tuning	Genetic Query Optimizer	integer	0	default	\N
geqo_seed	Query Tuning	Genetic Query Optimizer	real	0	\N	If you set this manually, you can force repeatable execution paths for GEQO queries.
geqo_selection_bias	Query Tuning	Genetic Query Optimizer	real	2	default	\N
geqo_threshold	Query Tuning	Genetic Query Optimizer	integer	12	15	With new, faster processors it's tempting to raise the geqo_threshold a little, such as to 16 or 18.  Increasing more than that is unwise as query planning time goes up geometrically.
gin_fuzzy_search_limit	Other Settings & Defaults	Text Search	integer	0	varies	If you're going to use GIN queries in a web application, it's generally useful to set a limit on how many rows can be returned from the index just for response times.  However, the maximum number needs to depend on your application; what do users see as an acceptable expression of "many"?
gin_pending_list_limit	Other Settings & Defaults	Other Defaults	memory	4MB	default	Unless you have a lot of GIN indexed data and have time to test the performance of fastupdate.  Even then, it's probably better to set it on individual indexes.
hba_file	File Locations	\N	string	ConfigDir/pg_hba.conf	default	Allows you to move the pg_hba file to a sysadmin-specified location.
hot_standby	Replication	Standby Options	bool	on	on	Set to “on”, unless you want to specifically prohibit people from running queries on a standby server.
huge_pages	Resource Usage	Memory	ENUM	try	default	However, for small systems (< 2GB of RAM) may be beneficial to set to “off”.
ident_file	File Locations	\N	string	ConfigDir/pg_ident.conf	default	Allows you to move the pg_ident file to a sysadmin-specified location.
idle_in_transaction_session_timeout	Other Settings & Defaults	Timeouts	time	off	1hr	Set to 1 hour maximum, or as low as 1 minute if you know your query load well.  Idle transactions are bad news.
ignore_checksum_failure	Developer Options	\N	bool	off	default	For rescuing a corrupt DB
ignore_system_indexes	Developer Options	\N	bool	off	default	Useful for salvaging data from a corrupted database.
integer_datetimes	Preset Options	\N	bool	off	N/A	Informational: lets you know of non-standard installation or compile options.
IntervalStyle	Locale & Formatting	Display	enum	postgres	default	This is just in case your applications are expecting something specific in how INTERVAL strings are output.
join_collapse_limit	Query Tuning	Other Planner Options	integer	8	default	If for some reason you wanted to explicitly declare the join order for all of your queries, you could set this to 1.  That is not recommended, though.
krb_caseins_users	Connections and Authentication	Security and Authentication	bool	off	varies	Speak with your sysadmin or network security about how to set the various kerberos settings to match your local kerberos setup.  Kerberos support must be compiled in to PostgreSQL, and set in pg_hba.conf.
krb_server_keyfile	Connections and Authentication	Security and Authentication	string	\N	varies	\N
lc_collate	Locale & Formatting	Locale	string	as compiled	N/A	Set at initdb time.  Displayed for information only.
lc_ctype	Locale & Formatting	Locale	string	as compiled	N/A	Set at initdb time.  Displayed for information only.
lc_messages	Locale & Formatting	Locale	string	as compiled	default	\N
lc_monetary	Locale & Formatting	Locale	string	as compiled	default	\N
lc_numeric	Locale & Formatting	Locale	string	as compiled	default	\N
lc_time	Locale & Formatting	Locale	string	as compiled	default	\N
listen_addresses	Connections and Authentication	Connection Settings	list	localhost	localhost,1 address	Set your listen_address as restrictively as possible; '*' should only be used for development machines
local_preload_libraries	Other Settings & Defaults	Libraries	string	\N	default	This is largely a convenience setting, automatically loading libraries listed without needing an explicit load command.  Has no effect on performance.
lock_timeout	Other Settings & Defaults	Timeouts	time	0 off	default	… but consider setting this per application or per query for any explicit locking attempts.
lo_compat_privileges	Version and Platform Compatibility	Previous PostgreSQL Versions	bool	off	\N	\N
log_autovacuum_min_duration	Reporting and Logging	When to Log	integer	-1	1min	Logs all autovacuum actions which take more than the specified time.  Useful for figuring out if autovacuum is bogging down your system or blocking.
max_pred_locks_per_page	Lock Management	\N	integer	2	default	\N
log_checkpoints	Reporting and Logging	What to Log	bool	off	varies	When doing performance analysis, it's often a good idea to turn on most of the logging options and log them to a CSVlog.  
log_connections	Reporting and Logging	What to Log	bool	off	varies	Useful for performance analysis.
log_destination	Reporting and Logging	Where to Log	string	csvlog	varies	Your choice of log destination depends on your system administration plans and the status of your server.  “syslog” or “eventlog” (Windows) are good choices for most development servers, because they can support centralized log monitors.  For development and testing, however, “csvlog” is probably the most useful, as it allows you to run queries against the log contents.
log_directory	Reporting and Logging	Where to Log	string	pg_log	varies	If you are having PostgreSQL keep its own activity logs on a production server, it's probably a good idea to locate them on separate storage from the database and transaction log.
log_disconnections	Reporting and Logging	What to Log	bool	off	varies	Useful for performance analysis.
log_duration	Reporting and Logging	What to Log	bool	on	varies	Useful for performance analysis.
log_error_verbosity	Reporting and Logging	When to Log	ENUM	default	default	Unless doing intensive debugging.  Alternately, set to TERSE if managing log volume is becoming a problem.
log_executor_stats	Statistics	Monitoring	bool	off	default	Used for profiling the query executor.
log_file_mode	Reporting and Logging	Where to Log	integer	600	default	… unless you need to share the log with Postgres' unix group, in which case set it to 660.
log_filename	Reporting and Logging	Where to Log	string	postgresql-%Y-%m-%d_%H%M%S.log	varies	If you want your logs to rotate automatically without needing a cron job to delete old logs, try naming them after the days of the week or the month so they overwrite automatically (i.e. 'postgresql-%a' or 'postgresql-%d').  This also helps with log analysis.
logging_collector	Reporting and Logging	Where to Log	bool	on	on	Only relevant for “csvlog” and “stderr”.
log_hostname	Reporting and Logging	What to Log	bool	off	off	As this setting requires resolution of each connecting hostname, it's pretty much always too expensive to have on, even when troubleshooting.
log_line_prefix	Reporting and Logging	What to Log	string	\N	default	Primarily useful for providing extra information when logging to syslog or eventlog.  Try "%h:%d:%u:%c  %t" for this.
log_lock_waits	Reporting and Logging	What to Log	bool	off	varies	Useful for performance analysis.
log_min_duration_statement	Reporting and Logging	When to Log	integer	-1	1min	Possibly the most generally useful log setting for troubleshooting performance, especially on a production server.  Records only long-running queries for analysis; since these are often your "problem" queries, these are the most useful ones to know about.  Used for pg_fouine.
log_min_error_statement	Reporting and Logging	When to Log	ENUM	error	default	Logs SQL statements which error.  If you have an application which routinely generates errors and can't fix it, then raise the level to FATAL or PANIC.
log_min_messages	Reporting and Logging	When to Log	ENUM	notice	default	Unless doing serious troubleshooting.  If you want to output parses and plans, set to DEBUG1.
log_parser_stats	Statistics	Monitoring	bool	off	default	Used for profiling the query parser.
max_pred_locks_per_relation	Lock Management	\N	integer	-2 (disabled)	\N	\N
log_planner_stats	Statistics	Monitoring	bool	off	default	Used for profiling the query planner.
log_replication_commands	Reporting and Logging	What to Log	bool	off	on	… assuming you're monitoring replication status, which you should.
log_rotation_age	Reporting and Logging	Where to Log	integer	1440	default	1d is generally good for production.  Set to 1h to rotate logs hourly when doing performance analysis.
log_rotation_size	Reporting and Logging	Where to Log	memory	10MB	1GB	Default is quite small if you have any extra logging turned on at all.  Increase to avoid the creation of additional log segments with hard-to-predict names.
log_statement	Reporting and Logging	What to Log	ENUM	none	varies	For exhaustive performance analysis on test systems, set to 'all'.  Most production setups will just want to use 'ddl' to make sure to record database-altering actions, but very secure setups may want to use 'mod' or even 'all'.  Can produce a lot of log volume.
log_statement_stats	Statistics	Monitoring	bool	off	default	Used for full query path profiling.  Exclusive of the other three options.
log_temp_files	Reporting and Logging	What to Log	memory	-1	varies	This logger is used for troubleshooting sorts and other activities which are spilling to disk.  If you use it at all, it's probably good to set it a something low like 1kB so that you know each query that spilled to disk, since any disk spill at all causes a dramatic slowdown in the query.  Can be used to see if you need more work_mem, temp_mem or maintenance_work_mem.
log_timezone	Reporting and Logging	What to Log	string	per ENV	local timezone	To avoid confusion, it's often useful to log to the timezone where the DBA or sysadmin lives.
log_truncate_on_rotation	Reporting and Logging	Where to Log	bool	off	on	Set to “on” for production with a reusable logfile name to limit log accumulation if you don't have a sysadmin script to do so.
maintenance_work_mem	Maintenance	Memory	integer	16MB	( AvRAM / 8 ) for most	Sets the limit for the amount that autovacuum, manual vacuum, bulk index build and other maintenance routines are permitted to use.  Setting it to a moderately high value will increase the efficiency of vacuum and other operations.  Applications which perform large ETL operations may need to allocate up to 1/4 of RAM to support large bulk vacuums.  Note that each autovacuum worker may use this much, so if using multiple autovacuum workers you may want to decrease this value so that they can't claim over 1/8 or 1/4 of available RAM.
max_connections	Connections and Authentication	Connection Settings	integer	100	under 1000	Should be set to the maximum number of connections which you expect to need at peak load.  Note that each connection uses shared_buffer memory, as well as additional non-shared memory, so be careful not to run the system out of memory.  In general, if you need more than 200 connections, you should probably be making more use of connection pooling.
max_files_per_process	Resource Usage	Kernel Resources	integer	1000	default	If you have a large database with many partitioned tables, you may want to increase this.  Note that you will probably have to increase ulimits for the postgres user or system as well.
max_function_args	Preset Options	\N	integer	100	N/A	Informational: lets you know of non-standard installation or compile options.
max_identifier_length	Preset Options	\N	integer	63	N/A	Informational: lets you know of non-standard installation or compile options.
max_index_keys	Preset Options	\N	integer	32	N/A	Informational: lets you know of non-standard installation or compile options.
max_locks_per_transaction	Lock Management	\N	integer	64	default	Some databases with very complex schema or with many long-running tranactions need a higher amount.  This is rare though.
max_logical_replication_workers	Replication	Standby Options	integer	4	default	… unless logical replication is falling behind and the replica isn't handling other traffic
max_parallel_workers	Resource Usage	CPU	integer	8	cores/2	…  if you think you can benefit from parallel query, and even cores/1 for DW systems.
max_parallel_workers_per_gather	Query Tuning	Parallel Query	integer	2	increase	Increase if you plan to use parallel query to 4 or 8, depending on cores/concurrent sessions. 
max_pred_locks_per_transaction	Lock Management	\N	integer	64	default	Raise if you have a lot of tables and are seeing some transactions fail, but modestly as a larger transaction table is expensive.
max_prepared_transactions	Resource Usage	Memory	integer	5	0 or max_connections	Most applications do not use XA prepared transactions, so should set this parameter to 0.  If you do require prepared transactions, you should set this equal to max_connections to avoid blocking.  May require increasing kernel memory parameters.
max_replication_slots	Replication	Master Options	integer	10	max replicas * 2	Set to twice as many replicas as you ever expect to have.
max_stack_depth	Resource Usage	Kernel Resources	memory	2MB	default	Increase this if you have experienced the relevant error.
max_standby_archive_delay	Replication	Standby Options	integer	30000	\N	If you are replicating primarily for failover, set this to a very low value (like 0) in order to keep the standby as up to date as possible.  If this standby is running queries as its primary role, set to the length of time of the longest-running query you want to allow.
max_standby_streaming_delay	Replication	Standby Options	integer	30000	\N	If you are replicating primarily for failover, set this to a very low value (like 0) in order to keep the standby as up to date as possible.  If this standby is running queries as its primary role, set to the length of time of the longest-running query you want to allow.
max_sync_workers_per_subscription	Replication	Standby Options	integer	2	default	Consider raising to cores/2 when initially synchronizing logical replication for a new replica.
max_wal_senders	Replication	Master Options	integer	10	Max replicas you expect to have, doubled	If you are replicating, you want to set this to the maximum number of standby servers you might possibly have.  Performance impact when set above zero, but no additional penalty for setting it higher.
max_wal_size	WAL and Checkpoints	Settings	memory	1GB	default	… except for databases that write more than 1GB/hour of data, in which case increase the size of the log so that it's at least an hour worth of logs
max_worker_processes	Resource Usage	CPU	integer	8	increase	Increase to max_parallel_workers + other workers, such as workers for logical replication and custom background workers.  Not more than your number of cores, though.
min_parallel_index_scan_size	Query Tuning	Parallel Query	memory	512kB	default	\N
min_parallel_table_scan_size	Query Tuning	Parallel Query	memory	8MB	default	… , unless doing IoT or a read-only database.  Raise to 100MB or so if your traffic on the database is very bursty, to prevent the WAL from shrinking too much.
min_wal_size	WAL and Checkpoints	Settings	memory	80MB	default	\N
old_snapshot_threshold	Other Settings & Defaults	Timeouts	time	-1 (disabled)	2hrs	… or the length of the longest transaction you expect to run + 1 hour.
operator_precedence_warning	Other Settings & Defaults	Previous PostgreSQL Versions	bool	off	default	\N
parallel_setup_cost	Query Tuning	Parallel Query	real	1000	default	\N
password_encryption	Connections and Authentication	Security and Authentication	bool	on	on	There is no good reason for this to be set to “off”.
port	Connections and Authentication	Connection Settings	integer	5432	default	Alternate ports are primarily useful for running several versions, or instances, of PostgreSQL on one machine.  However, if you're using an alternate port to support several versions, it's often better to compile in the port number.
post_auth_delay	Developer Options	\N	integer	0	default	Primarily used for attaching debuggers to sessions.
pre_auth_delay	Developer Options	\N	integer	0	default	Primarily used for attaching debuggers to sessions.
quote_all_identifiers	Other Settings & Defaults	Previous PostgreSQL Versions	bool	off	default	\N
ssl_ecdh_curve	Connections and Authentication	Security and Authentication	\N	prime256v1	config	According to your SSL configuration, which maybe provided by your installer.
random_page_cost	Query Tuning	Planner Cost Constants	real	4	default	Sets the ratio of seek to scan time for your database storage.  Should not be altered unless you're using special storage (SSDs, high end SANs, etc.) where seek/scan ratios are actually different.  If you need the database to favor indexes more, tune effective_cache_size and some of the cpu_* costs instead.
replacement_sort_tuples	Query Tuning	Other Planner Options	integer	150000	0	Disable, this setting will be removed from Postgres 11.
restart_after_crash	Other Settings & Defaults	Other Defaults	bool	off	default	…  unless deliberately running postgres in “ephemeral mode”
row_security	Other Settings & Defaults	Other Defaults	bool	on	on	…  except when testing row security policies.
search_path	Other Settings & Defaults	Default Locations	list	"$user",public	varies	Most DBAs either use the default or set search_path on a ROLE or database object basis.  The one reason to set it in postgresql.conf is if you are taking the security step of removing the special "public" schema in order to lock down your database.
segment_size	Preset Options	\N	integer	131072	\N	Informational: lets you know of non-standard installation or compile options.
seq_page_cost	Query Tuning	Planner Cost Constants	real	1	default	The main reason to modify seq_page_cost is to try to get planner costs to more-or-less indicate execution times in milleseconds.  All other costs change relative to this cost automatically.
server_encoding	Locale & Formatting	Locale	string	per ENV	N/A	Set at initdb time.  Displayed for information only.
server_version	Preset Options	\N	string	08/03/00	N/A	Informational: lets you know of non-standard installation or compile options.
server_version_num	Preset Options	\N	integer	80300	N/A	Informational: lets you know of non-standard installation or compile options.
session_preload_libraries	Other Settings & Defaults	Other Defaults	string	NULL	default	Special uses for debugging or for loading application-specific extensions.
session_replication_role	Other Settings & Defaults	Replication	ENUM	origin	default	Only gets changed for databases which are taking part in a replication chain.  In that case, "origin" servers fire replication (and other) triggers, and "replica" do not.  Part of the generic replication hooks which are used by Slony and Bucardo.
shared_buffers	Resource Usage	Memory	memory	varies 512kB to 8MB	AvRAM / 4	A memory quantity defining PostgreSQL's "dedicated" RAM, which is used for connection control, active operations, and more.  However, since PostgreSQL also needs free RAM for file system buffers, sorts and maintenance operations, it is not advisable to set shared_buffers to a majority of RAM.   Note that increasing shared_buffers often requires you to increase some  system kernel parameters, most notably SHMMAX and SHMALL.  See  Operating System Environment: Managing Kernel Resources in the PostgreSQL documentation for more details.  Also note that shared_buffers over 2GB is  only supported on 64-bit systems.
shared_preload_libraries	Resource Usage	Kernel Resources	string	\N	default	Primarily used for custom C libraries (data types, stored procedures) which you expect your application to use heavily.  Trades memory overhead for these libraries against load time, so really should only be used for libraries you expect most queries to require.
ssl	Connections and Authentication	Security and Authentication	bool	off	on	One of several different settings to turn on SSL connections for PostgreSQL.  SSL is a very good idea for highly secure setups.  In addition, you must compile in SSL support and set SSL connections in pg_hba.conf, as well as configuring SSL itself.
ssl_ca_file	Connections and Authentication	Security and Authentication	\N	\N	config	You should always use SSL connections if you can.  However, this does require setting up SSL.
ssl_cert_file	Connections and Authentication	Security and Authentication	\N	server.crt	config	According to your SSL configuration, which maybe provided by your installer.
ssl_ciphers	Connections and Authentication	Security and Authentication	string	HIGH:MEDIUM:+3DES:!aNULL	default	Allows DBAs to require “strong enough” or preset ciphers for SSL connections.  If you have not compiled SSL support, this parameter will not be available.
ssl_crl_file	Connections and Authentication	Security and Authentication	\N	\N	config	According to your SSL configuration, which maybe provided by your installer.
ssl_dh_params_file	Connections and Authentication	Security and Authentication	\N	\N	config	According to your SSL configuration, which maybe provided by your installer.
ssl_key_file	Connections and Authentication	Security and Authentication	\N	server.key	config	According to your SSL configuration, which maybe provided by your installer.
ssl_prefer_server_ciphers	Connections and Authentication	Security and Authentication	\N	on	config	According to your SSL configuration, which maybe provided by your installer.
standard_conforming_strings	Version and Platform Compatibility	Previous PostgreSQL Versions	bool	off	on	If you can clean up your application code, this disables use of \\ as an escape character except in escaped (E' ') strings.  This is both safer, and less likely to result in unexpected output for things like Windows filepaths.
statement_timeout	Other Settings & Defaults	Statement Behavior	time	0	varies	Defaults to 0, meaning no timeout.  For most web applications, it's a good idea to set a default timeout, such as 60s to prevent runaway queries from bogging the server.  If set, though, you need to remember to set (at the ROLE or session level) a higher statement_timeout for expected long-running maintenance or batch operations.
stats_temp_directory	Statistics	Query and Index Statistics Collector	string	pg_stat_tmp	default	Useful for extremely high-volume databases; the stats temp directory could be set to a RAMdisk or other high-speed resource (at the cost of potentially losing some stats) as this file gets updated hundreds of times per second.  
superuser_reserved_connections	Connections and Authentication	Connection Settings	integer	3	default	You should have at least one superuser connection open for troubleshooting at all times.  So if you run more than two concurrent regular administrative tasks, you'll need more reserved connections.  Note that this number is taken from max_connections, not in addition to it.
synchronize_seqscans	Version and Platform Compatibility	Previous PostgreSQL Versions	bool	on	on	This new peformance enhancment can also cause rows to be returned in an order other than physical storage order.  For poorly-written older applications, this may break application code; turn it off to disable.
synchronous_commit	WAL and Checkpoints	Synch to Disk	bool	on	on	If data integrity is less important to you than response times (for example, if you are running a social networking application or processing logs) you can turn this off, making your transaction logs asynchronous.  This can result in up to wal_buffers or wal_writer_delay * 2 worth of data in an unexpected shutdown, but your database will not be corrupted.  Note that you can also set this on a per-session basis, allowing you to mix “lossy” and “safe” transactions, which is a better approach for most applications.
synchronous_standby_names	Replication	Master Options	string	NULL	default	Special, see syntax for sync standby config.  Don't get into this if you're not sure what you're doing.
syslog_facility	Reporting and Logging	Where to Log	string	LOCAL0	varies	Change the logserver facility if you are having a conflict with other applications.
syslog_ident	Reporting and Logging	Where to Log	string	postgres	POSTGRES_$HOST	If using a centralized logserver or if you have multiple Postgres instances, you probably want to identify your postgresql instance by hostname.
syslog_sequence_numbers	Reporting and Logging	What to Log	bool	on	default	\N
syslog_split_messages	Reporting and Logging	What to Log	bool	on	default	\N
tcp_keepalives_count	Connections and Authentication	Connection Persistence	integer	0	default	The three tcp_keepalive settings help manage a system which tends to have "undead" connection/query processes.  For systems which support them, you can regulate checking that connections are still "live" end-to-end to kill them off.  Not needed if you're not having a problem.  Should be synchronized with the new TCP keepalive support in libpq on the client side.
tcp_keepalives_idle	Connections and Authentication	Connection Persistence	integer	0	default	\N
tcp_keepalives_interval	Connections and Authentication	Connection Persistence	integer	0	default	\N
temp_buffers	Resource Usage	Memory	memory	8MB	default	Currently used only for holding temporary tables in memory.  If your application requires heavy use of temporary tables (many proprietary reporting engines do) then you might want to increase this substantially.  However, be careful because this is non-shared RAM which is allocated per session.  Otherwise, the default is fine.
temp_file_limit	Resource Usage	Disk	memory	-1 (disabled)	10GB	… or something which is bigger than your largest possible sort, but not big enough to run you out of disk space.
temp_tablespaces	Other Settings & Defaults	Default Locations	list	\N	default	For applications which create lots of temporary objects, this setting can be used to put the temp space on a faster/separate device, or even a ramdisk.  Because it accepts a list, it can even be used to load balance temp object creation among several tablespaces.
TimeZone	Locale & Formatting	Display	string	per ENV	default	To avoid a lot of confusion, make sure this is set to your local timeszone.  If the server covers multiple time zones, then this should be set on a ROLE or connection basis.
timezone_abbreviations	Locale & Formatting	Display	string	Default	default	See appendencies for alternatives.
trace_notify	Developer Options	\N	bool	off	default	The various TRACE options are for debugging specific behaviors interactively. Many of them require compile-time options. trace_notice is for debugging listen/notice.
trace_recovery_messages	Developer Options	\N	enum	log	\N	For troubleshooting replication/PITR failures.
trace_sort	Developer Options	\N	bool	off	default	For debugging sorts.
track_activities	Statistics	Query and Index Statistics Collector	bool	on	default	\N
track_activity_query_size	Statistics	Query and Index Statistics Collector	integer	1024	default	Sets the truncation threshold of queries in pg_stat_activity (and pg_stat_statements).  Increase it if you have really long queries which are being cut off, but there is significant extra memory usage for keeping longer queries.
track_commit_timestamp	Replication	Master Options	bool	off	on	\N
track_counts	Statistics	Query and Index Statistics Collector	bool	on	default	Needed for autovacuum to work properly.  Do not turn off.
track_functions	Statistics	Query and Index Statistics Collector	enum	None	pl	Set it to 'pl' to collect stats on user-defined functions.  Very useful for stored procedure performance profiling and troubleshooting.
track_io_timing	Statistics	Query and Index Statistics Collector	bool	off	default	Turn it on if you're monitoring disk usage per request.
transaction_deferrable	Other Settings & Defaults	Statement Behavior	bool	off	\N	\N
transaction_isolation	Other Settings & Defaults	Statement Behavior	string	read committed	\N	Set per session if you need, for example, SERIALIZABLE semantics to prevent data conflicts for multi-step transactions.
transaction_read_only	Other Settings & Defaults	Statement Behavior	bool	off	\N	Sets the current transaction to read only.  Useful as part of a SQL injection prevention program.  Shows as TRUE on replication standbys.
transform_null_equals	Version and Platform Compatibility	Other Platforms and Clients	bool	off	off	Provided for compatibility with Microsoft Access and similar broken applications which treat "= NULL" as the same as "IS NULL".  
unix_socket_directories	Connections and Authentication	Connection Settings	string	/tmp	change	Change to a more secure directory, which many installers do for you.
unix_socket_group	Connections and Authentication	Connection Settings	string	NULL	postgres	\N
unix_socket_permissions	Connections and Authentication	Connection Settings	integer	777	770	\N
update_process_title	Statistics	Query and Index Statistics Collector	bool	on	default	Updates the process title on OSes which support this.  Very useful for checking resource usage by currently running queries.
vacuum_cost_delay	Maintenance	Manual Vacuum	integer	0	\N	Most of the time, you will want manual vacuum to execute without vacuum_delay, especially if you're using it as part of ETL.  If for some reason you can't use autovacuum on an OLTP database, however, you may want to increase this to 20ms to decrease the impact vacuum has on currently running queries.  Will cause vacuum to take up to twice as long to complete.
vacuum_cost_limit	Maintenance	Manual Vacuum	integer	200	default	\N
vacuum_cost_page_dirty	Maintenance	Manual Vacuum	integer	20	default	\N
vacuum_cost_page_hit	Maintenance	Manual Vacuum	integer	1	default	\N
vacuum_cost_page_miss	Maintenance	Manual Vacuum	integer	10	default	\N
vacuum_defer_cleanup_age	Replication	Master Options	integer	0	0	No longer effective thanks to hot_standby_feedback.
vacuum_freeze_min_age	Maintenance	Manual Vacuum	integer	50000000	lower, varies	Most users will want to decrease this so that rows which have been cold for a long time get frozen earlier, and avoid an autovacuum_freeze.  The suggestion of 500000 is for a moderately busy database; do not set to less than a few hours worth of XIDs.  Maximum setting is 1/2 of autovaccuum_max_freeze_age.
vacuum_freeze_table_age	Maintenance	Manual Vacuum	integer	150000000	400000000	Generally set to 80% of autovacuum_max_freeze age to preempt a full vacuum freeze.  If you can schedule cron vacuums during application slow periods, it might be valuable to lower this value in order to encourage vacuum freezing of tables before they are triggered by autovacuum.
vacuum_multixact_freeze_min_age	Maintenance	Manual Vacuum	integer	5000000	lower, varies	Like freeze_min_age, lower this to somewhere around an hour of XID burn.  Try starting with 500000.
vacuum_multixact_freeze_table_age	Maintenance	Manual Vacuum	integer	150000000	350000000	Set to 80% of autovaccum_multixact_freeze_max_age
wal_block_size	Preset Options	\N	integer	8192	\N	Informational: lets you know of non-standard installation or compile options.
wal_buffers	WAL and Checkpoints	Memory	memory	-1 auto	default	On very busy, high-core machines it can be useful to raise this to as much as 128MB.
wal_compression	WAL and Checkpoints	Settings	bool	off	on	… unless your storage is less constrained than your CPU.
wal_consistency_checking	Developer Options	\N	string	empty	debugging only	\N
wal_keep_segments	Replication	Master Options	integer	0	8 to 128	… if using replication.  Minimum number of WAL log segments to keep in order to support re-synchronizing streaming standby servers which have fallen behind or for an initial sync, a good rule of thumb is 4, or however many segments you go through in 30s, whichever is higher. This is in addition to max_wal_size, so make sure you have enough disk space.  Not required if you are archiving logs.
wal_level	Replication	Master Options	enum	replica	replica or logical	Level replica is required for binary replication, and level logical is required for logical replication.  This is a setting because raising the level adds more writes to the WAL, so if you’re not doing replication or archiving at all, set it to minimal.
wal_log_hints	WAL and Checkpoints	Settings	\N	off	off	\N
wal_receiver_status_interval	Replication	Standby Options	time	10sec	default	\N
wal_receiver_timeout	Replication	Standby Options	time	60sec	default	\N
wal_retrieve_retry_interval	Replication	Standby Options	time	5sec	default	\N
wal_segment_size	Preset Options	\N	integer	2048	\N	Informational: lets you know of non-standard installation or compile options.
wal_sender_timeout	Replication	Master Options	time	60sec	default	\N
wal_sync_method	WAL and Checkpoints	Synch to Disk	string	OS-dependent	default	On install, PostgreSQL figures out the best method for your OS.  It's pretty good at this point; don't change the default.  Note that the value of "fsync" shown in your postgresql.conf file is not necessarily the setting the server is using; try SHOW instead.
wal_writer_delay	WAL and Checkpoints	Synch to Disk	integer	200	default	Defines the maximum data (in time) that can be lost if synchronous_commit=off and the database shuts down.  Because of long transactions, actual data lost can be up to twice this time.  Has no effect if synchronous_commit=on.  If you are going to turn synchronous_commit=off server-wide, you should probably lower this to prevent too much data loss.
wal_writer_flush_after	WAL and Checkpoints	Synch to Disk	memory	1MB	default	\N
work_mem	Resource Usage	Memory	integer	1MB	( AvRAM / max_connections ) OR ( AvRAM / 2 * max_connections )	Sets the limit for the amount of non-shared RAM available for each query operation, including sorts and hashes.  This limit acts as a primitive resource control, preventing the server from going into swap due to overallocation.  Note that this is non-shared RAM per operation, which means large complex queries can use multple times this amount.  Also, work_mem is allocated by powers of two, so round to the nearest binary step.  The second formula is for reporting and DW servers which run a lot of complex queries.
xmlbinary	Other Settings & Defaults	XML	ENUM	base64	varies	Set to whatever your client application supports.
xmloption	Other Settings & Defaults	XML	ENUM	content	default	\N
zero_damaged_pages	Developer Options	\N	bool	off	off	Used for salvaging data from a known-bad database.  You should always make a binary backup before using this option, and it should not be used while users are allowed to connect.  After damaged pages are erased, other kinds of data intergrity errors may persist (like broken PKs and FKs).  ZDP should generally be used to get your DB to a stage where the data can be dumped and loaded into a new database.
autovacuum_analyze_scale_factor	Maintenance	Autovacuum	real	0.1	default	This setting should be optimal for most databases.  However, very large tables (1m rows or more) in which rows are added in a skewed fashion may need to be autoanalyzed at a lower percentage, such as 5% or even 1%.
autovacuum_vacuum_scale_factor	Maintenance	Autovacuum	real	0.2	default	\N
parallel_tuple_cost	Query Tuning	Parallel Query	real	0.1	default	\N
cpu_index_tuple_cost	Query Tuning	Planner Cost Constants	real	0.005	0.001	Decrease this slightly to make your database favor indexes slightly more.
cpu_operator_cost	Query Tuning	Planner Cost Constants	real	0.0025	0.0005	Decrease this slightly to make your database favor indexes slightly more.
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: jberkus
--

COPY public.categories (category, category_sort) FROM stdin;
File Locations	1
Connections and Authentication	2
Resource Usage	3
WAL and Checkpoints	4
Query Tuning	6
Statistics	7
Maintenance	8
Customized Options	15
Developer Options	16
Locale & Formatting	11
Lock Management	10
Reporting and Logging	9
Version and Platform Compatibility	14
Preset Options	13
Other Settings & Defaults	12
Replication	5
\.


--
-- Data for Name: subcategories; Type: TABLE DATA; Schema: public; Owner: jberkus
--

COPY public.subcategories (category, subcategory, subcategory_sort) FROM stdin;
Client Connection Defaults	Locale and Formatting	3
Client Connection Defaults	Statement Behavior	2
Connections and Authentication	Connection Persistence	4
Connections and Authentication	Connection Settings	3
Connections and Authentication	Security and Authentication	2
Locale & Formatting	Display	2
Locale & Formatting	Locale	3
Maintenance	Autovacuum	4
Maintenance	Free Space Map	5
Maintenance	Manual Vacuum	3
Maintenance	Memory	2
Other Settings & Defaults	Default Locations	2
Other Settings & Defaults	Libraries	3
Other Settings & Defaults	Other Defaults	8
Other Settings & Defaults	Replication	4
Other Settings & Defaults	Statement Behavior	5
Other Settings & Defaults	Text Search	6
Other Settings & Defaults	XML	7
Query Tuning	Genetic Query Optimizer	4
Query Tuning	Planner Cost Constants	2
Query Tuning	Planner Method Configuration	3
Reporting and Logging	What to Log	4
Reporting and Logging	When to Log	3
Reporting and Logging	Where to Log	2
Resource Usage	Kernel Resources	3
Resource Usage	Memory	2
Statistics	Monitoring	2
Statistics	Query and Index Statistics Collector	3
Version and Platform Compatibility	Other Platforms and Clients	2
Version and Platform Compatibility	Previous PostgreSQL Versions	3
WAL and Checkpoints	Archiving	2
WAL and Checkpoints	Background Writer	7
WAL and Checkpoints	Checkpoints	6
WAL and Checkpoints	Commit Settings	5
WAL and Checkpoints	Memory	3
WAL and Checkpoints	Synch to Disk	4
Customized Options		2
Developer Options		2
File Locations		2
Lock Management		2
Preset Options		2
Resource Usage		4
\N		2
Resource Usage	Asynchronous Behavior	4
Replication	Master Options	2
Replication	Standby Options	3
Other Settings & Defaults	Identification	1
Query Tuning	Parallel Query	5
Query Tuning	Other Planner Options	6
Resource Usage	CPU	1
Resource Usage	Disk	5
WAL and Checkpoints	Settings	1
\.


--
-- Name: annotated annotated_pk; Type: CONSTRAINT; Schema: public; Owner: jberkus
--

ALTER TABLE ONLY public.annotated
    ADD CONSTRAINT annotated_pk PRIMARY KEY (name);


--
-- PostgreSQL database dump complete
--

