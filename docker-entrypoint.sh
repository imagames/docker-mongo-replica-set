#!/bin/bash

set -e
echo -e "\033[1m Starting ReplicaSet configuration"

id=1
members=()
IFS=',' read -ra hosts <<< "${PRIMARY_MEMBER},${SECONDARY_MEMBERS}"
for host in "${hosts[@]}"; do
    members+=("{_id:${id},host:'${host}'}")
    ((id++))
done

members_js=`echo $(IFS=,; echo "${members[*]}")`
js="rs.initiate({_id:'${REPLICA_SET_ID}',members:[${members_js}]});"

if [[ -z "${PRIMARY_USER}" ]]
then
    echo "Connecting without authentication"
    mongo "${PRIMARY_MEMBER}" --eval "${js}"
else
    echo "Connecting with authentication"
    mongo "${PRIMARY_MEMBER}" -u "${PRIMARY_USER}" -p "${PRIMARY_PASSWORD}" --authenticationDatabase "${PRIMARY_DB}" --eval "${js}"
fi

echo -e "\033[1m Mongo is configured - stopping setup container"
