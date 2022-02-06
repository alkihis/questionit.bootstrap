# QuestionIt.space dev env

- Initialiser la base de données

```
docker-compose up -d
docker-compose exec postgres psql -u postgres
=# create database questionit;
=# create user questionit SUPERUSER PASSWORD 'xxxxx';
=# \q

docker-compose exec api yarn run:migration
```
