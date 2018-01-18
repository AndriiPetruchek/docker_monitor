#!/bin/bash

ADMIN_USER=admin 
ADMIN_PASSWORD=admin


docker network create jmx_monitor

ADMIN_USER=$ADMIN_USER ADMIN_PASSWORD=$ADMIN_PASSWORD docker-compose up -d
