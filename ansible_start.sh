#!/bin/bash

# Запуск контейнеров
docker run -d --name ubuntu ubuntu:latest
docker run -d --name centos7 centos7:latest

# Подождите, пока контейнеры запустятся
sleep 5

# Запуск ansible-playbook
ansible-playbook -i inventory/prod.yml site.yml  #--vault-password-file <(echo "netology")

# Остановка контейнеров
docker stop ubuntu
docker stop centos7

# Удаление контейнеров
docker rm ubuntu
docker rm centos7
