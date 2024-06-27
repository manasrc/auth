#
# Builder
#

FROM --platform=linux/amd64 rust:1.79.0-alpine3.20 AS builder

RUN apk add --no-cache musl-dev
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/manasrc/auth
COPY . .

RUN cargo build --target x86_64-unknown-linux-musl --release

#
# Runner
#

FROM alpine:3.20

RUN addgroup -g 1000 manasrc 
RUN adduser -D -s /bin/sh -u 1000 -G manasrc manasrc

WORKDIR /home/manasrc/auth/bin
COPY --from=builder /usr/src/manasrc/auth/target/x86_64-unknown-linux-musl/release/auth .

RUN chown manasrc:manasrc auth
USER manasrc 

EXPOSE 3000

CMD ["./auth"]
