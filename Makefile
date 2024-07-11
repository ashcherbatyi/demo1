# Універсальний Makefile для будь-якої платформи

APP = demo
VERSION = latest
REGISTRY = ghcr.io/ashcherbatyi


.PHONY: all clean get linux arm macos windows build image push format login

all: linux arm macos windows

get:
	go get

linux: TARGETOS = linux
linux: TARGETARCH = amd64
linux: login build image push

arm: TARGETOS = linux
arm: TARGETARCH = arm64
arm: login build image push

macos: TARGETOS = darwin
macos: TARGETARCH = amd64
macos: login build image push

windows: TARGETOS = windows
windows: TARGETARCH = amd64
windows: login build image push

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o ${APP}-${TARGETOS}-${TARGETARCH}

format:
	gofmt -s -w ./

get:
	go get

image: build
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg BINARY=${APP}-${TARGETOS}-${TARGETARCH}

push: image
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	@if [ -f ${APP}-linux-amd64 ]; then rm -f ${APP}-linux-amd64; fi
	@if [ -f ${APP}-linux-arm64 ]; then rm -f ${APP}-linux-arm64; fi
	@if [ -f ${APP}-darwin-amd64 ]; then rm -f ${APP}-darwin-amd64; fi
	@if [ -f ${APP}-windows-amd64.exe ]; then rm -f ${APP}-windows-amd64.exe; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-linux-amd64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-linux-amd64; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-linux-arm64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-linux-arm64; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-darwin-amd64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-darwin-amd64; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-windows-amd64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-windows-amd64; fi
