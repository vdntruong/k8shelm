# --- STAGE 1: Build ---
FROM rust:1.90.0-alpine AS builder

RUN apk add --no-cache musl-dev
# ENV RUSTFLAGS='-C target-feature=+crt-static'

WORKDIR /app

COPY Cargo.toml Cargo.lock ./

# Tạo một src/main.rs tạm thời để "giả" build (force Cargo to cache deps)
RUN mkdir src && \
    echo "fn main() {println!(\"caching\");}" > src/main.rs && \
    cargo build --release && \
    rm -rf src/

COPY src ./src

RUN cargo build --release

# --- STAGE 2: Final Image ---
FROM alpine:3.19

# Cài đặt SSL/TLS certificates
RUN apk update && apk add --no-cache ca-certificates

RUN adduser -D nonroot
USER nonroot

COPY --from=builder /app/target/release/rust-service /usr/local/bin/rust-service

EXPOSE 8080

CMD ["/usr/local/bin/rust-service"]
