/* Marcelo Eduardo Redoschi */
/* Revised January 2024 */
create user gradcert with encrypted password 'sample-db-password' login createdb;
create database gradcert_test with owner gradcert;
create database gradcert_production with owner gradcert;
create database gradcert_development with owner gradcert;

/* Adapted from https://blog.dbi-services.com/modifying-pg_hba-conf-from-inside-postgresql/ */
create table hba ( lines text );
copy hba from '/var/lib/postgresql/data/pg_hba.conf';
insert into hba (lines) values ('local gradcert_development gradcert                               scram-sha-256');
insert into hba (lines) values ('local gradcert_test gradcert                               scram-sha-256');
insert into hba (lines) values ('local gradcert_production gradcert                               scram-sha-256');
insert into hba (lines) values ('host gradcert_development gradcert    all                           scram-sha-256');
insert into hba (lines) values ('host gradcert_test gradcert           all                     scram-sha-256');
insert into hba (lines) values ('host gradcert_production gradcert all                              scram-sha-256');
copy hba to '/var/lib/postgresql/data/pg_hba.conf';
select pg_reload_conf();