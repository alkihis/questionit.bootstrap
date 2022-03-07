
down:
	docker compose down

up:
	docker compose up -d

reboot: down up

refresh: down
	cd server
	git pull
	cd ../client
	git pull
	cd ..
	docker compose run -e NODE_ENV=production api yarn build
	docker compose run -e NODE_ENV=production web yarn build
	docker compose up -d
