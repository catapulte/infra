#!/bin/bash
set -e

mongod &
MONGO_PID=$!

USER=${MONGODB_USER:-"guest"}
PASS=${MONGODB_PASS:-"guest"}
DATABASE=${MONGODB_DATABASE:-"admin"}

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 1
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating a ${USER} user with a password in MongoDB"
mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'root',db:'admin'}]});"

if [ "$DATABASE" != "admin" ]; then
    echo "=> Setting ${USER}  user to own ${DATABASE} with a password in MongoDB"
    mongo admin -u $USER -p $PASS << EOF
use $DATABASE
db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE'}]})
EOF
fi

kill -15 $MONGO_PID
wait $MONGO_PID

echo "=> Passwords set"
echo "=> Starting mongodb"

/entrypoint.sh "$@"
