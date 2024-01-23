## Graduate certificate 

### Postgres container setup notes

#### Steps

1. Open a terminal window and change to the *containerization* directory 

     ```
     cd containerization
     ``` 

2. Generate the postgresql docker image 

    ``` 
    sudo docker build . -f dockerfiles/Dockerfile-alpine-postgres-15_5 -t alpine-postgres-15_5 --progress=plain 
    ```

3. Run the image

     ```
    sudo docker run --env-file postgres_container_env -it alpine-postgres-15_5
     ```

    *If all goes well you should see something like this:*

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

4. Open another window (or tab) and type the following commands:


    ```
    pg_container_id=$(sudo docker container list | grep alpine-postgres-15_5 | cut -d ' ' -f1)
    ```

    ```
    pg_container_ip=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $pg_container_id) 
    ```


5. Test the connection (optional but recommended)  

    ```
    export PGPASSWORD=$(cat postgres_container_env | head -1 | cut -d '=' -f2)
    ```

    ```
    psql -U postgres -h $pg_container_ip
    ```

N.B. In order to persist changes to the database, additional configuration would be required, for example a **volume** defined in a docker compose yml file.

Marcelo Eduardo Redoschi

January 2024