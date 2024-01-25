## Graduate certificate - Containerization README

#### Helper scripts: 

1) Database container (Postgres version 15.5 on Alpine Linux)

[script1_postgres_container.bash](script1_postgres_container.bash) 

2) In another window (or tab), to build the docker image and run the container.

[script2_application_container.bash](script2_application_container.bash) 

Obs: you may need to adjust the ip of the database container appropriately for your environment in the [containerization/ruby_container_env](containerization/ruby_container_env) file.


```
GRADUATE_CERTIFICATE_DATABASE_HOST=172.17.0.2
```

3) Open a browser and navigate to 

http://172.17.0.3:3000/


Obs: you may need to substitute this with the actual address of application container.

--- 

Reminder: to stop the containers (optional) via the docker command line.

```
sudo docker container ls 
```

```
sudo docker container stop some_container_id 
```

--- 

Marcelo Eduardo Redoschi

25 January 2024