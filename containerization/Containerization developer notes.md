## Graduate certificate - Containerization development notes 

### 1) Database container

1. Build the Postgresql database container image 

    ``` 
    sudo docker build . -f containerization/dockerfiles/Dockerfile-alpine-postgres-15_5 -t alpine-postgres-15_5 --progress=plain 
    ```

2. Run the database container

     ```
    sudo docker run --env-file postgres_container_env -t alpine-postgres-15_5
     ```

--- 

Debugging steps (in case needed)


2.1    *If all goes well you should see something like this:*

    ```
    PostgreSQL init process complete; ready for start up.

    2024-01-23 17:25:01.923 UTC [1] LOG:  starting PostgreSQL 15.5 on x86_64-pc-linux-musl, compiled by gcc (Alpine 13.2.1_git20231014) 13.2.1 20231014, 64-bit
    2024-01-23 17:25:01.923 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
    2024-01-23 17:25:01.923 UTC [1] LOG:  listening on IPv6 address "::", port 5432
    2024-01-23 17:25:01.931 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
    2024-01-23 17:25:01.941 UTC [52] LOG:  database system was shut down at 2024-01-23 17:25:01 UTC
    2024-01-23 17:25:01.948 UTC [1] LOG:  database system is ready to accept connections

    ```

    *Obs: a simple way to stop the container is to type Control-C.* 

2.2 Open another window (or tab) and type the following commands:


    ```
    pg_container_id=$(sudo docker container list | grep alpine-postgres-15_5 | cut -d ' ' -f1)
    ```

    ```
    pg_container_ip=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $pg_container_id) 
    ```


2.3 Test the connection (optional but recommended)  

    ```
    export PGPASSWORD=$(cat postgres_container_env | head -1 | cut -d '=' -f2)
    ```

    ```
    psql -U postgres -h $pg_container_ip
    ```

N.B. In order to persist changes to the database, additional configuration would be required, for example a **volume** defined in a docker compose yml file.

--- 

### 2) Application container (Ruby environment)

i. Generate the application (RVM, Ruby, Rails) docker image 

    ``` 
    sudo docker build . -f containerization/dockerfiles/Dockerfile-ubuntu-rvm-ruby-3_0_6 -t ubuntu-rvm-ruby-3_0_6 --progress=plain
    ```

ii. Run the image

     ```
    sudo docker run -it ubuntu-rvm-ruby-3_0_6 /bin/bash -l
     ```


```
app_container_id=$(sudo docker container list | grep ruby-3\_0\_6 |  cut -d ' ' -f1)
```
    ```
    app_container_ip=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $app_container_id) 
    ```


iii. Test the connection (optional but recommended)  

    ```
    export PGPASSWORD=$(cat postgres_container_env | head -1 | cut -d '=' -f2)
    ```

    ```
    psql -U postgres -h $pg_container_ip
    ```

Obs: this approach was later refined.  Two Dockerfiles were used.  One to build a "base" rvm-ruby image and another for the application itself.

Marcelo Eduardo Redoschi

Last updated 

25 January 2024