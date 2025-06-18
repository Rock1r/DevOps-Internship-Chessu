COMPOSE_FILE := docker-compose.yml

default: build up

build:
	docker-compose -f $(COMPOSE_FILE) build $(c)
up:
	docker-compose -f $(COMPOSE_FILE) up -d $(c)
up-scale:
	docker-compose -f $(COMPOSE_FILE) up -d \
		--scale chessu_server=$(servers)
start:
	docker-compose -f $(COMPOSE_FILE) start $(c)
down:
	docker-compose -f $(COMPOSE_FILE) down $(c)
destroy:
	docker-compose -f $(COMPOSE_FILE) down -v $(c)
stop:
	docker-compose -f $(COMPOSE_FILE) stop $(c)
restart:
	docker-compose -f $(COMPOSE_FILE) stop $(c)
	docker-compose -f $(COMPOSE_FILE) up -d $(c)
logs:
	docker-compose -f $(COMPOSE_FILE) logs --tail=100 -f $(c)
ps:
	docker-compose -f $(COMPOSE_FILE) ps