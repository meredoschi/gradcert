# Suggested database setup (postgres)

## 1. Data directory environment variable verification or setup
```
$ echo $PGDATA
/usr/local/var/postgres
```
The actual location may be different, depending on your installation details.

```
nano $PGDATA/pg_hba.conf
```
The location of Postgres' data directory may be queryied directly, if need be.  Then, I recommend you set the variable, for convenience.

At the command line, type:

```
psql -U postgres
```
Enter the postgres credentials, if needed.

Then at the postgres prompt, type:
```
show data_directory;
```
You should get something similar to this:

>  /usr/local/var/postgres
(1 row)

Then enter the appropriate command, according to your environment, to set the variable.

```
export PGDATA='/usr/local/var/postgres'
```
*The above command works on a Mac (OS X).*

Add the following entries:

## 2. Edit on pg_hba.conf

Open the file, with a suitable text editor.

It is assumed you'll do this an user with **the appropriate write privileges or permissions** for the PGDATA (postgres data directory) folder.

Add the following lines to the file:

```
nano -c $PGDATA/pg_hba.conf
```
### Local machine (or development server)

#### development
> host  **gradcert_development** **gcert**  127.0.0.1/32 md5
>
> local **gradcert_development** **gcert**  md5

##### test
> host  **gradcert_test** **gcert**  127.0.0.1/32 md5
>
> local **gradcert_test** **gcert**  md5

### Production server

#### production
> host  **gradcert_production** **gcert**  127.0.0.1/32 md5
>
> local **gradcert_production** **gcert**  md5
```
