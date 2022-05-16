# Start DEV by default
all: dev

# Stop and delete PROD container by default
stop: stop-prod rm-prod

logs:
	docker logs dbt_p

####### VARIABLES #######
CURR_DIR=$(shell basename $(PWD))
DOCKERFILE=Dockerfile
#########################
# Dev
dev: build-dbt-dev run-dbt-dev run-dbt-refresh

build-dbt-dev:
# cp source/dbt_project_dev.yml source/dbt_project.yml 
# docker build -t dbt_p -f Dockerfile_dev .
	docker-compose -p dbt_p build

run-dbt-dev: 
	docker-compose run --detach --name dbt_p --service-ports dbt docs serve --port 8001
	
run-dbt-refresh:
	docker exec -it $(shell docker ps -qf name=dbt_p) dbt compile

clean-dbt:
	docker stop dbt_p && docker rm dbt_p
#########################
# Prod
prod: build-dbt-prod run-dbt-prod install-ssh-agent

build-dbt-prod:
	docker build -t dbt_p -f Dockerfile_prod .

run-dbt-prod:
	docker run -d --net $(shell docker inspect airflow -f "{{json .NetworkSettings.Networks }}" | cut -d '"' -f2) --name dbt -p 8001:8001 -it dbt_p docs serve --port 8001

install-ssh-agent:
	docker exec dbt bash -c "chmod -R 777 target/"
	docker exec dbt bash -c "systemctl enable ssh"
	docker exec dbt bash -c "service ssh start"
	docker exec dbt bash -c "/usr/sbin/sshd -D &"
	docker exec dbt bash -c "useradd -m --no-log-init --system  --uid 1000 airflow -s /bin/bash -g sudo -G root"
	docker exec dbt bash -c "echo 'airflow:dbt_serve' | chpasswd"
	docker exec dbt bash -c "cp -r /root/.dbt /home/airflow"
	docker exec dbt bash -c "chmod -R 775 /source/logs"
###########################
