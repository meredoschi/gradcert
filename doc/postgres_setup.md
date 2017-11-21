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

### b) Export (set) the variable

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

## 2. Add database entries to **pg_hba.conf**

You may do this step either on the command line or with some graphical text editor.

Checklist: make sure you have write permissions for this file or administrative (sudo)
access.

```
nano -c $PGDATA/pg_hba.conf
```
###

### a) Local environment
#### development database
> host  **enrollform_development** *enrollfrm*  127.0.0.1/32 md5
>
> local **enrollform_development** *enrollfrm*  md5

##### test database
> host  **enrollform_test** *enrollfrm*  127.0.0.1/32 md5
>
> local **enrollform_test** *enrollfrm*  md5

### b) Server environment

#### production database
> host  **enrollform_production** *enrollfrm*  127.0.0.1/32 md5
>
> local **enrollform_production** *enrollfrm*  md5

#### *Reminder: database user information*

When adding the database names to **pg_hba.conf**, we've also included the user name.  In this case, it is called **enrollfrm**.

> host  enrollform_development **enrollfrm**  127.0.0.1/32 md5

*There are corresponding entries for all other environments.*

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

#### Create the *enrollfrm* role

```
postgres=# create role enrollfrm with encrypted password 'sample-db-password' login;
```
> CREATE ROLE

#### The role should appear on the list

```
postgres=# \dg
                               List of roles
   Role name   |                   Attributes                   | Member of
---------------+------------------------------------------------+-----------
 postgres      | Superuser, Create role, Create DB              | {}
enrollfrm      |                                                | {}
```
### 4. Create the databases

#### Development environment

```
postgres=# create database enrollform_development with owner enrollfrm;
```
> CREATE DATABASE

```
postgres=# create database enrollform_test with owner enrollfrm;
```

> CREATE DATABASE

##### Optional (verify the newly created databases appear on the list.)
```
postgres=# \l
                                      List of databases
           Name            |     Owner     | Encoding | Collate | Ctype |  Access privileges
---------------------------+---------------+----------+---------+-------+---------------------
 enrollform_development    | enrollfrm     | UTF8     | C       | UTF-8 |
 enrollform_test           | enrollfrm     | UTF8     | C       | UTF-8 |

```

#### Production environment

In a similar fashion, create the **enrollform_production** database.

#### Collation and encoding details

N.B. Depending on your region, language, and machine setup, collation and encoding information may be different than what is shown above.  Refer to the Postgres documentation for details. CREATE DATABASE accepts additional arguments.

---
##### Marcelo Eduardo Redoschi

##### Last updated: November 2017
