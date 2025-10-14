# --- STAGE 1: Build ---
FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# CGO_ENABLED=0 to build static binary.
# -ldflags="-w -s" to exclude debug info, reduce file size.
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /go-app .

# --- STAGE 2: Final ---
FROM alpine:3.18

COPY --from=builder /go-app /go-app

EXPOSE 8080

# Config a non-root user for more secure
RUN adduser -D nonroot
USER nonroot

CMD ["/go-app"]
