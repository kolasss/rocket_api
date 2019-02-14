# README

[![Maintainability](https://api.codeclimate.com/v1/badges/73fad8c1932d8c04834a/maintainability)](https://codeclimate.com/github/kolasss/rocket_api/maintainability)

Rocket API server

### Using:
* Ruby ~> 2.6.1
* Rails ~> 5.2.2
* MongoDb ~> 4.0.6
* Redis ~> 5.0.3

## Tests

run `bin/rspec`

### Swagger

prefix request specs files with number - to render swagger's json in order

generate swagger's json `RAILS_ENV=test bin/rake swagger`

## Deploy

- ssh to server
- cd dir
- git pull
- bundle
- run rake tasks if needed
- restart puma service
- restart sidekiq service

## Development

run sidekiq `bin/sidekiq`

seed with shops `bin/rails faker:shops`

run rubocop `bin/rubocop`

### Docker

build `docker-compose build`

run `docker-compose up`

run bash console in running container `docker-compose exec web bash`

run bash console in new container `docker-compose run web bash`

stop `docker-compose down`

need to rebuild after changing Gemfile/Gemfile.lock
`docker-compose up --build`

ports mapping in `docker-compose.yml`: "HOST:CONTAINER"
