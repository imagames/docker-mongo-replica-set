# docker-mongo-replicaset

Docker image for MongoDB Replica Set

## Getting started

You can deploy this with a stack file like this:

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
    image: imagames/mongodb-replicaset-startup
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

You may also set all three of `PRIMARY_USER`, `PRIMARY_PASS` and `PRIMARY_DB` variables if authentication is needed to connect to the primary.

## Setup image

The Dockerfile in mongo-replicaset-setup is for initiating the Replica Set on the nodes before stopping.