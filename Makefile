build:
	cd server && $(MAKE) build
	cd client && $(MAKE) build

run:
	docker-compose up
	docker-compose up app db
	docker-compose run migrate

stop:
	docker-compose down

clean:
	docker-compose down -v 
