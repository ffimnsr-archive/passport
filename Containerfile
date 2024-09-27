FROM docker.io/library/rust:latest AS builder
WORKDIR /usr/src

RUN rustup target add x86_64-unknown-linux-musl
RUN apt update && apt install -y musl-tools

RUN cargo new passport-rs

WORKDIR /usr/src/passport-rs
COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --verbose --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=builder /usr/src/passport-rs/target/x86_64-unknown-linux-musl/release/passport-rs .
USER 1000

EXPOSE 8000
CMD ["./passport-rs"]
