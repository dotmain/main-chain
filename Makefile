build:
	cd server && $(MAKE) build
	cd client && $(MAKE) build
	docker-compose build

run:
	docker-compose up --detach app db
	docker-compose run migrate
	docker-compose up -d

rerun:
	docker-compose up --detach app db
	docker-compose up -d

stop:
	docker-compose down

clean:
	docker-compose down -v 
