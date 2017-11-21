---
layout: "post"
title: "Suggested database setup"
author: "Marcelo Eduardo Redoschi"
date: "2017-11-19 18:26"
---
# Suggested database setup (postgres)

These instructions are provided for completeness, since this database setup is fairly common among many Rails applications.

They should work comparably well on both Linux and Mac machines.

## 1. PGDATA environment variable

### a) Existence verification

```
$ echo $PGDATA
/usr/local/var/postgres
```
*The actual location may be different, depending on your installation details.*

If you get something similar to this, that's great.  It means the variable was already set.  Proceed to step 2 directly.

### b) Export (set) the **Postgres data directory** variable

You must manually set the variable to the appropriate path.
```
export PGDATA='/usr/local/var/postgres'
```

Hint: you may wish to add the line with the appropriate path for your system to  **$HOME/.bashrc** (in case you are using bash). file.

If unsure what this path is, you may try the optional step below ->

### c) Optional (find out the data directory location using **psql**)

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

## 2. Add database entries to **pg_hba.conf** and restrict password less access.

You may do this step either on the command line or with some graphical text editor.

Checklist: make sure you have write permissions for this file or administrative (sudo)
access.

```
nano -c $PGDATA/pg_hba.conf
```
###

### a) Local environment
#### development database
> host  **gradcert_development** *gradcert*  127.0.0.1/32 md5
>
> local **gradcert_development** *gradcert*  md5

##### test database
> host  **gradcert_test** *gradcert*  127.0.0.1/32 md5
>
> local **gradcert_test** *gradcert*  md5

### b) Server environment

#### production database
> host  **gradcert_production** *gradcert*  127.0.0.1/32 md5
>
> local **gradcert_production** *gradcert*  md5

#### *Reminder: database user information*

When adding the database names to **pg_hba.conf** the user **gradcert** was specified.

> host  gradcert_development **gradcert**  127.0.0.1/32 md5

*There are corresponding entries for all other environments.*

#### c) Optional, but recommended.
##### Restrict password-less connections to the postgres user.

> \#"local" is for Unix domain socket connections only

Commented the this line
> \#local   all             all     trust
>
Restrict **trusted local connections** to the *postgres* user only (i.e. user allowed to login without a password).
> local  all postgres trust

*Likewise for **IPv4** and **IPV6** connections.*

> \# host    all             all             127.0.0.1/32            trust

> host    all             **postgres**        127.0.0.1/32            trust

> \# host    all             all             ::1/128            trust

> host    all             **postgres**       ::1/128            trust


### 3. Create the database user (also known as role).

#### Recommended: create the *psqlr* shell alias.

I suggest you create an **alias** (think of it as a kind of shorthand) to access Postgres via the command line more conveniently.

```
alias psqlr='psql -U postgres'
```
You may whish to it to your **$HOME/.bashrc** (or similar file).

#### Connect via the command line

```
psqlr
```
> psql (9.4.11)
>
> Type "help" for help.
>
> postgres=#

#### Create the *gradcert* role

```
postgres=# create role gradcert with encrypted password 'sample-db-password' login;
```
> CREATE ROLE

#### The role should appear on the list

```
postgres=# \dg
                               List of roles
   Role name   |                   Attributes                   | Member of
---------------+------------------------------------------------+-----------
 postgres      | Superuser, Create role, Create DB              | {}
gradcert      |                                                | {}
```
### 4. Create the databases

#### Development environment

```
postgres=# create database gradcert_development with owner gradcert;
```
> CREATE DATABASE

```
postgres=# create database gradcert_test with owner gradcert;
```

> CREATE DATABASE

##### Optional (verify the newly created databases appear on the list.)
```
postgres=# \l
                                      List of databases
           Name            |     Owner     | Encoding | Collate | Ctype |  Access privileges
---------------------------+---------------+----------+---------+-------+---------------------
gradcert_development       | gradcert      | UTF8     | pt_BR.utf8 | pt_BR.utf8 |
gradcert_test              | gradcert      | UTF8     | pt_BR.utf8 | pt_BR.utf8 |
```

#### Production environment

In a similar fashion, create the **gradcert_production** database.

#### Collation and encoding details

N.B. Depending on your region, language, and machine setup, collation and encoding information may be different than what is shown above.  Refer to the Postgres documentation for details. CREATE DATABASE accepts additional arguments.

### 5. Export (set) the database password variable

```
$ grep ENV config/database.yml
```

> \# url: <%= ENV['DATABASE_URL'] %>
>
> password: <%= ENV['GRADCERT_DATABASE_PASSWORD'] %>
>

```
export GRADCERT_DATABASE_PASSWORD='sample-db-password'
```

```
echo $GRADCERT_DATABASE_PASSWORD
```

> **sample-db-password**

This should match exactly with the **gradcert** database password defined previously (at the psql prompt).

### 6. Restart (or reload) Postgres

This will depending the version and environment used.

*For instance, on a Linux development machine (Centos).*

```
sudo service postgresql-9.4 restart
```

> Redirecting to /bin/systemctl restart  postgresql-9.4.service

### 7. Verify connection via the postgres prompt (recommended)

```
psql -d gradcert_development -U gradcert
```

> Senha para usuário gradcert:
>

*Enter password for the **gradcert** user*

>
> psql (9.4.12)
>
> Digite "help" para ajuda.
>
> **gradcert_development**=>
>

Looks good!  Connected to the database.

*control-D* exits.

Repeat this step for the **gradcert_test** (local machine) and **gradcert_production** as well (server), when needed.

### 8. Edit **config/database.yml**

> development:
>
> <<: *default
>
> database: gradcert_development
>
> **username: gradcert**
>
> **password: <%= ENV['GRADCERT_DATABASE_PASSWORD'] %>**

The lines to add are in bold.

Proceed in an analogous fashion for the test environment.

### 9. Finally, try to start the local server.

```
$ rails s
```
A message similar to the one below will appear, together with any deprecation warnings.

> => Rails 4.2.10 application starting in development on http://localhost:3000
>
> Listening on localhost:3000, CTRL+C to stop

Navigate with your web browser to http://localhost:3000.

The "Welcome aboard" page should appear.

---

```
rails new gradcert -d=postgresql -T --skip-gemfile --skip-bundle
```
---
##### Marcelo Eduardo Redoschi

##### Last updated: November 2017
