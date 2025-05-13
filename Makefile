# sqlc
install_sqlc:
	@echo "Installing sqlc..."
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
	@echo "sqlc installed successfully."

# postgres
launch_postgres:
	@echo "Launching PostgreSQL..."
	docker run --name postgres_urls \
	-e POSTGRES_USER=postgres \
	-e POSTGRES_PASSWORD=PostgresPassword \
	-e POSTGRES_DB=urldb \
	-p 5432:5432 \
	-d postgres
	@echo "PostgreSQL launched successfully."

# redis
launch_redis:
	@echo "Launching Redis..."
	docker run --name redis_urls \
	-p 6379:6379 \
	-d redis
	@echo "Redis launched successfully."

# migrate
install_migrate:
	@echo "Installing migrate..."
	go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
	@echo "Migrate installed successfully."

databaseURL="postgres://postgres:PostgresPassword@localhost:5432/urldb?sslmode=disable"
migrate_up:
	@echo "Running migrations..."
	migrate -path="./database/migrate" -database=${databaseURL} up
	@echo "Migrations applied successfully."

migrate_drop:
	@echo "Dropping database..."
	migrate -path="./database/migrate" -database=${databaseURL} drop -f
	@echo "Database dropped successfully."

	