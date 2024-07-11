FROM quay.io/projectquay/golang:1.20

ARG BINARY
LABEL org.opencontainers.image.source=https://github.com/ashcherbatyi/demo
COPY ${BINARY} /usr/local/bin/myapp
COPY . /app
WORKDIR /app

# Запуск тестів
CMD ["go", "test", "./..."]
