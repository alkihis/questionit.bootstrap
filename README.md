# QuestionIt.space dev env

- [Client](https://github.com/alkihis/questionit.space-v2)
- [Server](https://github.com/alkihis/questionit.api-v2)

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

docker compose up -d postgres
docker compose exec postgres psql -U postgres

# Create database
=# CREATE DATABASE questionit;
=# \c questionit

# The super user, which can start migrations
=# CREATE USER questionitsu SUPERUSER PASSWORD 'xxxxx';
# The regular user, used by the server
=# CREATE USER questionit NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD 'xxxxx';

# Create unaccent extensioncd 
=# CREATE EXTENSION unaccent;
=# \q

docker compose build api
docker compose run -e NODE_ENV=development api yarn
# Needed to have dist/ folder
docker compose run -e NODE_ENV=production api yarn build

docker compose run api yarn run:migration

# Allow usage of db to classic user
docker compose exec postgres psql -U postgres

=# \c questionit
=# GRANT CONNECT ON DATABASE questionit TO questionit;
=# GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO questionit;
=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO questionit;
=# \q

docker compose down

docker compose build web
docker compose run -e NODE_ENV=development web yarn
```

### Start services

```sh
docker compose up -d web
```

### Migrate

Migrate v1 beta to this dev platform.

Obtain a dump ``questionit.sql`` by your own needs

```sh
docker compose up -d mysql
docker compose exec mysql mysql -u root -ppassword

> CREATE DATABASE questionit;
> CREATE USER 'questionit'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xxxx';
> GRANT ALL ON *.* TO 'questionit'@'localhost';
> exit;

docker exec -i questionit_mysql mysql -u root -ppassword questionit < questionit.sql

docker compose run api yarn legacy:migrate
# Use CTRL+C when migration is over
docker compose down
```

### Init for prod

```sh 
docker compose run -e NODE_ENV=production api yarn build
docker compose run -e NODE_ENV=production web yarn build
```

### Refresh and rebuild for prod

```sh 
cd client
git pull
cd ../server
git pull
cd ..

docker compose run -e NODE_ENV=production api yarn build
docker compose run -e NODE_ENV=production web yarn build

docker compose stop web && docker compose stop api
docker compose up -d web
```
