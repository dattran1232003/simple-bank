postgres:
	docker network create local-pg; \
	docker run --name local-pg  -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -dp 5432:5432 --network=local-pg --restart=always -v local-pg:/var/lib/postgresql/data postgres:14-alpine

postgres-admin:
	docker run -dp 82:80 --name=local-pgadmin -v pgadmindata:/var/lib/pgadmin -e 'PGADMIN_DEFAULT_EMAIL=dattran1232003@gmail.com' -e 'PGADMIN_DEFAULT_PASSWORD=Datmaniac@1' --restart=always --network=local-pg dpage/pgadmin4


createdb:
	docker exec -it local-pg createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it local-pg dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/dattran1232003/simple-bank/db/sqlc Store

test:
	go test -v -cover ./...

server:
	go run .


.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test
