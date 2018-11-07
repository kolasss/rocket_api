# README

Rocket API server

### Using:
* Ruby ~> 2.5.3
* Rails ~> 5.2.1
* MongoDb ~> 4.0.2

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
