# -------------------------
# Build stage
# -------------------------
FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -o main ./cmd

# -------------------------
# Run stage
# -------------------------
FROM alpine:3.20

WORKDIR /app

# Copy only the built binary
COPY --from=builder /app/main .

EXPOSE 8000

CMD ["./main"]
