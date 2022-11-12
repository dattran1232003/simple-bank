# Build stage
FROM golang:1.19.3-alpine3.15 AS builder
# WITH LOVE <3

RUN apk add curl

WORKDIR /app

RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz

COPY . .
RUN go build -o main main.go

# Runtime
FROM alpine:3.15

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY db/migration ./migration
COPY start.sh .
COPY wait-for.sh .

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]