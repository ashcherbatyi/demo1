
APP = demo
VERSION = latest
REGISTRY = quay.io/your_username

.PHONY: all clean get linux arm macos windows build image push format

all: linux arm macos windows

get:
	go get

linux: TARGETOS = linux
linux: TARGETARCH = amd64
linux: build image push

arm: TARGETOS = linux
arm: TARGETARCH = arm64
arm: build image push

macos: TARGETOS = darwin
macos: TARGETARCH = amd64
macos: build image push

windows: TARGETOS = windows
windows: TARGETARCH = amd64
windows: build image push

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o ${APP}-${TARGETOS}-${TARGETARCH}

format:
	go fmt ./...

image: build
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg BINARY=${APP}-${TARGETOS}-${TARGETARCH}

push: image
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	-rm -f ${APP}-linux-amd64 ${APP}-linux-arm64 ${APP}-darwin-amd64 ${APP}-windows-amd64.exe
	-docker rmi -f ${REGISTRY}/${APP}:${VERSION}-linux-amd64 || true
	-docker rmi -f ${REGISTRY}/${APP}:${VERSION}-linux-arm64 || true
	-docker rmi -f ${REGISTRY}/${APP}:${VERSION}-darwin-amd64 || true
	-docker rmi -f ${REGISTRY}/${APP}:${VERSION}-windows-amd64 || true
