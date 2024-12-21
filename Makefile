all: up

up:
	mkdir -p /home/akambou/Desktop/Inception/srcs/wordpress
	mkdir -p /home/akambou/Desktop/Inception/srcs/mariadb
	docker-compose -f srcs/docker-compose.yml up -d --build

down:

	docker-compose -f srcs/docker-compose.yml down

clean: down
	sudo rm -rf /home/akambou/Desktop/Inception/srcs/mariadb
	sudo rm -rf /home/akambou/Desktop/Inception/srcs/wordpress

	docker system prune -af

re: clean all
