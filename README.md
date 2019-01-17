# docker-mongo-replicaset

Docker image for MongoDB Replica Set

## Getting started

You can use a `docker-compose.yml` like this

```yaml
version: '2'
services:
  mongo_1:
    image: mongo
    command: --smallfiles --replSet replSetName --quiet
  mongo_2:
    image: mongo
    command: --smallfiles --replSet replSetName --quiet
  mongo_3:
    image: mongo
    command: --smallfiles --replSet replSetName --quiet
  mongo_setup:
    image: ontherunvaro/mongo-replicaset-setup
    links:
      - mongo_1
      - mongo_2
      - mongo_3
    environment:
      REPLICA_SET_ID: replSetName
      PRIMARY_MEMBER: mongo_1:27017
      SECONDARY_MEMBERS: mongo_2:27017,mongo_3:27017
```

or deploy a swarm stack like this:

```yaml
version: '3.1'

services:
  mongo1:
    image: mongo
    hostname: mongo1
    networks:
      - mongo_replicas
    deploy:
      placement:
        constraints:
          - node.labels.mongo.replica==1
    command: mongod --replSet ${REPL_SET_NAME}

  mongo2:
    image: mongo
    hostname: mongo1
    networks:
      - mongo_replicas
    deploy:
      placement:
        constraints:
          - node.labels.mongo.replica==2
    command: mongod --replSet ${REPL_SET_NAME}
  
  mongo_setup:
    image: ontherunvaro/mongo-replicaset-setup
    deploy:
      restart_policy:
        condition: on-failure
        delay: 5s
    depends_on:
      - mongo1
      - mongo2
    networks:
      - mongo_replicas
    environment:
      REPLICA_SET_ID: ${REPL_SET_NAME}
      PRIMARY_MEMBER: mongo1:27017
      SECONDARY_MEMBERS: mongo2:27017

networks:
  mongo_replicas:
    driver: overlay
```

## Setup image

The Dockerfile in mongo-replicaset-setup is for initiating the Replica Set on the nodes before stopping.