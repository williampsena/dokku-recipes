#!/bin/sh
option=${1:-empty}
dokku='docker exec -it dokku dokku'

is_container_healthy() {
    local state=$(docker inspect -f '{{ .State.Health.Status }}' dokku)

    if [ "$state" = "healthy" ]; then
        return 1
    else
        return 0
    fi
}

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

    local app="web"

    $dokku apps:create $app
    $dokku mongo:link default web

    $dokku nginx:stop
    $dokku caddy:start

    $dokku proxy:set $app caddy
    $dokku proxy:ports-clear $app
    $dokku proxy:ports-add $app http:80:80

    $dokku domains:enable $app
    $dokku domains:clear $app
    $dokku domains:add $app node.dokku.me

    $dokku proxy:build-config web

}

is_container_healthy

if [ $? -ne 1 ]; then
    echo "The Dokku container is not ready..."
    exit 1
fi

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
