build:
	docker build  -f docker/Dockerfile -t angegar/hybris:6.5.0.0 ./docker --no-cache

run: db_run
	docker run -d --name hybris -p 9001:9001 -p 9002:9002 \
		-v /c/git/angegar/hybris/hybrisServer_demo/hybris:/home/hybris \
		-e HYBRIS_DB_URL="jdbc:mysql://hybris-mysql:3306/database?useConfigs=maxPerformance&characterEncoding=utf8" \
		-e HYBRIS_DB_DRIVER=com.mysql.jdbc.Driver \
		-e HYBRIS_DB_USER=hybris \
		-e HYBRIS_DB_PASSWORD=hybris \
		hybris:latest

delete: db_delete
	docker rm -f hybris

db_run:	
	docker run -d --name hybris-mysql -e MYSQL_ROOT_PASSWORD=hybris stefanlehmann/hybris-mysql:latest

db_delete:
	docker rm -f hybris-mysql

up: 
	docker-compose up -d

down:
	docker-compose down

phpmyadmin:
	docker run --name hybris -d --link hybris-db:3306 -p 8080:80 phpmyadmin/phpmyadmin
