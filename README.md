# QuestionIt.space dev env

## Setup dev env

### Clone repositories

```sh
git clone git@github.com:alkihis/questionit.api-v2.git server
git clone git@github.com:alkihis/questionit.space-v2.git client
```

### Setup environment variables

Copy `bootstrap.env.dist` to `bootstrap.env`, and fill it with your own variables.

### Init project

You might need to install [`docker compose` v2 extension](https://docs.docker.com/compose/cli-command/#install-on-linux) if you're using Linux.

```sh
docker volume create migrate_mysql_db
docker volume create psql_db
docker volume create redis_single_persist

docker-compose up -d postgres
docker-compose exec postgres psql -U postgres

# Create database
=# CREATE DATABASE questionit;
=# \c questionit

# The super user, which can start migrations
=# CREATE USER questionitsu SUPERUSER PASSWORD 'xxxxx';
=# CREATE USER questionit NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD 'xxxxx';

# The regular user, used by the server
=# GRANT CONNECT ON DATABASE questionit TO questionit;
=# GRANT USAGE ON SCHEMA public TO questionit;
=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO questionit;

# Create unaccent extension
=# CREATE EXTENSION unaccent;
=# \q

docker-compose run api yarn run:migration
docker-compose down
```

### Start services

```sh
docker-compose up -d web
```

### Migrate

Migrate v1 beta to this dev platform.

Obtain a dump ``questionit.sql`` by your own needs

```sh
docker-compose up -d mysql
docker-compose exec mysql mysql -u root -ppassword

> CREATE DATABASE questionit;
> CREATE USER 'questionit'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xxxx';
> GRANT ALL ON *.* TO 'questionit'@'localhost';
> exit;

docker exec -i questionit_mysql mysql -u root -ppassword questionit < questionit.sql

docker-compose run api yarn legacy:migrate
# Use CTRL+C when migration is over
docker-compose down
```
