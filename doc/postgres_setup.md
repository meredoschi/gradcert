---
title: "Suggested gradcert database setup"
author: "Marcelo Eduardo Redoschi"
---
# Suggested database setup (postgres)

These instructions are provided for completeness, since this database setup is fairly common among many Rails applications.  They should work comparably well on both Linux and Mac machines, with simple tweaks.

# 1. Cluster setup (in case of a brand new Postgres installation)

The location of these files may vary depending on your postgres version and operating system.

## createuser
```
/usr/local/Cellar/postgresql@9.6/9.6.7/bin/createuser -s postgres
```

## initdb

### International settings

```
/usr/local/Cellar/postgresql@9.6/9.6.7/bin/initdb *--lc-ctype=pt_BR.UTF-8* *--lc-collate=pt_BR.UTF-8* *--locale=pt_BR.UTF-8* -D /usr/local/var/postgresql@9.6.7
```
Depending on your set up, "international settings" (such as ctype, locale and collation) may be different from what is shown above.   

## alter postgres ROLE password

*It is good practice to set a password for the postgres system administrator role*
```
ALTER ROLE postgres with encrypted password 'some-random-password';
```



# 2. Set the environment variables

## a) *gradcert* specific
```
export GRADUATE_CERTIFICATE_DATABASE_PREFIX='gradcert_'
export GRADUATE_CERTIFICATE_DATABASE_USER='gradcert'
export GRADUATE_CERTIFICATE_DATABASE_PASSWORD='sample-db-password'
```

*You may wish to add the lines above to your shell environment file.*

## b) PGDATA (useful for all databases)

```
export PGDATA='/usr/local/var/postgres'
```

## c) Optional (use symlinks to organize the various versions, as time goes
  along and you decide to upgrade postgres)
```
$ ln -s /usr/local/var/postgresql@9.6.7 **/usr/local/var/postgres**
```

```
$ ls -l /usr/local/var | grep postgres
postgres -> postgresql@9.6.7/
```

## d) Optional (find out the data directory  location using **psql**)

**Depending on how your postgres server is configured, you may be prompted for a password.**

```
psql -U postgres
```

```
show data_directory;
```

>  /usr/local/var/postgres
(1 row)
This location may be different on your system

# 3. Add database entries to **pg_hba.conf** and restrict password less access.

You may do this step either on the command line or with some graphical text editor.

Checklist: make sure you have write permissions for this file or administrative (sudo)
access.

```
nano -c $PGDATA/pg_hba.conf
```

## a) Local environment
### development database
> host  **gradcert_development** *gradcert*  127.0.0.1/32 md5
>
> local **gradcert_development** *gradcert*  md5

### test database
> host  **gradcert_test** *gradcert*  127.0.0.1/32 md5
>
> local **gradcert_test** *gradcert*  md5

## b) Server environment

### production database
> host  **gradcert_production** *gradcert*  127.0.0.1/32 md5
>
> local **gradcert_production** *gradcert*  md5

### *Reminder: database user information*

When adding the database names to **pg_hba.conf** the user **gradcert** was specified.

> host  gradcert_development **gradcert**  127.0.0.1/32 md5

*There are corresponding entries for all other environments.*

## c) Optional, but recommended.
### Ask for password when connecting via the network (IPv4 and IPv6)  

pg_hba.conf

> \# TYPE  DATABASE        USER            ADDRESS                 METHOD

> \# IPv4 local connections:
>
> \#host    all            all             127.0.0.1/32            trust
>
> host    all             all             127.0.0.1/32            md5

> \# IPv6 local connections:
>
> host    all             all             ::1/128                 md5
>
> \#host    all             postgres             ::1/128            trust

# 4. Create the *gradcert* role

```
postgres=# create role gradcert with encrypted password 'sample-db-password' login createdb;
CREATE ROLE
```

## Optional (double check role creation)

```
postgres=# \dg gradcert

List of roles
Role name | Attributes | Member of
-----------+------------+-----------
gradcert  | Create DB  | {}

```

## Optional (create a shell alias)

```
alias psqlr='psql -U postgres'
```

# 5. Create, prepare the logical schema and populate the databases

## Development

```
rake db:create
```

```
rake db:migrate
```

```
rake db:seed
```

## Test

```
RAILS_ENV=test rake db:migrate
```

```
RAILS_ENV=test rake db:seed
```

# 6. Optional

## a) Get database details, including space usage

```
postgres=# \l+ gradcert*
                                                       List of databases
         Name         |  Owner   | Encoding |   Collate   |    Ctype    | Access privileges | Size  | Tablespace | Description
----------------------+----------+----------+-------------+-------------+-------------------+-------+------------+-------------
 gradcert_development | gradcert | UTF8     | pt_BR.UTF-8 | pt_BR.UTF-8 |                   | 10 MB | pg_default |
 gradcert_test        | gradcert | UTF8     | pt_BR.UTF-8 | pt_BR.UTF-8 |                   | 10 MB | pg_default |
(2 rows)
```

## b) Verify gradcert connection via the terminal

```
$ psql -d gradcert_development -U gradcert -h localhost
```

> Password for user gradcert:
> psql (9.6.7)
> Type "help" for help.

> gradcert_development=>

Looks good!  Connected to the database.

*control-D* exits.

# 7. Start the development server

```
$ rails s
```

#### For login credentials please refer to the *README* or take a look at the seed files directly.

---
##### Marcelo Eduardo Redoschi

##### Last updated: February 2018
