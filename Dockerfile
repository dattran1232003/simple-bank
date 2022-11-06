# Build stage
FROM golang:1.19.3-alpine3.15 AS builder
# WITH LOVE <3

WORKDIR /app
COPY . .
RUN go build -o main main.go



# Runtime
FROM alpine:3.15
WORKDIR /app

COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8080
CMD ["/app/main"]