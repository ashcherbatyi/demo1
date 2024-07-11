FROM quay.io/projectquay/golang:1.20

ARG BINARY
COPY ${BINARY} /usr/local/bin/myapp
COPY . /app
WORKDIR /app

# Запуск тестів
CMD ["go", "test", "./..."]
