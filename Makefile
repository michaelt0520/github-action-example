setup:
	docker-compose run app bundle install
migrate:
	docker-compose run app bundle exec rails db:create db:migrate db:seed
dev:
	docker-compose run --rm -p 3000:3000/tcp app