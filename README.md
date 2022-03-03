# QuestionIt.space dev env

## Setup dev env

### Init database

```
docker volume create migrate_mysql_db
docker volume create psql_db

docker-compose up -d
docker-compose exec postgres psql -U postgres
=# create database questionit;
=# create user questionit SUPERUSER PASSWORD 'xxxxx';
=# \c questionit
=# CREATE EXTENSION unaccent;
=# \q

docker-compose exec api yarn run:migration
```

### Migrate

Obtain a dump ``questionit.sql``

```
docker-compose up -d mysql
docker-compose exec mysql mysql -u root -ppassword

> CREATE DATABASE questionit;
> CREATE USER 'questionit'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xxxx';
> GRANT ALL ON *.* TO 'questionit'@'localhost';
> exit;

docker exec -i questionit_mysql mysql -u root -ppassword questionit < questionit.sql

docker-compose run api yarn legacy:migrate
```
