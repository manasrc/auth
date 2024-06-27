#
# Builder
#

FROM rust:latest AS builder

RUN apt-get update
RUN apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/manasrc/auth
COPY . .

RUN cargo build --target x86_64-unknown-linux-musl --release

#
# Runner
#

FROM alpine:latest

RUN addgroup -g 1000 manasrc 
RUN adduser -D -s /bin/sh -u 1000 -G manasrc manasrc

WORKDIR /home/manasrc/auth/bin
COPY --from=builder /usr/src/manasrc/auth/target/x86_64-unknown-linux-musl/release/auth .

RUN chown manasrc:manasrc auth
USER manasrc 

EXPOSE 3000

CMD ["./auth"]
