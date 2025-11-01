# 1. Build stage
FROM rust:1.88 as builder
WORKDIR /usr/src/relay
COPY . .
RUN cargo install --path .

# 2. Runtime stage (smaller image)
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /usr/local/cargo/bin/relay /app/relay

EXPOSE 7000
CMD ["./relay"]
