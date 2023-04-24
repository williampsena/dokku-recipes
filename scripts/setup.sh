#!/bin/sh
option=${1:-empty}
dokku='docker exec -it dokku dokku'

setup_dokku() {
    echo "Setting up dokku...\n"

    docker cp assets/id_rsa_dokku.pub dokku:/home/dokku/.ssh
    $dokku ssh-keys:add dokku /home/dokku/.ssh/id_rsa_dokku.pub
}

setup_mongo() {
    echo "Setting up mongo...\n"

    $dokku plugin:install https://github.com/dokku/dokku-mongo.git mongo

    $dokku mongo:create default
}

setup_app() {
    echo "Setting up app...\n"

    app="web"

    $dokku apps:create $app
    $dokku mongo:link default web
    $dokku config:set --no-restart $app SERVICE_PORT=8080

    $dokku nginx:stop
    $dokku caddy:start

    $dokku proxy:clear-config --all
    $dokku proxy:build-config --all
    $dokku proxy:set $app caddy
    $dokku proxy:ports-clear $app
    $dokku proxy:ports-add $app http:80:80

    $dokku domains:enable $app
    $dokku domains:clear $app
    $dokku domains:add $app node.dokku.me
}

case $option in
dokku)
    setup_dokku
    ;;
mongo)
    setup_mongo
    ;;
app)
    setup_app
    ;;
all)
    setup_dokku
    setup_mongo
    setup_app
    ;;
*)
    echo "Invalid option $option"
    ;;
esac
