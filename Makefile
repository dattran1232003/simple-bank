postgres:
	docker run --name local-postgre  -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -dp 5432:5432 --network local-postgre --restart=always -v local-postgre:/var/lib/postgresql/data postgres:14-alpine

postgres-admin:
	docker run -dp 82:80 --name=local-pgadmin -v pgadmindata:/var/lib/pgadmin -e 'PGADMIN_DEFAULT_EMAIL=dattran1232003@gmail.com' -e 'PGADMIN_DEFAULT_PASSWORD=Datmaniac@1' --restart=always --network=local-pg dpage/pgadmin4


createdb:
	docker exec -it local-postgre createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it local-postgre dropdb simple_bank

test:
	go test -v -cover ./...

migrateup:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test
