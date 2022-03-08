# QuestionIt.space developer environment

<p align="center" style="margin-top: 2rem">
    ![QuestionIt.space white logo](https://questionit.space/images/logo/BannerBlue.png#gh-dark-mode-only)
    ![QuestionIt.space blue logo](https://questionit.space/images/logo/BannerWhite.png#gh-light-mode-only)
    ![GitHub-Mark-Dark](https://user-images.githubusercontent.com/3369400/139448065-39a229ba-4b06-434b-bc67-616e2ed80c8f.png#gh-light-mode-only)
</p>

- [Nuxt.js Client](https://github.com/alkihis/questionit.space-v2)
- [Nest.js Server](https://github.com/alkihis/questionit.api-v2)

## Setup environment

Developer environment requires:
- A Docker compatible system
- Docker Compose v2 (Windows/Mac: bundled with Docker Desktop; Linux: see [`docker compose` v2 extension for linux](https://docs.docker.com/compose/cli-command/#install-on-linux)) 

### Clone repositories

```sh
git clone git@github.com:alkihis/questionit.bootstrap.git bootstrap
cd bootstrap

git clone git@github.com:alkihis/questionit.api-v2.git server
git clone git@github.com:alkihis/questionit.space-v2.git client
```

### Setup environment variables

Copy `bootstrap.env.dist` to `bootstrap.env`, and fill it with your own variables.

**Warning:** Fill `bootstrap.env` before starting any container!

### Init project

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
```

### Start services

```sh
docker compose up -d web
```
