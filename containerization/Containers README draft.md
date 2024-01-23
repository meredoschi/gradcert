## Graduate certificate 

### Containerization (Work in progress)

#### Pre-requisite step:

Make sure that the container was built and runs fine.

Refer to the [Postgres container setup](Postgres_container_setup.md) for details.


--- 


```
/bin/bash --login 
```

```
rvm use ruby-3.0.6@gradcert
```

```
pg_container_id=$(sudo docker container list | grep alpine-postgres-15_5 | cut -d ' ' -f1)
```

```
pg_container_ip=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $pg_container_id) 
```

2. Test the connection (optional but recommended)

```
export PGPASSWORD=$(cat postgres_container_env | head -1 | cut -d '=' -f2)
```

```
psql -U postgres -h $pg_container_ip
```

At the postgres prompt type: 

```
postgres=# select * from version();
```

You should get something like this: 

```
                    version
------------------------------------------
PostgreSQL 15.5 on x86_64-pc-linux-musl, compiled by gcc (Alpine 13.2.1_git20231014) 13.2.1 20231014, 64-bit
(1 row)
```

```
\l+ gradcert*
```

You should get something similar to this: 

```
|  Size   | Tablespace | Description 
----------------------+----------+----------+------------+------------+------------+-----------------+-------------------+---------+------------+-------------
 gradcert_development | gradcert | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |                   | 7313 kB | pg_default | 
 gradcert_production  | gradcert | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |                   | 7313 kB | pg_default | 
 gradcert_test        | gradcert | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |                   | 7313 kB | pg_default | 
(3 rows)
```

Type **Control-D** to exit the postgres (psql) prompt.

3. Initialize the Rails development database

```
RAILS_ENV=development rake db:reset
```

Obs: this step may take some time to run, due to the (sample data) seeding process.

```
Dropped database 'gradcert_development'
Dropped database 'gradcert_test'
Created database 'gradcert_development'
Created database 'gradcert_test'
System
  ** Loading 'permissions'
  ** Loading 'roles'
Definitions
  ** Loading 'countries'
  ** Loading 'states'
  ** Loading 'stateregions'
  ** Loading 'municipalities'
  ** Loading 'streetnames'
  ** Loading 'schoolterms'
  ** Loading 'institutiontypes'
  ** Loading 'programnames'
  ** Loading 'taxations'
  ** Loading 'brackets'
[WARNING] The default rounding mode will change from `ROUND_HALF_EVEN` to `ROUND_HALF_UP` in the next major release. Set it explicitly using `Money.rounding_mode=` to avoid potential problems.
Institutions
  ** Loading 'institutions'
People
  ** Loading 'users'
```

Please note, in order to persist changes to the database, additional configuration is required, for example a **volume** defined in a docker compose yml file.

4. Initialize the Rails test database (optional)

```
Dropped database 'gradcert_test'
Created database 'gradcert_test'
```

5. Start rails (development environment) as usual

```
rails s
```

It was possible to log in to the application, referencing the containerized postgres environment, instead of the locally installed Postgres server previosly.

6. Next to do: "dockerize" the application's Ruby environment. 

Marcelo Eduardo Redoschi

January 2024