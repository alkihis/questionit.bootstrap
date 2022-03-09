
down:
	docker compose down

up:
	docker compose up -d

reboot: down up

update-server:
	cd server && git pull
	docker compose run -e NODE_ENV=production api yarn build

update-client:
	cd client && git pull
	docker compose run -e NODE_ENV=production web yarn build

update: update-server update-client

refresh: down
	cd server && git pull
	cd client && git pull
	docker compose run -e NODE_ENV=production api yarn build
	docker compose run -e NODE_ENV=production web yarn build
	docker compose up -d
