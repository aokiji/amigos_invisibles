# Setting up

Create a .env.production file with the following content

```
SMTP_USERNAME=username
SMTP_PASSWORD=password
POSTGRES_PASSWORD=pgpass
AMIGOS_INVISIBLES_DATABASE_PASSWORD=pgpass
SECRET_KEY_BASE=chorizosecreto
```

Then run

```
$ npm -g install bower
$ bower install
$ docker-compose -f docker/docker-compose.yml -f docker/docker-compose.production.yml build
$ docker-compose -f docker/docker-compose.yml -f docker/docker-compose.production.yml up -d
$ docker-compose -f docker/docker-compose.yml -f docker/docker-compose.production.yml run app rails assets:precompile
$ docker-compose -f docker/docker-compose.yml -f docker/docker-compose.production.yml run app rails db:seed
```
